######################################################################
# Automatically generated by qmake (2.01a) Thu Oct 4 19:01:12 2007
######################################################################

TEMPLATE = app
TARGET = 
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
QT += opengl

# install
target.path = $$[QT_INSTALL_EXAMPLES]/qtbase/opengl/hellogl_es2
sources.files = $$SOURCES $$HEADERS $$RESOURCES $$FORMS hellogl_es2.pro
sources.path = $$[QT_INSTALL_EXAMPLES]/qtbase/opengl/hellogl_es2
INSTALLS += target sources
