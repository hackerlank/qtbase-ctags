############################################################
# Project file for autotest for gui/opengl functionality
############################################################

CONFIG += testcase
TARGET = tst_qopengl
QT += gui gui-private core-private testlib

SOURCES   += tst_qopengl.cpp

CONFIG += insignificant_test
