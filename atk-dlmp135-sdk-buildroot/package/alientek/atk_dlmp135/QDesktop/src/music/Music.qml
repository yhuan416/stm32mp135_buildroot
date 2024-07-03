/******************************************************************
Copyright © Deng Zhimao Co., Ltd. 2021-2030. All rights reserved.
* @projectName   QDesktop
* @brief         Music.qml
* @author        Deng Zhimao
* @email         dengzhimao@alientek.com
* @link          www.openedv.com
* @date          2020-06-05
*******************************************************************/
import dataModel 1.0
import QtQuick.Controls 2.5
import QtQuick 2.2
import QtQuick.Controls 1.1
import QtQuick.Controls.Styles 1.1
import QtQuick.Dialogs 1.1

import QtMultimedia 5.0
import QtQuick 2.4
import QtQuick 2.0

Item {
    id: app_music
    y: app_music.height
    x: 0
    opacity: 0
    property real showPropertyChangeOpacity: 1
    property real showPropertyChangeX: 0
    property real showPropertyChangeY: 0
    property bool show: false
    property bool head_start_runing: false
    property bool head_stop_runing: false
    property int lyric_CurrtentIndex: -1
    property int head_roation: 0
    property bool cd_roation: false
    signal playBtnSignal()
    signal previousBtnSignal()
    signal nextBtnSignal()

    state: ""
    states:[
        State {
            name: "show"
            PropertyChanges {
                target: app_music
                opacity: showPropertyChangeOpacity
                x: showPropertyChangeX
                y: showPropertyChangeY
            }
            when: !show
        }
    ]

    transitions: Transition {
        NumberAnimation{properties: "x,y"; easing.type: Easing.InOutQuad; duration: 0}
        NumberAnimation{properties: "opacity"; easing.type: Easing.InOutQuad; duration: 0}
    }

    function songsInit(){
        music_playlistModel.add(appCurrtentDir)
    }

    Component.onCompleted: {
        songsInit()
    }

    Rectangle {
        anchors.fill: parent
        color: "#eff2f7"
    }

    Timer {
        id: pcmTimer
        interval: 500
        running: false
        repeat: false
        onTriggered: {
            //musicPlayer.volume = global_system_volume
            music_playlistModel.setPCM(true)
        }
    }

    Connections{
        target: app_music
        onPlayBtnSignal:{
            //musicPlayer.volume = 0.0
            pcmTimer.restart()
        }
        onPreviousBtnSignal: {
            //musicPlayer.volume = 0.0
            pcmTimer.restart()
        }
        onNextBtnSignal: {
            //musicPlayer.volume = 0.0
            pcmTimer.restart()
        }
    }

    Audio {
        id: musicPlayer
        source: ""
        volume: global_system_volume
        //Behavior on volume { PropertyAnimation { duration: 500 ; easing.type: Easing.Linear } }
        autoPlay: false
        onSourceChanged: {
            music_lyricModel.setPathofSong(source, appCurrtentDir);
            //console.log( musicPlayer.volume);
        }
        onPositionChanged: {
            playPanel.progress_maximumValue = duration;
            if(!playPanel.progress_pressed) {
                playPanel.progress_value = position
            }
        }
        onPlaybackStateChanged: {
            switch (playbackState) {
            case Audio.PlayingState:
                playPanel.btnplayChecked = true
                head_start_runing = true
                break;
            case Audio.PausedState:
            case Audio.StoppedState:
                if (head_roation != -45)
                    head_stop_runing = true
                playPanel.btnplayChecked = false
                break;
            default:
                playPanel.btnplayChecked = false
                head_stop_runing = true
                break;
            }
        }
        onStatusChanged: {
            switch (status) {
            case Audio.NoMedia:
                //console.log("status:nomedia");
                break;
            case Audio.Loading:
                //console.log("status:loading");
                break;
            case Audio.Loaded:
                console.log("status:loaded");
                playPanel.progress_maximumValue = duration
                break;
            case Audio.Buffering:
                //console.log("status:buffering");
                break;
            case Audio.Stalled:
                //console.log("status:stalled");
                break;
            case Audio.Buffered:
                //console.log("status:buffered");
                break;
            case Audio.InvalidMedia:
                //console.log("status:invalid media");
                switch (error) {
                case Audio.FormatError:
                    ttitle.text = qsTr("需要安装解码器");
                    break;
                case Audio.ResourceError:
                    ttitle.text = qsTr("文件错误");
                    break;
                case Audio.NetworkError:
                    ttitle.text = qsTr("网络错误");
                    break;
                case Audio.AccessDenied:
                    ttitle.text = qsTr("权限不足");
                    break;
                case Audio.ServiceMissing:
                    ttitle.text = qsTr("无法启用多媒体服务");
                    break;
                }
                break;
            case Audio.EndOfMedia:
                //console.log("status:end of media");
                music_lyricModel.currentIndex = 0
                playPanel.progress_maximumValue = 0
                playPanel.progress_value = 0
                if (playPanel.music_loopMode !== 0)
                    musicPlayer.autoPlay = true
                else
                    musicPlayer.autoPlay = false
                switch (playPanel.music_loopMode) {

                case 1:
                    musicPlayer.play()
                    break;
                case 2:
                    music_playlistModel.currentIndex++
                    break;
                case 3:
                    music_playlistModel.randomIndex()
                    break;
                default:
                    break;
                }
                break;
            }
        }
    }

    PlayListModel {
        id: music_playlistModel
        currentIndex: 0
        onCurrentIndexChanged: {
            musicPlayer.source = getcurrentPath()
            playList.music_currentIndex = currentIndex
        }
    }

    LyricModel {
        id: music_lyricModel
        onCurrentIndexChanged: {
            lyric_CurrtentIndex = currentIndex
        }
    }

    Rectangle {
        id: music_playlist_dawer_bottom
        width: parent.width
        height: parent.height
        z: 3
        color: "#55101010"
        MouseArea {anchors.fill: parent}
        x: 0
        y: height
        Behavior on y { PropertyAnimation { duration: 250; easing.type: Easing.OutQuad } }

        MouseArea {
            anchors.fill: parent
            drag.target: parent
            drag.minimumX: 0
            drag.minimumY: 0
            drag.maximumX: 0
            drag.maximumY: parent.height
            property int dragY
            onPressed: {
                dragY = parent.y
            }
            onReleased: {
                if (parent.y - dragY >= 100)
                    music_playlist_dawer_bottom.close()
                else
                    music_playlist_dawer_bottom.open()
            }
        }

        PlayList {
            id: playList
            anchors.fill: parent
        }

        function open() {
            time_display_color = "white"
            music_playlist_dawer_bottom.y = 0
        }

        function close() {
            music_playlist_dawer_bottom.y = height
            time_display_color = "black"

        }
    }

    Image {
        anchors.fill: parent
        id: portray
        source: musicPlayer.hasAudio ? "file:///" + appCurrtentDir + "/src/portray/" + playList.music_currentIndex +".jpeg" : "file:///" + appCurrtentDir + "/src/portray/0.jpeg"
        fillMode: Image.PreserveAspectCrop
    }

    PlayPanel {
        id: playPanel
        visible: true
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0
        anchors.right: parent.right
        anchors.left: parent.left
        height: 80
    }

    Item {
        id: leftItem
        width: parent.width / 2
        height: parent.height
        anchors.left: parent.left
        anchors.top: parent.top

        CD {
            id: music_cd
            anchors.fill: parent
        }
    }

    Item {
        id: rightItem
        width: parent.width / 2
        height: parent.height
        anchors.right: parent.right
        anchors.top: parent.top
        Lyric {
            anchors.fill: parent
            id: lyric
            visible: true
            currentIndex: lyric_CurrtentIndex
        }
    }
}


