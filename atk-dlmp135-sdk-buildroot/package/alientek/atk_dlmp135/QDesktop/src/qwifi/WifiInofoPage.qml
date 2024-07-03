/******************************************************************
Copyright 2022 Guangzhou ALIENTEK Electronincs Co.,Ltd. All rights reserved
Copyright © Deng Zhimao Co., Ltd. 1990-2030. All rights reserved.
* @projectName   qwifi
* @brief         WifiInofoPage.qml
* @author        Deng Zhimao
* @email         dengzhimao@alientek.com/1252699831@qq.com
* @date          2022-12-07
* @link          http://www.openedv.com/forum.php
*******************************************************************/
import QtQuick 2.0
import QtQuick 2.12
import QtQuick.Controls 2.5
import AQuickPlugin 1.0

Item {

    Rectangle {
        anchors.fill: parent
        color: "#f0f0f0"
    }

    Item {
        anchors.top: parent.top
        anchors.topMargin: 20
        width: 100
        height: 50
        Text {
            text: qsTr("无线局域网")
            font.underline: false
            font.family: "Montserrat Light"
            color: "#0b62f6"
            font.pixelSize: 30
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: 45
            opacity: back_button.opacity
        }
    }


    Item {
        anchors.top: parent.top
        anchors.topMargin: 100
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 80
        width: parent.width
        Flickable {
            id: flickable
            anchors.fill: parent
            contentHeight: column.height + 100
            contentWidth: parent.width
            clip: true
            ScrollBar.vertical: ScrollBar {
                id: scrollBar
                width: 20
                background: Rectangle {color: "transparent"}
                onActiveChanged: {
                    active = true;
                }
                Component.onCompleted: {
                    scrollBar.active = true;
                }
                contentItem: Rectangle{
                    implicitWidth: 20
                    implicitHeight: 100
                    radius: 10
                    //color: scrollBar.hovered ? "#88101010" : "#30101010"
                    color: scrollBar.pressed ? "#88101010" : "#30101010"
                }
            }

            Column {
                id: column
                anchors.top: parent.top
                anchors.topMargin: 0
                width: parent.width
                spacing: 100
                Button {
                    visible: wifi.currentIndex !== -1 && wifi.getcurrentWifiSate() !== AWifi.OnlineState
                    id: join_bt
                    height: 80
                    clip: true
                    width: parent.width
                    background: Rectangle{
                        anchors.fill: parent
                        color: join_bt.pressed ? "#88d7c388" : "white"
                        Behavior on color { PropertyAnimation { duration: 200; easing.type: Easing.Linear } }
                    }
                    Text {
                        text: qsTr("加入此网络")
                        anchors.verticalCenter: parent.verticalCenter
                        color: Qt.rgba(0, 0.5, 1, 1)
                        font.pixelSize: 25
                        anchors.left: parent.left
                        anchors.leftMargin: 32
                    }

                    onClicked: {
                        wifi_swipeView.currentIndex = 0
                        if (wifi.getcurrentWifiSate() !== AWifi.RegistedNotOnlineState && wifi.getcurrentWifiSate() !== AWifi.OnlineState)
                            actionSheet.open()
                        else
                            wifi.startConnectWifi("")
                    }
                }

                Button {
                    id: ingnore_bt
                    height: 80
                    width: parent.width
                    clip: true
                    visible: wifi.currentIndex !== -1 && wifi.getcurrentWifiSate() !== AWifi.UnknownNotRegistedState
                    background: Rectangle{
                        anchors.fill: parent
                        color: ingnore_bt.pressed ? "#88d7c388" : "white"
                        Behavior on color { PropertyAnimation { duration: 200; easing.type: Easing.Linear } }
                    }
                    Text {
                        text: qsTr("忽略此网络")
                        anchors.verticalCenter: parent.verticalCenter
                        color: Qt.rgba(0, 0.5, 1, 1)
                        font.pixelSize: 25
                        anchors.left: parent.left
                        anchors.leftMargin: 32
                    }
                    onClicked: centerChoseStyleDialog.open()
                }
            }
        }
    }
}
