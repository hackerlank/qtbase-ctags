HEADERS += \
    $$PWD/qevdevmousehandler_p.h \
    $$PWD/qevdevmousemanager_p.h

SOURCES += \
    $$PWD/qevdevmousehandler.cpp \
    $$PWD/qevdevmousemanager.cpp

contains(QT_CONFIG, libudev) {
    LIBS += $$QMAKE_LIBS_LIBUDEV
}

