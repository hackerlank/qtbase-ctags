HEADERS       = window.h
SOURCES       = main.cpp \
                window.cpp

# install
target.path = $$[QT_INSTALL_EXAMPLES]/qtbase/dialogs/findfiles
sources.files = $$SOURCES $$HEADERS *.pro
sources.path = $$[QT_INSTALL_EXAMPLES]/qtbase/dialogs/findfiles
INSTALLS += target sources

symbian: CONFIG += qt_example
QT += widgets
maemo5: CONFIG += qt_example
