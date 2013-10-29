#!/usr/bin/perl -w
#############################################################################
##
## Copyright (C) 2012-2013 BogDan Vatra <bogdan@kde.org>
## Copyright (C) 2013 Digia Plc and/or its subsidiary(-ies).
## Contact: http://www.qt-project.org/legal
##
## This file is part of the test suite of the Qt Toolkit.
##
## $QT_BEGIN_LICENSE:LGPL$
## Commercial License Usage
## Licensees holding valid commercial Qt licenses may use this file in
## accordance with the commercial license agreement provided with the
## Software or, alternatively, in accordance with the terms contained in
## a written agreement between you and Digia.  For licensing terms and
## conditions see http://qt.digia.com/licensing.  For further information
## use the contact form at http://qt.digia.com/contact-us.
##
## GNU Lesser General Public License Usage
## Alternatively, this file may be used under the terms of the GNU Lesser
## General Public License version 2.1 as published by the Free Software
## Foundation and appearing in the file LICENSE.LGPL included in the
## packaging of this file.  Please review the following information to
## ensure the GNU Lesser General Public License version 2.1 requirements
## will be met: http://www.gnu.org/licenses/old-licenses/lgpl-2.1.html.
##
## In addition, as a special exception, Digia gives you certain additional
## rights.  These rights are described in the Digia Qt LGPL Exception
## version 1.1, included in the file LGPL_EXCEPTION.txt in this package.
##
## GNU General Public License Usage
## Alternatively, this file may be used under the terms of the GNU
## General Public License version 3.0 as published by the Free Software
## Foundation and appearing in the file LICENSE.GPL included in the
## packaging of this file.  Please review the following information to
## ensure the GNU General Public License version 3.0 requirements will be
## met: http://www.gnu.org/copyleft/gpl.html.
##
##
## $QT_END_LICENSE$
##
#############################################################################

use Cwd;
use Cwd 'abs_path';
use File::Basename;
use File::Temp 'tempdir';
use File::Path 'remove_tree';
use Getopt::Long;
use Pod::Usage;

### default options
my @stack = cwd;
my $device_serial=""; # "-s device_serial";
my $deployqt_device_serial=""; # "-device device_serial";
my $log_out="xml";
my $max_runtime = 5;
my $className="org.qtproject.qt5.android.bindings.QtActivity";
my $jobs = 4;
my $testsubset = "";
my $man = 0;
my $help = 0;
my $make_clean = 0;
my $time_out=400;
my $android_toolchain_version = "4.8";
my $host_arch = "linux-x86";
my $android_sdk_dir = "$ENV{'ANDROID_SDK_ROOT'}";
my $android_ndk_dir = "$ENV{'ANDROID_NDK_ROOT'}";
my $android_to_connect = "$ENV{'ANDROID_DEVICE'}";
my $ant_tool = `which ant`;
chomp $ant_tool;
my $strip_tool="";
my $readelf_tool="";
GetOptions('h|help' => \$help
            , man => \$man
            , 's|serial=s' => \$device_serial
            , 't|test=s' => \$testsubset
            , 'c|clean' => \$make_clean
            , 'j|jobs=i' => \$jobs
            , 'logtype=s' => \$log_out
            , 'runtime=i' => \$max_runtime
            , 'sdk=s' => \$android_sdk_dir
            , 'ndk=s' => \$android_ndk_dir
            , 'toolchain=s' => \$android_toolchain_version
            , 'host=s' => \$host_arch
            , 'ant=s' => \$ant_tool
            , 'strip=s' => \$strip_tool
            , 'readelf=s' => \$readelf_tool
            , 'testcase=s' => \$testcase
            ) or pod2usage(2);
pod2usage(1) if $help;
pod2usage(-verbose => 2) if $man;

my $adb_tool="$android_sdk_dir/platform-tools/adb";

# For CI. Nodes are connecting to test devices over IP, which is stored to env variable
if ($android_to_connect ne ""){
    print " Found device to be connected from env: $android_to_connect \n";
    system("$adb_tool disconnect $android_to_connect");
    system("$adb_tool connect $android_to_connect");
    sleep(2);# let it connect
    system("$adb_tool -s $android_to_connect reboot &");# adb bug, it blocks forever
    sleep(15); # wait for the device to come up again
    system("$adb_tool disconnect $android_to_connect");# cleans up the left adb reboot process
    system("$adb_tool connect $android_to_connect");
    $device_serial =$android_to_connect;
}

system("$adb_tool devices") == 0 or die "No device found, please plug/start at least one device/emulator\n"; # make sure we have at least on device attached

$deployqt_device_serial = "--device $device_serial" if ($device_serial);
$device_serial = "-s $device_serial" if ($device_serial);
$testsubset="/$testsubset" if ($testsubset);

$strip_tool="$android_ndk_dir/toolchains/arm-linux-androideabi-$android_toolchain_version/prebuilt/$host_arch/bin/arm-linux-androideabi-strip" unless($strip_tool);
$readelf_tool="$android_ndk_dir/toolchains/arm-linux-androideabi-$android_toolchain_version/prebuilt/$host_arch/bin/arm-linux-androideabi-readelf"  unless($readelf_tool);
$readelf_tool="$readelf_tool -d -w ";

sub dir
{
#    print "@stack\n";
}

sub pushd ($)
{
    unless ( chdir $_[0] )
    {
        warn "Error: $!\n";
        return;
    }
    unshift @stack, cwd;
    dir;
}

sub popd ()
{
    @stack > 1 and shift @stack;
    chdir $stack[0];
    dir;
}


sub waitForProcess
{
    my $process=shift;
    my $action=shift;
    my $timeout=shift;
    my $sleepPeriod=shift;
    $sleepPeriod=1 if !defined($sleepPeriod);
    print "Waiting for $process ".$timeout*$sleepPeriod." seconds to";
    print $action?" start...\n":" die...\n";
    while ($timeout--)
    {
        my $output = `$adb_tool $device_serial shell ps 2>&1`; # get current processes
        #FIXME check why $output is not matching m/.*S $process\n/ or m/.*S $process$/ (eol)
        my $res=($output =~ m/.*S $process/)?1:0; # check the procress
        if ($action == $res)
        {
            print "... succeed\n";
            return 1;
        }
        sleep($sleepPeriod);
        print "timeount in ".$timeout*$sleepPeriod." seconds\n"
    }
    print "... failed\n";
    return 0;
}

my $src_dir_qt=abs_path(dirname($0)."/../../..");
my $quadruplor_dir="$src_dir_qt/tests/auto/android";
my $qmake_path="$src_dir_qt/bin/qmake";
my $tests_dir="$src_dir_qt/tests$testsubset";
my $temp_dir=tempdir(CLEANUP => 1);
my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time);
my $output_dir=$stack[0]."/".(1900+$year)."-$mon-$mday-$hour:$min";
mkdir($output_dir);
unlink("latest");
system(" ln -s $output_dir latest");
my $sdk_api=0;
my $output = `$adb_tool $device_serial shell getprop`; # get device properties
if ($output =~ m/.*\[ro.build.version.sdk\]: \[(\d+)\]/)
{
    $sdk_api=int($1);
    $sdk_api=5 if ($sdk_api>5 && $sdk_api<8);
    $sdk_api=9 if ($sdk_api>9);
}

sub startTest
{
    my $testName = shift;
    my $packageName = "org.qtproject.example.tst_$testName";
    my $intentName = "$packageName/org.qtproject.qt5.android.bindings.QtActivity";
    my $output_file = shift;
    my $get_xml= 0;
    my $get_txt= 0;
    my $testLib ="";
    if ($log_out eq "xml") {
        $testLib="-o /data/data/$packageName/output.xml,xml";
        $get_xml = 1;
    } elsif ($log_out eq "txt") {
        $testLib="-o /data/data/$packageName/output.txt,txt";
        $get_txt = 1;
    } else {
        $testLib="-o /data/data/$packageName/output.xml,xml -o /data/data/$packageName/output.txt,txt";
        $get_xml = 1;
        $get_txt = 1;
    }

    system("$adb_tool $device_serial shell am start -e applicationArguments \"$testLib\" -n $intentName"); # start intent
    #wait to start (if it has not started and quit already)
    waitForProcess($packageName,1,10);

    #wait to stop
    unless(waitForProcess($packageName,0,$time_out,5))
    {
        #killProcess($packageName);
        print "Someone should kill $packageName\n";
        return 1;
    }
    system("$adb_tool $device_serial pull /data/data/$packageName/output.xml $output_dir/$output_file.xml") if ($get_xml);
    system("$adb_tool $device_serial pull /data/data/$packageName/output.txt $output_dir/$output_file.txt") if ($get_txt);
    return 1;
}

########### build qt tests and benchmarks ###########
pushd($tests_dir);
print "Building $tests_dir \n";
system("make distclean") if ($make_clean);
system("$qmake_path -r") == 0 or die "Can't run qmake\n"; #exec qmake
system("make -j$jobs") == 0 or warn "Can't build all tests\n"; #exec make

my $testsFiles = "";
if ($testcase) {
    $testsFiles=`find . -name libtst_$testcase.so`; # only tests
} else {
    $testsFiles=`find . -name libtst_*.so`; # only tests
}

foreach (split("\n",$testsFiles))
{
    chomp; #remove white spaces
    pushd(abs_path(dirname($_))); # cd to application dir
    system("make INSTALL_ROOT=$temp_dir install"); # install the application to temp dir
    my $application=basename(cwd);
    system("androiddeployqt --install $deployqt_device_serial --output $temp_dir --deployment debug --verbose --input android-libtst_$application.so-deployment-settings.json");
    my $output_name=dirname($_);
    $output_name =~ s/\.//;   # remove first "." character
    $output_name =~ s/\///;   # remove first "/" character
    $output_name =~ s/\//_/g; # replace all "/" with "_"
    $output_name=$application unless($output_name);
    $time_out=$max_runtime*60/5; # 5 minutes time out for a normal test

    $applicationLibrary = `find $temp_dir -name libtst_bench_$application.so`;

    if ($applicationLibrary)
    {
        $time_out=5*60/5; # 10 minutes for a benchmark
        $application = "bench_$application";
    }
    else
    {
        $applicationLibrary = `find $temp_dir -name libtst_$application.so`;
    }

    if (!$applicationLibrary)
    {
        print "Can't find application binary libtst_$application.so in $temp_dir!\n";
    }
    else
    {
         startTest($application, "$output_name") or warn "Can't run $application ...\n";
    }

    popd();
    remove_tree( $temp_dir, {keep_root => 1} );
}
popd();

__END__

=head1 NAME

Script to run all qt tests/benchmarks to an android device/emulator

=head1 SYNOPSIS

runtests.pl [options]

=head1 OPTIONS

=over 8

=item B<-s --serial = serial>

Device serial number. May be empty if only one device is attached.

=item B<-t --test = test_subset>

Tests subset (e.g. benchmarks, auto, auto/qbuffer, etc.).

=item B<-c --clean>

Clean tests before building them.

=item B<-j --jobs = number>

Make jobs when building tests.

=item B<--sdk = sdk_path>

Android SDK path.

=item B<--ndk = ndk_path>

Android NDK path.

=item B<--ant = ant_tool_path>

Ant tool path.

=item B<--strip = strip_tool_path>

Android strip tool path, used to deploy qt libs.

=item B<--readelf = readelf_tool_path>

Android readelf tool path, used to check if a test application uses qt OpenGL.

=item B<--logtype = xml|txt|both>

The format of log file, default is xml.

=item B<--runtime = minutes>

The timeout period before stopping individual tests from running.

=item B<-h  --help>

Print a brief help message and exits.

=item B<--man>

Prints the manual page and exits.

=back

=head1 DESCRIPTION

B<This program> will run all qt tests/benchmarks to an android device/emulator.

=cut
