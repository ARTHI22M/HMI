QT += quick quick3d
QT += quickcontrols2
QT += quick
QT += core sql
target.path = $$[QT_INSTALL_EXAMPLES]/quick3d/lights

INSTALLS += target

SOURCES += \
    backend.cpp \
    bridge.cpp \
    custom.cpp \
    main.cpp \
    program.cpp

RESOURCES += \
    qml.qrc

OTHER_FILES += \
    doc/src/*.*

HEADERS += \
    backend.h \
    bridge.h \
    custom.h \
    program.h
