QT_SVG_VERSION = $$QT_VERSION
QT_SVG_MAJOR_VERSION = $$QT_MAJOR_VERSION
QT_SVG_MINOR_VERSION = $$QT_MINOR_VERSION
QT_SVG_PATCH_VERSION = $$QT_PATCH_VERSION

QT.svg.name = QtSvg
QT.svg.includes = $$QT_MODULE_INCLUDE_BASE/QtSvg
QT.svg.private_includes = $$QT_MODULE_INCLUDE_BASE/QtSvg/private
QT.svg.sources = $$QT_MODULE_BASE/src/svg
QT.svg.libs = $$QT_MODULE_LIB_BASE
QT.svg.depends = core gui
