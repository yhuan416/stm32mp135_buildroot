QT += gui core quick network quickwidgets

greaterThan(QT_MAJOR_VERSION, 4): QT += widgets

SOURCES += \
    $$PWD/cameraitem.cpp

RESOURCES += \
    $$PWD/camera_icons.qrc \
    $$PWD/camera_qml.qrc

HEADERS += \
    $$PWD/cameraitem.h \
    $$PWD/capture_thread.h \
    $$PWD/photo_thread.h
