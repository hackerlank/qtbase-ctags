mac:contains(QT_CONFIG, coreservices) {
    INCLUDEPATH += $$PWD

    HEADERS += \
        $$PWD/cglconvenience_p.h

    OBJECTIVE_SOURCES += \
        $$PWD/cglconvenience.mm

    LIBS += -framework Cocoa -framework OpenGL
}
