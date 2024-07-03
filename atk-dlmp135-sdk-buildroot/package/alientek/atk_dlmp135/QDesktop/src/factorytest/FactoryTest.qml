/******************************************************************
Copyright 2022 Guangzhou ALIENTEK Electronincs Co.,Ltd. All rights reserved
Copyright © Deng Zhimao Co., Ltd. 1990-2030. All rights reserved.
* @projectName   factorytest
* @brief         FactoryTest.qml
* @author        Deng Zhimao
* @email         dengzhimao@alientek.com
* @date          2022-11-09
* @link          http://www.openedv.com/forum.php
*******************************************************************/
import QtQuick 2.12
import QtQuick.Controls 2.5

import factory 1.0

Item {
    id : app_factorytest
    y: app_factorytest.height
    x: 0
    opacity: 0
    property int timeCnt: 0
    property real showPropertyChangeOpacity: 1
    property real showPropertyChangeX: 0
    property real showPropertyChangeY: 0
    property bool show: false

    state: ""
    states:[
        State {
            name: "show"
            PropertyChanges {
                target: app_factorytest
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

    Rectangle {
        anchors.fill: parent
        color: "#f0f0f0"
    }

    onVisibleChanged: {
        if (!visible) {
            startTestBt.checked = false
            factory.setThreadStart(false)
        }
    }

    Item {
        anchors.top: parent.top
        anchors.topMargin: 80
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 20
        width: parent.width  / 2.5
        anchors.left: parent.left

        Rectangle {
            width: 200
            height: 40
            radius: 20
            color: "#dddddd"
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.top
            Text {
                text: qsTr("测试过程打印")
                anchors.centerIn: parent
                font.pixelSize: 20
                color: "white"
            }
        }

        Flickable {
            id: flickable
            anchors.fill: parent
            contentHeight: textArea.height
            contentWidth: parent.width
            clip: true
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
                    implicitWidth: 10
                    implicitHeight: 100
                    radius: 5
                    color: scrollBar.pressed ? "#88101010" : "#30101010"
                }
            }

            TextArea {
                id: textArea
                placeholderText: "这里会打印测试过程"
                anchors.top: parent.top
                height: contentHeight
                width: parent.width
                activeFocusOnPress: false
                anchors.horizontalCenter: parent.horizontalCenter
                placeholderTextColor: "#88555555"
                color: "black"
                font.pixelSize: 10
                onTextChanged: scrollBar.increase()
                background: Rectangle {
                    anchors.fill: parent
                    //color: "#f0f0f0"
                    color: "transparent"
                }
            }
        }
    }

    Item {
        anchors.top: parent.top
        anchors.topMargin: 80
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 20
        width: parent.width  / 2.5
        anchors.right: parent.right

        Rectangle {
            width: 200
            height: 40
            radius: 20
            color: "#dddddd"
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.top
            Text {
                text: qsTr("测试结果打印")
                anchors.centerIn: parent
                font.pixelSize: 20
                color: "white"
            }
        }

        Flickable {
            id: flickable1
            anchors.fill: parent
            contentHeight: textArea1.height
            contentWidth: parent.width
            clip: true
            ScrollBar.vertical: ScrollBar {
                id: scrollBar1
                width: 10
                background: Rectangle {color: "transparent"}
                onActiveChanged: {
                    active = true;
                }
                Component.onCompleted: {
                    scrollBar1.active = true;
                }
                contentItem: Rectangle{
                    implicitWidth: 10
                    implicitHeight: 100
                    radius: 5
                    color: scrollBar1.pressed ? "#88101010" : "#30101010"
                }
            }

            TextArea {
                id: textArea1
                placeholderText: "这里会打印测试结果"
                anchors.top: parent.top
                height: contentHeight
                width: parent.width
                activeFocusOnPress: false
                anchors.horizontalCenter: parent.horizontalCenter
                placeholderTextColor: "#88555555"
                color: "black"
                font.pixelSize: 20
                onTextChanged: scrollBar1.increase()
                background: Rectangle {
                    anchors.fill: parent
                    //color: "#f0f0f0"
                    color: "transparent"
                }
            }
        }
    }
    Button {
        id: startTestBt
        width: 120
        height: parent.height - 100
        anchors.centerIn: parent
        checked: false
        checkable: true
        onClicked:  {
            if (startTestBt.checked) {
                textArea.text = ""
                textArea1.text = ""
            }
            factory.setThreadStart(startTestBt.checked)
        }

        background: Rectangle {
            anchors.fill: parent
            color: startTestBt.checked ? "#dddddd" :"white"
            radius: 20
            border.color: startTestBt.checked ? "white" : "#bbbbbb"
            border.width: 5
            Text {
                id: startTestText
                text: startTestBt.checked ? qsTr("STOP") : qsTr("START")
                font.pixelSize: 25
                color: startTestBt.checked ? "gray" : "#0b62f6"
                anchors.centerIn: parent
            }
        }
    }

    Factory {
        id: factory
        onKeyDown: {
            textArea.text = textArea.text + "keydown" + timeCnt.toString() + "\n"
            textArea1.text = textArea1.text + "KEY is ok" + "\n"
            timeCnt++
            if (timeCnt > 10)
                timeCnt = 0
        }
        onGetShellTestMessage: textArea.text = textArea.text + message
        onGetTestResult:  textArea1.text = textArea1.text + message
    }
}
