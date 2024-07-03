/******************************************************************
Copyright © Deng Zhimao Co., Ltd. 2021-2030. All rights reserved.
* @projectName   desktop
* @brief         PlayPanel.qml
* @author        Deng Zhimao
* @email         dengzhimao@alientek.com
* @link          www.openedv.com
* @date          2021-09-13
*******************************************************************/
import QtQuick 2.0
import dataModel 1.0
import QtQuick.Controls 2.5
import QtQuick 2.2

import QtMultimedia 5.0
import QtQuick 2.4

Item {
    property bool btnplayChecked:  false
    property bool progress_pressed:  false
    property int progress_maximumValue: 0
    property int progress_value: 0
    property int music_loopMode: 2

    MouseArea {
        enabled: false
        id: playPanelMouseArea
        anchors.fill: parent
        onClicked: music_cd_dawer_bottom.open()
    }

    onProgress_maximumValueChanged:  {
        progress_control.to = progress_maximumValue
    }

    onBtnplayCheckedChanged: {
        btnplay.checked = btnplayChecked
    }

    onProgress_valueChanged: {
        progress_control.value = progress_value
    }

    function currentMusicTime(time){
        var sec = Math.floor(time / 1000)
        var hours = Math.floor(sec / 3600)
        var minutes = Math.floor((sec - hours * 3600) / 60)
        var seconds = sec - hours * 3600 - minutes * 60
        var hh, mm, ss
        if(hours.toString().length < 2)
            hh = "0" + hours.toString()
        else
            hh = hours.toString()
        if(minutes.toString().length < 2)
            mm="0" + minutes.toString()
        else
            mm = minutes.toString()
        if(seconds.toString().length < 2)
            ss = "0" + seconds.toString()
        else
            ss = seconds.toString()
        return /*hh+":"*/ + mm + ":" + ss
    }

    Button {
        visible: false
        id: btnprevious
        anchors.verticalCenter: btnplay.verticalCenter
        anchors.right: btnplay.left
        anchors.rightMargin: 20
        width: 32
        height: 32
        onClicked: {
            if (music_playlistModel.currentIndex - 1 !== -1 ) {
                music_playlistModel.setPCM(false)
            }
            switch (btnloopMode.loopMode) {
            case 0:
            case 1:
            case 2:
                music_playlistModel.currentIndex--
                musicPlayer.play()
                break
            case 3:
                music_playlistModel.randomIndex()
                musicPlayer.play()
                break
            }
        }
    }

    Button {
        id: btnplay
        visible: false
        anchors.verticalCenter : parent.verticalCenter
        anchors.right: btnforward.left
        anchors.rightMargin: 20
        width: 60
        height: 60
        checkable: true
        checked: false

        onClicked: {
            music_playlistModel.setPCM(false)
            if (playList.musicCount === 0)
                return
            if (music_playlistModel.currentIndex !== -1) {
                musicPlayer.source =  music_playlistModel.getcurrentPath()
                playList.music_currentIndex = music_playlistModel.currentIndex
                musicPlayer.playbackState === Audio.PlayingState ? musicPlayer.pause() : musicPlayer.play()
            }
        }
    }

    Button {
        id: btnforward
        anchors.verticalCenter: parent.verticalCenter
        width: 60
        height: 60
        visible: false
        onClicked: {
            music_playlistModel.setPCM(false)
            switch (btnloopMode.loopMode) {
            case 0:
            case 1:
            case 2:
                music_playlistModel.currentIndex ++
                musicPlayer.play()
                break
            case 3:
                music_playlistModel.randomIndex()
                musicPlayer.play()
                break
            }
        }
    }

    Row {
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.horizontalCenter
        anchors.leftMargin: -50
        spacing: (parent.width / 2 + 30 -playPanel_play_time.width - btnloopMode.width - btnRotation.width - btnplayList.width ) / 3
        anchors.right: parent.right
        anchors.rightMargin: 20
        Text{
            id: playPanel_play_time
            anchors.verticalCenter: parent.verticalCenter
            text: currentMusicTime(progress_value) + "/" + currentMusicTime(progress_maximumValue)
            color: "white"
            width: 120
            font.pixelSize: 25
            font.bold: true
            font.family: "Montserrat Light"
        }

        Button {
            id: btnloopMode
            height: 40
            width: 40
            anchors.verticalCenter: parent.verticalCenter
            property int loopMode: 2
            onClicked: {
                loopMode++
                music_loopMode = loopMode % 4
            }
            background: Image {
                id: imgloopMode
                anchors.fill: parent
                fillMode: Image.PreserveAspectFit
                source: {
                    switch (music_loopMode) {
                    case 1:
                        return "qrc:/icons/btn_listscircle_single.png"
                    case 2:
                        return "qrc:/icons/btn_listjump.png"
                    case 3:
                        return "qrc:/icons/btn_listrandom.png"
                    default:
                        return "qrc:/icons/btn_listsingle.png"
                    }
                }
            }
        }

        Button {
            id: btnRotation
            width: 40
            height: 40
            visible: true
            anchors.verticalCenter: parent.verticalCenter
            checkable: true
            checked: false
            background: Image {
                anchors.fill: parent
                source: btnRotation.checked ? "qrc:/icons/btn_rotation_on.png"
                                            : "qrc:/icons/btn_rotation_off.png"
            }
            onCheckedChanged: {
                cd_roation = checked
            }
        }

        Button {
            id: btnplayList
            anchors.verticalCenter: parent.verticalCenter
            width: 40
            height: 40
            onClicked: {
                music_playlist_dawer_bottom.open()
            }
            background: Image {
                anchors.fill: parent
                source: "qrc:/icons/btn_playlist.png"
                opacity: btnplayList.hovered ? 0.7 : 1.0
            }
        }
    }

    /*Timer {
        interval: 200
        id: silder_enable_timer
        repeat: false
        onTriggered: {
            progress_control.enabled = true
        }
    }*/

    Slider {
        id: progress_control
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.leftMargin: 50
        anchors.rightMargin: 50
        height: 70
        anchors.right: parent.horizontalCenter
        stepSize: 1
        property bool handled: false
        from: 0
        live: false
        to: 1000000
        value: 0
        onPressedChanged: {
            handled = true
            progress_pressed = progress_control.pressed
            //progress_control.enabled = !progress_control.pressed//?
            //if (!pressed)
            //progress_control.enabled = false
            //silder_enable_timer.start()
        }

        onValueChanged: {
            if (handled && musicPlayer.seekable) {
                //musicPlayer.volume = 0.0
                music_playlistModel.setPCM(false)
                pcmTimer.restart()
                music_lyricModel.findIndex(value)
                musicPlayer.seek(value)
                musicPlayer.play()
                handled = false
            } else {
                music_lyricModel.getIndex(value)
            }
        }
        background: Rectangle {
            x: progress_control.leftPadding
            y: progress_control.topPadding + progress_control.availableHeight / 2 - height / 2
            implicitWidth: 200
            implicitHeight: 8
            width: progress_control.availableWidth
            height: 8
            radius: 4
            color: "#55808080"

            Rectangle {
                width: progress_control.visualPosition * parent.width
                height: parent.height
                color: "#f29c9f"
                radius: 4
            }
        }

        handle: Rectangle {
            x: progress_control.leftPadding + progress_control.visualPosition * (progress_control.availableWidth - width)
            y: progress_control.topPadding + progress_control.availableHeight / 2 - height / 2
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
                        color: "#f29c9f"
                        width: 10
                        height: width
                        radius: width / 2
                    }
                }
            }
        }
    }

    Connections{
        target: app_music
        onPlayBtnSignal:{
            btnplay.clicked()
        }
        onPreviousBtnSignal: {
            btnprevious.clicked()
        }
        onNextBtnSignal: {
            btnforward.clicked()
        }
    }
}
