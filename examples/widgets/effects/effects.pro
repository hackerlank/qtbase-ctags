TEMPLATE      = \
              subdirs
SUBDIRS       = \
              blurpicker \
              lighting \
              fademessage

# install
target.path = $$[QT_INSTALL_EXAMPLES]/widgets/effects
sources.files = $$SOURCES $$HEADERS $$RESOURCES $$FORMS effects.pro README
sources.path = $$[QT_INSTALL_EXAMPLES]/widgets/effects
INSTALLS += target sources

QT += widgets
