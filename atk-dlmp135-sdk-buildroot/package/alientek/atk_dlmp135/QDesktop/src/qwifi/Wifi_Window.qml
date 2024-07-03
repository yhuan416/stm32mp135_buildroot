/******************************************************************
Copyright 2022 Guangzhou ALIENTEK Electronincs Co.,Ltd. All rights reserved
Copyright © Deng Zhimao Co., Ltd. 1990-2030. All rights reserved.
* @projectName   qwifi
* @brief         main.qml
* @author        Deng Zhimao
* @email         dengzhimao@alientek.com/1252699831@qq.com
* @date          2022-11-29
* @link          http://www.openedv.com/forum.php
*******************************************************************/
import QtQuick 2.9
import QtQuick.Window 2.2
import QtQuick.VirtualKeyboard 2.2
import QtQuick.VirtualKeyboard.Settings 2.2
import QtQuick.Controls 2.5

import AQuickPlugin 1.0

Window {
    id: app_qwifi
    visible: true
    width: 720
    height: 1280
    title: qsTr("Hello World")
    signal inputPanelReadyOpen()
    signal inputPanelReadyClose()

    Rectangle {
        anchors.fill: parent
        color: "#f0f0f0"
    }

    InputPanel {
        id: inputPanel
        z: 99
        x: 0
        y: app_qwifi.height
        width: app_qwifi.width

        states: State {
            name: "visible"
            when: inputPanel.active
            PropertyChanges {
                target: inputPanel
                y: app_qwifi.height - inputPanel.height
            }
        }
        transitions: Transition {
            from: ""
            to: "visible"
            reversible: true
            ParallelAnimation {
                NumberAnimation {
                    properties: "y"
                    duration: 250
                    easing.type: Easing.InOutQuad
                }
            }
        }
    }

    Binding {
        target: VirtualKeyboardSettings
        property: "activeLocales"
        //value: ["zh_CN", "en_US"]
        value: ["en_US"]
    }

    AWifi {
        id: wifi
        onCurrentIndexChanged: {
            currentIndex = -1
        }
    }

    SwipeView {
        id: wifi_swipeView
        visible: true
        anchors.fill: parent
        clip: true
        interactive: false
        Item {
            WifiListView {
                id: wifiListView
                anchors.fill: parent
            }
            ActionSheet {
                id: actionSheet
            }
        }
        WifiInofoPage{ }
        onCurrentIndexChanged: {
            if (wifi_swipeView .currentIndex === 1)
                wifi.setModal(true)
            if (wifi_swipeView .currentIndex === 0)
                wifi.setModal(false)

        }
    }


    Button {
        id: back_button
        anchors.top: parent.top
        anchors.topMargin: 40
        visible: wifi_swipeView.currentIndex != 0
        width: 200
        height: 50
        opacity: back_button.pressed ? 0.5 : 1.0
        background: Image {
            id: back_image
            source: "qrc:/qwifi/icons/back.png"
            width: 50
        }
        onClicked: wifi_swipeView.currentIndex = 0
    }
    CenterChoseStyleDialog {
        id: centerChoseStyleDialog
        textTitle: "要移除无线局域网\n\"" + (wifi.currentIndex !== -1 ? wifi.getcurrentName() : "" ) + "\"吗？"
        textSubTitle: "您的设备将不再加入此无线局域网络。"
        onAccepted: {
            wifi_swipeView.currentIndex = 0
            wifi.ignoreDevice()
            centerChoseStyleDialog.close()
            wifi.setModal(false)
        }
        onDiscarded: centerChoseStyleDialog.close()
    }
}
