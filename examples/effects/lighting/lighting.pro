SOURCES += main.cpp lighting.cpp
HEADERS += lighting.h

# install
target.path = $$[QT_INSTALL_EXAMPLES]/qtbase/effects/lighting
sources.files = $$SOURCES $$HEADERS $$RESOURCES $$FORMS lighting.pro
sources.path = $$[QT_INSTALL_EXAMPLES]/qtbase/effects/lighting
INSTALLS += target sources

symbian: CONFIG += qt_example
maemo5: CONFIG += qt_example

