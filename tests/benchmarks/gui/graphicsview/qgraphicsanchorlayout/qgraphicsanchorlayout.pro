load(qttest_p4)

# do not run benchmarks by default in 'make check'
CONFIG -= testcase

TEMPLATE = app
TARGET = tst_bench_qgraphicsanchorlayout

SOURCES += tst_qgraphicsanchorlayout.cpp

