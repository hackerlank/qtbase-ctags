######################################################################
# Automatically generated by qmake (2.01a) Thu Oct 4 19:01:12 2007
######################################################################

TEMPLATE = app
DEPENDPATH += .
INCLUDEPATH += .

# Input
SOURCES += main.cpp
SOURCES += glwidget.cpp
SOURCES += mainwindow.cpp
SOURCES += bubble.cpp

HEADERS += glwidget.h
HEADERS += mainwindow.h
HEADERS += bubble.h

RESOURCES += texture.qrc
QT += opengl widgets

# install
target.path = $$[QT_INSTALL_EXAMPLES]/qtbase/opengl/hellogl_es
sources.files = $$SOURCES $$HEADERS $$RESOURCES $$FORMS hellogl_es.pro
sources.path = $$[QT_INSTALL_EXAMPLES]/qtbase/opengl/hellogl_es
INSTALLS += target sources

symbian: CONFIG += qt_example
maemo5: CONFIG += qt_example

symbian: warning(This example might not fully work on Symbian platform)
maemo5: warning(This example does not work on Maemo platform)
simulator: warning(This example might not fully work on Simulator platform)
