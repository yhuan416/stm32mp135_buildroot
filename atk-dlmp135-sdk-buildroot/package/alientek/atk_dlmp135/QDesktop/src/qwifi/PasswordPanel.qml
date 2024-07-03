/******************************************************************
Copyright 2022 Guangzhou ALIENTEK Electronincs Co.,Ltd. All rights reserved
Copyright © Deng Zhimao Co., Ltd. 1990-2030. All rights reserved.
* @projectName   qwifi
* @brief         PasswordPanel.qml
* @author        Deng Zhimao
* @email         dengzhimao@alientek.com/1252699831@qq.com
* @date          2022-12-06
* @link          http://www.openedv.com/forum.php
*******************************************************************/
import QtQuick 2.0
import QtQuick 2.12
import QtQuick.Controls 2.5

Rectangle {
    anchors.top: parent.top
    anchors.topMargin: 60
    width: parent.width
    height: parent.height
    color: "white"
    radius: 20
    focus: true

    Text {
        id: essidName
        text: "请输入“" + qsTr(wifi.currentIndex !== -1 ? wifi.getcurrentName() : "") + "”的密码";
        anchors.top: parent.top
        anchors.topMargin: 20
        anchors.horizontalCenter: parent.horizontalCenter
        font.pixelSize: 25
    }

    Row {
        anchors.top: parent.top
        anchors.topMargin: 50
        width: parent.width - 60
        anchors.horizontalCenter: parent.horizontalCenter

        Button {
            id: cancelBt
            width: parent.width / 3
            height: parent.height
            focusPolicy: Qt.NoFocus
            background: Item { }
            Text {
                id: cancelTextTitile
                text: qsTr("取消")
                font.pixelSize: 35
                color: Qt.rgba(0, 0.5, 1, 1)
                anchors.fill: parent
                opacity: cancelBt.pressed ? 0.5 : 1.0
                horizontalAlignment: Text.AlignLeft
                anchors.verticalCenter: parent.verticalCenter
            }
            onClicked: { actionSheet.close() }
        }

        Text {
            id: inputTextTitile
            text: qsTr("输入密码")
            font.pixelSize: 40
            font.weight: Font.Medium
            width: parent.width / 3
            horizontalAlignment: Text.AlignHCenter
            anchors.verticalCenter: parent.verticalCenter
        }

        Button {
            id: joinBt
            width: parent.width / 3
            height: parent.height
            focusPolicy: Qt.NoFocus
            background: Item { }
            Text {
                id: joinTextTitile
                text: qsTr("加入")
                font.pixelSize: 35
                color: textInput.length >= 8 ?  Qt.rgba(0, 0.5, 1, 1) : "gray"
                anchors.fill: parent
                horizontalAlignment: Text.AlignRight
                anchors.verticalCenter: parent.verticalCenter
            }
            onClicked: {
                if (textInput.length >= 8) {
                    actionSheet.close()
                    wifi.startConnectWifi(textInput.text)
                }
            }
        }
    }

    Rectangle {
        id: slicerRect
        anchors.top: parent.top
        anchors.topMargin: 100
        height: 10
        width: parent.width
        color: "#f0f0f0"
    }

    Row {
        id: row
        anchors.top: slicerRect.bottom
        height: 80
        anchors.left: parent.left
        anchors.leftMargin: 30
        anchors.right: parent.right
        anchors.rightMargin: 30
        Text {
            id: passwordTextTitle
            text: qsTr("密码")
            width: 100
            horizontalAlignment: Text.AlignLeft
            anchors.verticalCenter: parent.verticalCenter
            font.pixelSize: 30
            focus: false
        }

        TextInput {
            id: textInput
            width: parent.width - 200
            height: parent.height
            font.pixelSize: 30
            verticalAlignment: Text.AlignVCenter
            inputMethodHints: Qt.ImhHiddenText
            echoMode:TextInput.Password
            passwordMaskDelay: 2000
            cursorVisible: true
        }

        Button {
            id: eyesBt
            width: 100
            height: parent.height
            checkable: true
            focusPolicy: Qt.NoFocus
            background: Image {
                width: 32
                anchors.centerIn: parent
                source: eyesBt.checked ? "qrc:/qwifi/icons/password_eyes_open.png" : "qrc:/qwifi/icons/password_eyes_close.png"
            }
            onCheckedChanged: {
                if (!eyesBt.checked)
                    textInput.echoMode = TextInput.Password
                else {
                    textInput.echoMode = TextInput.PasswordEchoOnEdit
                    textInput.echoMode = TextInput.Normal
                }
            }
        }
    }

    Connections {
        target: app_qwifi
        onInputPanelReadyOpen: {
            textInput.focus = true
        }
        onInputPanelReadyClose: {
            textInput.focus = false
        }
    }

    Rectangle {
        id: bottomRect
        anchors.top: row.bottom
        height: parent.height
        width: parent.width
        color: "#f0f0f0"

        Text {
            id: warnningTextTitile
            text: qsTr("您也可以将ATK-DLMP135靠近任何已接入此网络且已添加您为联系人的其它MP135来访问此设备")
            font.pixelSize: 20
            color: "gray"
            width: parent.width - 60
            horizontalAlignment: Text.AlignLeft
            wrapMode: Text.WrapAnywhere
            anchors.horizontalCenter: parent.horizontalCenter
        }
    }
}
