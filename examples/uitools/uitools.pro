TEMPLATE      = subdirs
SUBDIRS       = multipleinheritance

!wince*:!symbian:contains(QT_BUILD_PARTS, tools): SUBDIRS += textfinder

# install
target.path = $$[QT_INSTALL_EXAMPLES]/qtbase/uitools
sources.files = $$SOURCES $$HEADERS $$RESOURCES $$FORMS uitools.pro README
sources.path = $$[QT_INSTALL_EXAMPLES]/qtbase/uitools
INSTALLS += target sources

symbian: include($$QT_SOURCE_TREE/examples/symbianpkgrules.pri)
