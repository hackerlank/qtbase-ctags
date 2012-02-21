QT -= gui
CONFIG += qdbus

HEADERS += ping-common.h pong.h
SOURCES += pong.cpp

target.path = $$[QT_INSTALL_EXAMPLES]/qtbase/dbus/pingpong
sources.files = $$SOURCES $$HEADERS $$RESOURCES *.pro
sources.path = $$[QT_INSTALL_EXAMPLES]/qtbase/dbus/pingpong
INSTALLS += target sources

simulator: warning(This example does not work on Simulator platform)
