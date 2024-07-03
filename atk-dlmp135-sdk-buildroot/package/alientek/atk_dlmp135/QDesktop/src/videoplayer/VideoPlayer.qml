/******************************************************************
Copyright 2022 Guangzhou ALIENTEK Electronincs Co.,Ltd. All rights reserved
Copyright © Deng Zhimao Co., Ltd. 1990-2030. All rights reserved.
* @projectName   videoplayer
* @brief         VideoPlayer.qml
* @author        Deng Zhimao
* @email         dengzhimao@alientek.com/1252699831@qq.com
* @date          2022-12-21
* @link          http://www.openedv.com/forum.php
*******************************************************************/
import QtQuick 2.12
import QtQuick.Controls 2.5

import AQuickPlugin 1.0

Item {
    signal mediaDuratrionChaged()
    signal mediaPositonChaged()
    signal sliderPressChaged(bool pressed)
    property bool fullScreenFlag: false
    property bool progress_pressed: false
    property bool tiltleHeightShow: true
    property bool tiltleWidthShow: true
    id: app_VideoPlayer
    visible: true

    Rectangle {
        id: bg
        anchors.fill: parent
        color: "#f0f0f0"
    }

    AMediaList {
        id: mediaModel
        onCurrentIndexChanged: {
            //  mediaPlayer.source = getcurrentPath()
        }
        Component.onCompleted: mediaModel.currentIndex = -1
    }

    Component.onCompleted: {
        mediaModel.add(appCurrtentDir +  "/src/media/movies")
    }

    Timer {
        id: playStarttimer
        function setTimeout(cb, delayTime) {
            playStarttimer.interval = delayTime;
            playStarttimer.repeat = false
            playStarttimer.triggered.connect(cb);
            playStarttimer.triggered.connect(function release () {
                playStarttimer.triggered.disconnect(cb)
                playStarttimer.triggered.disconnect(release)
            })
            playStarttimer.start()
        }
    }

    Timer {
        id: controlShowTimer
        interval: 500
        repeat: false
        onTriggered: {
            // Leave enough time for the animation to finish
            mouseAreaPlayerItem.enabled = true
        }
    }

    Timer {
        id: timeCountToHide
        interval: 5000
        repeat: false
        onTriggered: {
            if (!fullScreenFlag)
                tiltleHeightShow = false
            else
                tiltleWidthShow = false
        }
    }


    SwipeView {
        id: mediaplayer_swipeView
        visible: true
        anchors.fill: parent
        clip: true
        interactive: false

        onCurrentIndexChanged: {
            if (currentIndex === 0) {
                mediaPlayer.stop()
                mediaModel.currentIndex = -1
            } else
                playStarttimer.setTimeout(function() { if (mediaplayer_swipeView !== 0) mediaPlayer.play()}, 250)
        }

        Item {

            MediaListView {
                anchors.top: parent.top
                anchors.topMargin: 10
                anchors.left: parent.left
                anchors.leftMargin: 10
                anchors.rightMargin: 10
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 90
            }

        }

        Rectangle {
            id: playWindow
            color: "black"

            APlayer {
                id: mediaPlayer
                anchors.centerIn: fullScreenFlag ? parent : undefined
                anchors.top: fullScreenFlag ?undefined : parent.top
                anchors.topMargin: fullScreenFlag ? undefined: 20
                anchors.horizontalCenter: fullScreenFlag ? undefined : parent.horizontalCenter
                volume: global_system_volume
                MouseArea {
                    id: mouseAreaPlayerItem
                    anchors.fill: parent
                    onClicked: {
                        timeCountToHide.restart()
                        if (controlShowTimer.running)
                            return
                        if (!fullScreenFlag)
                            tiltleHeightShow = !tiltleHeightShow
                        else
                            tiltleWidthShow = !tiltleWidthShow
                        controlShowTimer.start()
                        mouseAreaPlayerItem.enabled = false
                    }
                }
                source: ""
                // use qml rotation, default use qml, int videoplayeritem.cpp you can use c++ rotation
                Behavior on width { PropertyAnimation { duration: 350; easing.type: Easing.Linear } }
                Behavior on height { PropertyAnimation { duration: 350; easing.type: Easing.Linear } }
                transform: Rotation{
                    id: mediaRotation
                    origin.x: mediaPlayer.width / 2
                    origin.y: mediaPlayer.height / 2
                    angle: fullScreenFlag ? 90 : 0
                    Behavior on angle { PropertyAnimation { duration: 350; easing.type: Easing.Linear } }
                }
                onSourceChanged: {
                }
                onPositionChanged: {
                    if (!progress_pressed)
                        app_VideoPlayer.mediaPositonChaged()
                }

                onDurationChanged: {
                    app_VideoPlayer.mediaDuratrionChaged()
                }

                onItemSizeChanged: {
                    mediaPlayer.width = itemWidth
                    mediaPlayer.height = itemHeight
                    if (!fullScreenFlag)
                        bottom_Item.anchors.topMargin = itemHeight - 40
                    else
                        bottom_Item.anchors.topMargin = undefined
                }

                Component.onCompleted: {
                    mediaPlayer.setScreenSize(app_VideoPlayer.width, app_VideoPlayer.height)
                }

                onPlaybackStateChanged: {
                    switch (playbackState) {
                    case APlayer.PlayingState:
                        break;
                    case APlayer.PausedState:
                    case APlayer.StoppedState:
                        timeCountToHide.stop()
                        tiltleHeightShow = true
                        tiltleWidthShow = true
                        break;
                    default:
                        break;
                    }
                }
            }

            Item {
                id: top_Item
                width: fullScreenFlag ? 80 : parent.width
                height: fullScreenFlag ? parent.height : 80
                anchors.top: parent.top
                anchors.topMargin: fullScreenFlag ? undefined : 0
                anchors.right: fullScreenFlag ? parent.right : undefined
                anchors.left:fullScreenFlag ? undefined : parent.left
                clip: true
                state: ""
                states:[
                    State {
                        name: "heightShow"
                        PropertyChanges {
                            target: top_Item
                            height: 0
                        }
                        when: !tiltleHeightShow
                    },
                    State {
                        name: "widthShow"
                        PropertyChanges {
                            target: top_Item
                            width: 0
                        }
                        when: !tiltleWidthShow
                    }
                ]

                Behavior on height { PropertyAnimation { duration: 350; easing.type: Easing.Linear } }
                Behavior on width { PropertyAnimation { duration: 350; easing.type: Easing.Linear } }
                Text{
                    id: filmNameText
                    anchors.centerIn: parent
                    text: mediaModel.currentIndex !== -1 ? mediaModel.getcurrentTitle() : ""
                    color: "white"
                    font.pixelSize: 25
                    font.bold: true
                    font.family: "Montserrat Light"
                    transform: Rotation{
                        origin.x: filmNameText.width / 2
                        origin.y: filmNameText.height / 2
                        angle: fullScreenFlag ? 90 : 0
                    }
                }

                Button {
                    id: back_button
                    width: 80
                    height: 80
                    hoverEnabled: true
                    anchors.verticalCenter: fullScreenFlag ? undefined : parent.verticalCenter
                    background: Image {
                        id: back_image
                        width: 40
                        height: 40
                        anchors.centerIn: back_button
                        opacity: back_button.hovered && !back_button.pressed ? 0.8 : 1.0
                        source: fullScreenFlag ?  "qrc:/icons/videopalyer_back_icon_top.png" : "qrc:/icons/videopalyer_back_icon.png"
                    }
                    onClicked: {
                        if (controlShowTimer.running)
                            return
                        if(!fullScreenFlag)
                            mediaplayer_swipeView.currentIndex = 0
                        else
                            fullScreenFlag = !fullScreenFlag
                        controlShowTimer.start() // delay 500ms for next step
                    }
                }
            }

            Item {
                id: bottom_Item
                height: fullScreenFlag ? parent.height : 80
                anchors.top: parent.top
                width: fullScreenFlag ?80 : parent.width
                clip: true
                state: ""
                states:[
                    State {
                        name: "heightShow"
                        PropertyChanges {
                            target: bottom_Item
                            height: 0
                        }
                        when: !tiltleHeightShow
                    },
                    State {
                        name: "widthShow"
                        PropertyChanges {
                            target: bottom_Item
                            width: 0
                        }
                        when: !tiltleWidthShow
                    }
                ]
                Behavior on height { PropertyAnimation { duration: 350; easing.type: Easing.Linear } }
                Behavior on width { PropertyAnimation { duration: 350; easing.type: Easing.Linear } }
                Button {
                    id: screen_button
                    width: 80
                    height: 80
                    anchors.verticalCenter:  fullScreenFlag ? undefined : parent.verticalCenter
                    anchors.horizontalCenter:  fullScreenFlag ? parent.horizontalCenter : undefined
                    anchors.right: parent.right
                    hoverEnabled: true
                    background: Image {
                        id: screen_image
                        width: 40
                        height: 40
                        anchors.centerIn: screen_button
                        opacity: screen_button.hovered && !screen_button.pressed ? 0.8 : 1.0
                        source: !fullScreenFlag ?  "qrc:/icons/videopalyer_smallscreen_icon.png" : "qrc:/icons/videopalyer_fullscreen_icon.png"
                    }
                    onClicked: {
                        if (!controlShowTimer.running)
                            fullScreenFlag = !fullScreenFlag
                        controlShowTimer.start() // delay 500ms for next step
                        timeCountToHide.restart()
                    }
                }

                Button {
                    id: play_button
                    width: 80
                    height: 80
                    anchors.left: parent.left
                    anchors.verticalCenter:  fullScreenFlag ? undefined : parent.verticalCenter
                    anchors.horizontalCenter:  fullScreenFlag ? parent.horizontalCenter : undefined
                    hoverEnabled: true
                    background: Image {
                        id: play_image
                        width: 36
                        height: 36
                        anchors.centerIn: play_button
                        opacity: play_button.hovered && !play_button.pressed ? 0.8 : 1.0
                        source: mediaPlayer.playbackState === APlayer.PlayingState ?  "qrc:/icons/videopalyer_pause_icon.png" : "qrc:/icons/videopalyer_play_icon.png"
                        transform: Rotation{
                            origin.x: play_image.width / 2
                            origin.y: play_image.height / 2
                            angle: fullScreenFlag ? 90 : 0
                        }
                    }
                    onClicked: {
                        if(mediaPlayer.playbackState === APlayer.PlayingState)
                            mediaPlayer.pause()
                        else
                            mediaPlayer.play()
                    }
                }
                Text{
                    id: playTimePosition
                    anchors.left: bottom_Item.left
                    anchors.leftMargin: 75
                    anchors.verticalCenter: bottom_Item.verticalCenter
                    text: currentMediaTime(mediaPlayer.position)
                    color: "white"
                    font.pixelSize: 15
                    font.bold: true
                    font.family: "Montserrat Light"
                    transform: Rotation{
                        origin.x: playTimePosition.width / 2
                        origin.y: playTimePosition.height / 2
                        angle: fullScreenFlag ? 90 : 0
                    }
                }

                Text{
                    id: playTimeDuration
                    anchors.right: bottom_Item.right
                    anchors.rightMargin: 75
                    anchors.verticalCenter: bottom_Item.verticalCenter
                    text: currentMediaTime(mediaPlayer.duration)
                    color: "white"
                    font.pixelSize: 15
                    font.bold: true
                    font.family: "Montserrat Light"
                    transform: Rotation{
                        origin.x: playTimeDuration.width / 2
                        origin.y: playTimeDuration.height / 2
                        angle: fullScreenFlag ? 90 : 0
                    }
                }

                PlaySilder {
                    id: silder
                    anchors.fill: parent
                }
            }
        }
    }

    function smallScreen() {
        playTimePosition.anchors.top = undefined
        playTimePosition.anchors.horizontalCenter = undefined
        playTimePosition.anchors.topMargin = undefined
        playTimePosition.anchors.left = bottom_Item.left
        playTimePosition.anchors.leftMargin = 75
        playTimePosition.anchors.verticalCenter = bottom_Item.verticalCenter
        playTimeDuration.anchors.bottom = undefined
        playTimeDuration.anchors.horizontalCenter = undefined
        playTimeDuration.anchors.bottomMargin = undefined
        playTimeDuration.anchors.right = bottom_Item.right
        playTimeDuration.anchors.rightMargin = 75
        playTimeDuration.anchors.verticalCenter = bottom_Item.verticalCenter
    }

    function fullScreen() {
        screen_button.anchors.bottom = bottom_Item.bottom
        playTimePosition.anchors.left = undefined
        playTimePosition.anchors.leftMargin = undefined
        playTimePosition.anchors.verticalCenter = undefined
        playTimePosition.anchors.top = bottom_Item.top
        playTimePosition.anchors.horizontalCenter = bottom_Item.horizontalCenter
        playTimePosition.anchors.topMargin = 150
        playTimeDuration.anchors.right = undefined
        playTimeDuration.anchors.rightMargin = undefined
        playTimeDuration.anchors.verticalCenter = undefined
        playTimeDuration.anchors.bottom = bottom_Item.bottom
        playTimeDuration.anchors.horizontalCenter = bottom_Item.horizontalCenter
        playTimeDuration.anchors.bottomMargin = 150
    }

    onFullScreenFlagChanged: {
        if (fullScreenFlag)
            fullScreen()
        else
            smallScreen()
        mediaPlayer.setFullScreen(fullScreenFlag)
    }

    function currentMediaTime(time){
        var sec = Math.floor(time / 1000);
        var hours = Math.floor(sec / 3600);
        var minutes = Math.floor((sec - hours * 3600) / 60);
        var seconds = sec - hours * 3600 - minutes * 60;
        var hh, mm, ss;
        if(hours.toString().length < 2)
            hh = "0" + hours.toString();
        else
            hh = hours.toString();
        if(minutes.toString().length < 2)
            mm="0" + minutes.toString();
        else
            mm = minutes.toString();
        if(seconds.toString().length < 2)
            ss = "0" + seconds.toString();
        else
            ss = seconds.toString();
        return hh+":" + mm + ":" + ss
    }
}
