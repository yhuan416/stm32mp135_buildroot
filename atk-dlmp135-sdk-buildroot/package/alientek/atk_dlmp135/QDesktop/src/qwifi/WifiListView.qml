/******************************************************************
Copyright 2022 Guangzhou ALIENTEK Electronincs Co.,Ltd. All rights reserved
Copyright © Deng Zhimao Co., Ltd. 1990-2030. All rights reserved.
* @projectName   qwifi
* @brief         WifiListView.qml
* @author        Deng Zhimao
* @email         dengzhimao@alientek.com/1252699831@qq.com
* @date          2022-12-01
* @link          http://www.openedv.com/forum.php
*******************************************************************/
import QtQuick 2.12
import QtQuick.Controls 2.5
import AQuickPlugin 1.0

Item {
    property bool reflashListFlag: false

    Connections{
        target: app_qwifi
        onWlanStateChanged: {
            if (wlanState === AWifi.Inexistence)
                wlanSwitch.enabled = false
            else
                wlanSwitch.enabled = true
            if (wlanState === AWifi.Up) {
                if (!wlanSwitch.checked) {
                    wlanSwitch.checked = true
                }
            } else if (wlanState === AWifi.Down) {
                if (wlanSwitch.checked) {
                    wlanSwitch.checked = false
                }
            }
        }

    }

    onVisibleChanged: {
        if (visible)
            wifi.getWlanState()
    }
    Text {
        id: appTitle
        text: qsTr("无线局域网")
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: 20
        font.pixelSize: 30
        font.family: "Montserrat Regular"
    }

    Item {
        anchors.top: appTitle.bottom
        anchors.topMargin: 0
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 20
        width: parent.width
        Flickable {
            id: flickable
            anchors.fill: parent
            contentHeight: wifiListView.height + 80
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
            ListView  {
                id: wifiListView
                visible: true
                anchors.top: parent.top
                height: contentHeight
                width: parent.width
                orientation:ListView.Vertical
                interactive: false
                clip: true
                model: wifi
                //currentIndex: wifi.currentIndex

                onCurrentIndexChanged: {
                    //wifi.currentIndex = currentIndex
                }

                onCountChanged: {
                    wifiListView.currentIndex = -1
                    reflashListFlag = false
                }

                Component.onCompleted:  {
                    // wifiListView.currentIndex = -1
                }

                delegate: Item {
                    id: itembg
                    width: parent.width
                    property int tmpheight: if (wifi.connectionState === AWifi.OnlineState )
                                                inhomogeneous ? 160 : 80
                                            else if (wifi.connectionState === AWifi.RegistedNotOnlineState)
                                                inhomogeneous ?  ((wifiState === 2) ? 160 : 240 ): 80
                                            else if (wifi.connectionState === AWifi.UnknownNotRegistedState)
                                                inhomogeneous ? 240 : 80
                                            else
                                                80
                    height: reflashListFlag ?  0  : tmpheight
                    Component.onCompleted: { itembg.height = tmpheight }
                    Behavior on height { PropertyAnimation { duration: 500; easing.type: Easing.Linear } }
                    Text {
                        text: if (wifiState === AWifi.RegistedNotOnlineState && inhomogeneous)
                                  qsTr("我的网络")
                              else if (wifiState === AWifi.UnknownNotRegistedState && inhomogeneous)
                                  qsTr("其他网络")
                              else
                                  qsTr("")
                        anchors.left: parent.left
                        anchors.leftMargin: 48
                        anchors.bottom: parent.bottom
                        anchors.bottomMargin: 80
                        elide: Text.ElideRight
                        font.pixelSize: 25
                        visible: (wifiState === AWifi.RegistedNotOnlineState  || wifiState === AWifi.UnknownNotRegistedState) && inhomogeneous
                        color: "gray"
                    }
                    Rectangle {
                        height: 80
                        width: parent.width
                        anchors.bottom: parent.bottom
                        anchors.left: parent.left
                        clip: true
                        color: mouseArea.pressed ? "#88d7c388" : "white"
                        Behavior on color { PropertyAnimation { duration: 200; easing.type: Easing.Linear } }
                        Behavior on height { PropertyAnimation { duration: 200; easing.type: Easing.Linear } }
                        MouseArea {
                            id: mouseArea
                            anchors.fill: parent
                            onClicked: {
                                wifiListView.currentIndex = index
                                wifi.currentIndex  = index
                                if (wifi.getcurrentWifiSate() !== AWifi.RegistedNotOnlineState
                                        && wifi.getcurrentWifiSate() !== AWifi.OnlineState
                                        && wifi.getcurrentEncryMode() !== AWifi.None)
                                    actionSheet.open()
                                else
                                    wifi.startConnectWifi("")
                            }
                        }

                        Rectangle {
                            anchors.top: parent.top
                            width: parent.width - 20
                            anchors.horizontalCenter: parent.horizontalCenter
                            height: 1
                            color: "#c6c6c8"
                            // visible: index == 0
                        }

                        Rectangle {
                            anchors.bottom: parent.bottom
                            width: parent.width - 20
                            anchors.right: parent.right
                            height: 1
                            color: "#c6c6c8"
                        }

                        Image {
                            id: connected_icon
                            visible: wifiState === 0
                            source: "qrc:/qwifi/icons/wifi_connected_icon.png"
                            anchors.left: parent.left
                            anchors.leftMargin: 24
                            anchors.verticalCenter: parent.verticalCenter
                        }

                        Image {
                            id: connect_process_icon
                            visible: wifiState !== 0 && wifiListView.currentIndex === index && !wifi.scanState
                            source: "qrc:/qwifi/icons/wifi_process_icon.png"
                            anchors.left: parent.left
                            anchors.leftMargin: 24
                            anchors.verticalCenter: parent.verticalCenter
                        }

                        RotationAnimator {
                            id: animator_connect_process
                            target: connect_process_icon
                            from: 0
                            to: 360
                            duration: 1000
                            loops: Animation.Infinite
                            running: connect_process_icon.visible
                            onRunningChanged: {
                                if (running === false) {
                                    from = connect_process_icon.rotation
                                    to = from + 360
                                }
                            }
                            onStopped: connect_process_icon.rotation = 0
                        }

                        Row {
                            anchors.right: parent.right
                            anchors.rightMargin: 32
                            anchors.verticalCenter: parent.verticalCenter
                            Item {
                                width: 80
                                height: 64
                                Image {
                                    id: lock_icon
                                    visible: encryMode !== AWifi.None
                                    width: 24
                                    height: 24
                                    source: "qrc:/qwifi/icons/wifi_lock_icon.png"
                                    anchors.centerIn: parent
                                }
                            }
                            Item {
                                width: 80
                                height: 64
                                visible:  strength !== AWifi.UnknownLevel
                                Image {
                                    id: signal_icon
                                    width: 40
                                    height: 40
                                    source: if (strength === AWifi.WeakLevel)
                                                "qrc:/qwifi/icons/wifi_singal_weak.png"
                                            else if (strength === AWifi.MediumLevel)
                                                "qrc:/qwifi/icons/wifi_singal_medium.png"
                                            else if (strength === AWifi.StrengthLevel)
                                                "qrc:/qwifi/icons/wifi_singal_strong.png"
                                            else
                                                ""
                                    anchors.centerIn: parent
                                }
                            }

                            Button {
                                id: info_icon
                                width: 80
                                focus: Qt.NoFocus
                                height: parent.height
                                opacity: info_icon.pressed ? 0.8 : 1.0
                                anchors.verticalCenter: parent.verticalCenter
                                background: Image {
                                    source: "qrc:/qwifi/icons/wifi_info_icon.png"
                                    anchors.centerIn: parent
                                }
                                onClicked:  {
                                    wifiListView.currentIndex = index
                                    wifi.currentIndex  = index
                                    wifi_swipeView.currentIndex = 1
                                }
                            }
                        }

                        Text {
                            id: wifi_name
                            width: parent.width / 2
                            text:  name
                            elide: Text.ElideRight
                            font.pixelSize: 30
                            anchors.left: parent.left
                            anchors.leftMargin: 96
                            anchors.verticalCenter: parent.verticalCenter
                            color: "black"
                            font.family: "Montserrat Regular"
                        }
                    }
                }
            }

            Rectangle {
                color: "white"
                height: 80
                width: wifiListView.width
                anchors.bottom: wifiListView.top
                anchors.bottomMargin: -80
                anchors.horizontalCenter: parent.horizontalCenter
                clip: true
                CustomSwitch {
                    id: wlanSwitch
                    anchors.right: parent.right
                    anchors.rightMargin: 50
                    anchors.verticalCenter: parent.verticalCenter
                    checked: false
                    width: 100
                    height: 60
                    //enabled: wifi.scanState
                    //                                        onToggled: {
                    //                                            console.log("555555555")
                    //                                            if(checked) {
                    //                                                reflashListFlag = true
                    //                                                wifi.reflashWifiList()
                    //                                            } else
                    //                                                wifiListView.model.clear()
                    //                                            wifi.setWifiEnable(checked)
                    //                                        }
                    onCheckedChanged: {
                        if(checked) {
                            reflashListFlag = true
                            wifi.reflashWifiList()
                        } else
                            wifiListView.model.clear()
                        wifi.setWifiEnable(checked)
                    }
                }
                Text {
                    id: wlanText
                    text: qsTr("无线局域网")
                    anchors.left: parent.left
                    anchors.leftMargin: 96
                    anchors.verticalCenter: parent.verticalCenter
                    elide: Text.ElideRight
                    font.pixelSize: 30
                }
            }
        }
    }
}
