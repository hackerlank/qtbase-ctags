CONFIG += testcase
TARGET = tst_exceptionsafety_objects
QT += widgets testlib
HEADERS += oomsimulator.h 3rdparty/valgrind.h 3rdparty/memcheck.h
SOURCES += tst_exceptionsafety_objects.cpp

CONFIG+=insignificant_test
