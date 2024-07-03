/******************************************************************
Copyright 2022 Guangzhou ALIENTEK Electronincs Co.,Ltd. All rights reserved
Copyright © Deng Zhimao Co., Ltd. 1990-2030. All rights reserved.
* @projectName   videoplayer
* @brief         mediaGridView.qml
* @author        Deng Zhimao
* @email         dengzhimao@alientek.com/1252699831@qq.com
* @date          2022-11-21
* @link          http://www.openedv.com/forum.php
*******************************************************************/
import QtQuick 2.12
import QtQuick.Controls 2.5

Item {
    GridView  {
        id: mediaGridView
        visible: true
        anchors.fill: parent
        clip: true
        model: mediaModel
        cellWidth: mediaGridView.width / 3
        cellHeight: cellWidth / 3 * 2.5
        onCountChanged: {
            mediaGridView.currentIndex = -1
        }

        Component.onCompleted:  mediaGridView.currentIndex = -1

        ScrollBar.vertical: ScrollBar {
            id: scrollBar
            width: 10
            background: Rectangle {color: "transparent"}
            onActiveChanged: {
                active = true;
            }
            Component.onCompleted: {
                scrollBar.active = true;
            }
            contentItem: Rectangle{
                implicitWidth: 15
                implicitHeight: 100
                radius: 10
                color: scrollBar.pressed ? "#88101010" : "#30101010"
            }
        }

        delegate: Item {
            id: itembg
            width: mediaGridView.cellWidth
            height: mediaGridView.cellHeight
            Rectangle {
                radius: 20
                color:  "white"
                anchors.centerIn: parent
                width: mediaGridView.cellWidth - 30
                height: mediaGridView.cellHeight - 30
                MouseArea {
                    id: mouseArea
                    anchors.fill: parent
                    onClicked: {
                        mediaGridView.currentIndex = index
                        mediaModel.currentIndex = index
                        if (mediaModel.currentIndex !== -1)
                            mediaPlayer.source =  mediaModel.getcurrentPath()
                        //mediaPlayer.play()
                        mediaplayer_swipeView.currentIndex = 1
                    }
                    Image {
                        id: moviesCoverplan
                        source: content
                        anchors.top: parent.top
                        anchors.topMargin: 20
                        anchors.left: parent.left
                        anchors.leftMargin: 20
                        anchors.rightMargin: 20
                        anchors.right: parent.right
                        height: parent.height * 0.75
                        fillMode: Image.PreserveAspectFit
                        opacity: mouseArea.pressed ? 0.8 : 1.0
                    }
                    Text {
                        id: moviesName
                        text: qsTr(title)
                        anchors.bottom: parent.bottom
                        width: parent.width - 20
                        anchors.horizontalCenter: parent.horizontalCenter
                        font.pixelSize: 18
                        color: "black"
                        horizontalAlignment: Text.AlignLeft
                        wrapMode: Text.WrapAnywhere
                    }
                }
            }
        }
    }
}
