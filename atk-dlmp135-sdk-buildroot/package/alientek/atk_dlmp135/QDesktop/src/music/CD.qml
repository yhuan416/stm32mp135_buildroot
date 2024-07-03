/******************************************************************
Copyright © Deng Zhimao Co., Ltd. 2021-2030. All rights reserved.
* @projectName   desktop
* @brief         CD.qml
* @author        Deng Zhimao
* @email         dengzhimao@alientek.com
* @link          www.openedv.com
* @date          2021-09-13
*******************************************************************/
import QtQuick 2.0
import QtQuick 2.12
import QtMultimedia 5.0
import QtQuick.Controls 2.5

Item {
    id: my_cd
    anchors.fill: parent

    Rectangle {
        id: cd_bg
        width: 290
        height: 290
        radius: width / 2
        anchors.horizontalCenter: cd_listView.horizontalCenter
        anchors.verticalCenter: cd_listView.verticalCenter
        color: "#55f0f0f0"
    }

    Timer {
        id: cd_timer
        interval: 1000
        onTriggered: {
            cd_timer.stop()
            music_playlistModel.currentIndex = cd_listView.currentIndex
            if (musicPlayer.playbackState !== Audio.PlayingState)
                musicPlayer.play()
        }
    }

    ListView {
        id: cd_listView
        visible:  true
        orientation: ListView.Horizontal
        clip: true
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        anchors.bottomMargin: parent.height / 5
        interactive: true
        model: music_playlistModel
        snapMode: ListView.SnapOneItem
        highlightRangeMode: ListView.StrictlyEnforceRange
        currentIndex: music_playlistModel.currentIndex
        onCurrentIndexChanged: {
            cd_timer.start()
        }

        delegate: Rectangle {
            id: listView_delegate
            width: cd_listView.width
            height: cd_listView.height
            color: "transparent"

            Image {
                visible: true
                id: music_cd_Image
                source: "qrc:/images/cd_outside.png"
                width:  300
                height: 300
                antialiasing: true
                anchors.centerIn: parent
                Image {
                    width: 195
                    height: 195
                    anchors.centerIn: parent
                    z: -1
                    id: music_cd_artist_Image
                    source: "file:///" + appCurrtentDir + "/src/artist/" + index +".jpg"
                    rotation: musicPlayer.playbackState === Audio.StoppedState ? 0 : ""
                }
            }

            RotationAnimator {
                id: animator_music_cd_Image
                target: music_cd_Image
                from: 0
                to: 360
                duration: armEnv ? 50000 :200000
                loops: Animation.Infinite
                running:  cd_listView.currentIndex  === index  && musicPlayer.playbackState === Audio.PlayingState && cd_roation
                onRunningChanged: {
                    if (running === false) {
                        from = music_cd_Image.rotation
                        to = from + 360
                    }
                }
            }
        }
    }

    Image {
        visible: true
        id: cd_head_image
        source: "qrc:/images/cd_head.png"
        height: 50
        fillMode: Image.PreserveAspectFit
        antialiasing: true
        transformOrigin: Item.Center
        rotation: musicPlayer.playbackState === Audio.PlayingState ? -22 : -40
        anchors.bottom: cd_listView.verticalCenter
        anchors.bottomMargin: -80
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.horizontalCenterOffset: 150
        Behavior on rotation { PropertyAnimation { duration: 500; easing.type: Easing.Linear } }
    }

    Button {
        id: btn_play
        width: 64
        height: 64
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 60
        visible: true
        anchors.horizontalCenter: parent.horizontalCenter
        opacity: btn_play.pressed ? 0.8 : 1.0
        background: Image {
            anchors.fill: parent
            source: musicPlayer.playbackState === Audio.PlayingState ? "qrc:/icons/btn_pause.png" : "qrc:/icons/btn_play.png"
        }
        onClicked: app_music.playBtnSignal()
    }

    Button {
        id: btn_next
        width: 40
        height: 40
        visible: true
        anchors.verticalCenter: btn_play.verticalCenter
        anchors.left: btn_play.right
        anchors.leftMargin: 64
        opacity: btn_next.pressed ? 0.8 : 1.0
        background: Image {
            anchors.fill: parent
            source: "qrc:/icons/btn_next.png"
        }
        onClicked: app_music.nextBtnSignal()
    }

    Button {
        id: btn_previous
        width: 40
        height: 40
        visible: true
        anchors.verticalCenter: btn_play.verticalCenter
        anchors.right: btn_play.left
        anchors.rightMargin: 64
        opacity: btn_previous.pressed ? 0.8 : 1.0
        background: Image {
            anchors.fill: parent
            source: "qrc:/icons/btn_previous.png"
        }
        onClicked: app_music.previousBtnSignal()
    }
}
