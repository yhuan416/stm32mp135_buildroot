/******************************************************************
Copyright © Deng Zhimao Co., Ltd. 2021-2030. All rights reserved.
* @projectName   desktop
* @brief         Lyric.qml
* @author        Deng Zhimao
* @email         dengzhimao@alientek.com
* @link          www.openedv.com
* @date          2021-09-13
*******************************************************************/

import QtQuick 2.0
import dataModel 1.0
import QtQuick.Controls 2.5
import QtQuick 2.2
import QtQuick.Controls 1.1
import QtQuick.Controls.Styles 1.1
import QtQuick.Dialogs 1.1

import QtMultimedia 5.0
import QtQuick 2.4

Item {
    property int currentIndex: -1
    onCurrentIndexChanged: {
        music_lyric.currentIndex = currentIndex
    }

    Text {
        anchors.top: parent.top
        anchors.topMargin: 20
        anchors.left: parent.left
        anchors.horizontalCenter: parent.horizontalCenter
        //text: musicPlayer.playbackState === Audio.PlayingState ? music_playlistModel.getcurrentTitle() : ""
        text: musicPlayer.status === Audio.Buffered ? music_playlistModel.getcurrentTitle() : ""
        color: "#f0f0f0"
        font.family: "Montserrat Regular"
        font.pixelSize: 20
    }

    Text {
        anchors.top: parent.top
        anchors.topMargin: 60
        anchors.left: parent.left
        anchors.horizontalCenter: parent.horizontalCenter
        text: musicPlayer.status === Audio.Buffered ? music_playlistModel.getcurrentAuthor() : ""
        color: "#f0f0f0"
        font.family: "Montserrat Regular"
        font.pixelSize: 20
    }

    Rectangle {
        id: cutLine
        height: 1
        color: "#b5b5b5"
        width: parent.width - 50
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.topMargin: 95
    }

    ListView {
        anchors.top: parent.top
        anchors.topMargin: 100
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 80
        width: parent.width
        id: music_lyric
        spacing: 35
        clip: true
        highlightRangeMode: ListView.StrictlyEnforceRange
        preferredHighlightBegin: 0
        preferredHighlightEnd: (music_lyric.height) / 2
        highlight: Rectangle {
            color: Qt.rgba(0, 0, 0, 0)
            Behavior on y {
                SmoothedAnimation {
                    duration: 300
                }
            }
        }
        model: music_lyricModel
        delegate: Rectangle {
            width: parent.width
            height: 13
            color: Qt.rgba(0,0,0,0)
            Text {
                anchors.left: parent.left
                horizontalAlignment: Text.AlignLeft
                text: textLine
                color: parent.ListView.isCurrentItem ? "#f29c9f" : "#ffffff"
                font.pixelSize: parent.ListView.isCurrentItem ? 20 : 15
                font.bold: parent.ListView.isCurrentItem
                font.family: "Montserrat Light"
            }
        }
    }
}
