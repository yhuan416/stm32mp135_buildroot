/******************************************************************
Copyright © Deng Zhimao Co., Ltd. 2021-2030. All rights reserved.
* @projectName   camera
* @brief         Ov_Camera_Window.qml
* @author        Deng Zhimao
* @email         dengzhimao@alientek.com
* @link          www.openedv.com
* @date          2021-10-27
*******************************************************************/
import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.5

import cameraItem 1.0

Window {
    id: app_camera
    visible: true
    width: 800
    height: 480
    title: qsTr("app_camera")

    Rectangle {
        id: cameraBg
        anchors.fill: parent
        color: "black"
    }

    CameraItem {
        id: cameraItem
        anchors.fill: parent
        onCaptureStop: {
            roundButton2.enabled = true
            cameraInfo.visible = true
            moreCamera.enabled = true
        }
        onFinishedPhoto: {
            shotPhoto.source = "file:///" + photoPath
            roundButton2.enabled = true
        }
    }

    Rectangle {
        width: parent.width
        height: 40
        anchors.top: parent.top
        color: "black"
    }

    Rectangle {
        id: cameraInfo
        width: parent.width
        anchors.top: parent.top
        anchors.topMargin: 40
        anchors.bottom: panelRect.top
        color: "#D1D1D6"
        visible: false
        Text {
            visible: false
            anchors.top: parent.top
            anchors.topMargin: parent.height / 480 * 80
            anchors.horizontalCenter: parent.horizontalCenter
            text: qsTr("摄像头无法使用！可能的原因有如下：\n1.摄像头未插上\n2.摄像头驱动不对应\n3.未使用出厂内核和Uboot及文件系统\n4.不适用于USB摄像头\n5.不适用于电脑，只适用于ARM")
            font.family: "Montserrat Light"
            font.pixelSize: parent.width / 800 * 20
            color: "black"
        }
    }

    onVisibleChanged: {
        if (visible) {
            cameraItem.startCapture(true)
            cameraInfo.visible = false
        } else {
            cameraItem.startCapture(false)
        }
    }

    Rectangle {
        id: panelRect
        height: 140
        width: parent.width
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        color: "black"

        Item {
            id: item1
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 20
            anchors.horizontalCenter: parent.horizontalCenter

            width: 80
            height: 80
            RoundButton {
                id: roundButton1
                anchors.centerIn: parent
                width:  80
                height: 80
                background: Rectangle {
                    anchors.fill: parent
                    radius:  40
                    border.color: "white"
                    border.width: 6
                    color: "transparent"
                    Rectangle {
                        width: roundButton1.pressed ? 55 : 60
                        height: roundButton1.pressed ? 55 : 60
                        color: "white"
                        radius: height / 2
                        anchors.centerIn: parent
                    }
                }

                onClicked: {
                    cameraItem.startCapture(true)
                    cameraItem.startPhotoGraph(true)
                    roundButton2.enabled = false
                }
            }
        }

        RoundButton {
            id: roundButton2
            anchors.right: parent.right
            anchors.rightMargin: 20
            anchors.verticalCenter: item1.verticalCenter
            width: 60
            height: width
            background: Image {
                anchors.centerIn: parent
                width: parent.width
                height: parent.width
                source: "qrc:/icons/switch_camera_icon.png"
                opacity: roundButton2.pressed ? 0.8 : 1.0
            }

            onClicked: camera_dawer_bottom.open()
        }

        Button {
            id: roundButton3
            anchors.left: parent.left
            anchors.leftMargin: 20
            anchors.verticalCenter: item1.verticalCenter
            width: 60
            height: width
            checkable: true
            checked: false
            Image {
                id: shotPhoto
                z: -1
                anchors.centerIn: parent
                width: parent.width - 20
                height: parent.width - 20
            }
            background: Rectangle {
                anchors.fill: parent
                radius:  6
                border.width: 2
                border.color: "white"
                opacity: roundButton3.pressed ? 0.8 : 1.0
                color: "transparent"
            }
            onClicked: {
                //global_photo_Check =  false
                //global_appIndex = 1
            }
        }
    }

    Rectangle {
        id: camera_dawer_bottom
        width: parent.width
        height: parent.height
        z: 2
        color: "#55101010"
        x: 0
        y: height
        Behavior on y { PropertyAnimation { duration: 250; easing.type: Easing.OutQuad } }
        MouseArea {
            anchors.fill: parent
            onClicked: {
                camera_dawer_bottom.close()
            }
        }

        MoreCamera {
            id: moreCamera
            anchors.fill: parent
        }

        function open() {
            camera_dawer_bottom.y = 0
            moreCamera.enabled = false
            cameraItem.startCapture(false)
        }

        function close() {
            camera_dawer_bottom.y = height
            cameraItem.startCapture(true)
            cameraInfo.visible = false
        }
    }
}
