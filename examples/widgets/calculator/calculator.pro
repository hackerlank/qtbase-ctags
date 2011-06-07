HEADERS       = button.h \
                calculator.h
SOURCES       = button.cpp \
                calculator.cpp \
                main.cpp

# install
target.path = $$[QT_INSTALL_EXAMPLES]/qtbase/widgets/calculator
sources.files = $$SOURCES $$HEADERS $$RESOURCES $$FORMS calculator.pro
sources.path = $$[QT_INSTALL_EXAMPLES]/qtbase/widgets/calculator
INSTALLS += target sources

symbian {
    TARGET.UID3 = 0xA000C602
    CONFIG += qt_example
}
maemo5: CONFIG += qt_example

