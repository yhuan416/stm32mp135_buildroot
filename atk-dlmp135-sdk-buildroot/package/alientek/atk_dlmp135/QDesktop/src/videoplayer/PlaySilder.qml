import QtQuick 2.0

import QtQuick.Controls 2.5
import QtQuick 2.2

Item {
    Connections{
        target: app_VideoPlayer
        onMediaDuratrionChaged: {
            media_play_Hprogress.to = mediaPlayer.duration
            media_play_Vprogress.to = mediaPlayer.duration
        }
        onMediaPositonChaged: {
            media_play_Hprogress.value = mediaPlayer.position
            media_play_Vprogress.value  = mediaPlayer.duration - mediaPlayer.position

        }
    }

    Slider {
        id: media_play_Hprogress
        height: parent.height
        width: parent.width - 300
        anchors.centerIn: parent
        from: 0
        stepSize: 10
        anchors.top: parent.top
        orientation: Qt.Horizontal
        visible: !fullScreenFlag
        onVisibleChanged: {
            if (!visible)
                progress_pressed = false
        }
        onPressedChanged: {
            progress_pressed = media_play_Hprogress.pressed
            if (!media_play_Hprogress.pressed && mediaPlayer.seekable) {
                mediaPlayer.setPosition(value)
                mediaPlayer.play()
            }
            if (media_play_Hprogress.pressed)
                timeCountToHide.stop()
            else
                timeCountToHide.start()
        }

        onValueChanged: {

        }
        background: Rectangle {
            x: media_play_Hprogress.leftPadding
            y: media_play_Hprogress.topPadding + media_play_Hprogress.availableHeight / 2 - height / 2
            implicitWidth: 200
            implicitHeight: 8
            width: media_play_Hprogress.availableWidth
            height: 8
            radius: 4
            color: "#55808080"

            Rectangle {
                width: media_play_Hprogress.visualPosition * parent.width
                height: parent.height
                color: "#8dcff4"
                radius: 4
            }
        }

        handle: Rectangle {
            x: media_play_Hprogress.leftPadding + media_play_Hprogress.visualPosition * (media_play_Hprogress.availableWidth - width)
            y: media_play_Hprogress.topPadding + media_play_Hprogress.availableHeight / 2 - height / 2
            implicitWidth: 30
            implicitHeight: 30
            color: "transparent"
            Rectangle {
                anchors.centerIn: parent
                width: parent.width
                height: parent.height
                color: "#55ffffff"
                radius: width / 2
                Rectangle {
                    anchors.centerIn: parent
                    color: "#ffffff"
                    width: parent.width - 8
                    height: width
                    radius: width / 2
                    Rectangle {
                        anchors.centerIn: parent
                        color: "#8dcff4"
                        width: 10
                        height: width
                        radius: width / 2
                    }
                }
            }
        }
    }

    Slider {
        id: media_play_Vprogress
        anchors.centerIn: parent
        height: parent.height -  400
        width: parent.width
        stepSize: 10
        from: 0
        orientation: Qt.Vertical
        visible: fullScreenFlag
        onPressedChanged: {
            progress_pressed = media_play_Vprogress.pressed
            if (!media_play_Vprogress.pressed && mediaPlayer.seekable) {
                mediaPlayer.setPosition(media_play_Vprogress.to - value)
                mediaPlayer.play()
            }
            if (media_play_Vprogress.pressed)
                timeCountToHide.stop()
            else
                timeCountToHide.start()
        }

        onVisibleChanged: {
            if (!visible)
                progress_pressed = false
        }

        onValueChanged: {
            // color: "#d6530c"
        }
        background: Rectangle {
            y: media_play_Vprogress.leftPadding
            x: media_play_Vprogress.topPadding + media_play_Vprogress.availableWidth / 2 - width / 2
            implicitWidth: 8
            implicitHeight: 200
            height: media_play_Vprogress.availableHeight
            width: 8
            radius: 4
            color: "#55808080"

            Rectangle {
                width: 8
                height: media_play_Vprogress.visualPosition * parent.height
                color: "#8dcff4"
                radius: 4
            }
        }

        handle: Rectangle {
            y: media_play_Vprogress.leftPadding + media_play_Vprogress.visualPosition * (media_play_Vprogress.availableHeight - height)
            x: media_play_Vprogress.topPadding + media_play_Vprogress.availableWidth / 2 - width / 2
            implicitWidth: 30
            implicitHeight: 30
            color: "transparent"
            Rectangle {
                anchors.centerIn: parent
                width: parent.width
                height: parent.height
                color: "#55ffffff"
                radius: width / 2
                Rectangle {
                    anchors.centerIn: parent
                    color: "#ffffff"
                    width: parent.width - 8
                    height: width
                    radius: width / 2
                    Rectangle {
                        anchors.centerIn: parent
                        color: "#8dcff4"
                        width: 10
                        height: width
                        radius: width / 2
                    }
                }
            }
        }
    }
}
