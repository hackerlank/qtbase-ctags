TEMPLATE      = lib
QT            = core
CONFIG       += plugin
HEADERS       = plugin2.h
SOURCES       = plugin2.cpp
TARGET        = $$qtLibraryTarget(plugin2)
DESTDIR       = ../bin

# This is testdata for the tst_qpluginloader test.
target.path = $$[QT_INSTALL_TESTS]/tst_qfactoryloader/bin
INSTALLS += target
