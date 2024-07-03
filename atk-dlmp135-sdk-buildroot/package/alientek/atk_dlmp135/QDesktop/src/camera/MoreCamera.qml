import QtQuick 2.0
import QtQuick.Controls 2.5

Item {
    anchors.fill: parent

    Column {
        id: column1
        width: parent.width - 20
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        spacing: 10
        Rectangle {
            id: rectBg1
            color: "#f0f0f0"
            radius: height / 12
            width: parent.width
            height: 160
            Column {
                id: row
                anchors.centerIn: parent
                spacing: 0
                RadioButton {
                    id: camera1
                    checked: true
                    height: 80
                    width: rectBg1.width
                    anchors.horizontalCenter: parent.horizontalCenter
                    indicator: Rectangle {
                        anchors.fill: parent
                        radius: rectBg1.radius
                        color: parent.pressed ? "#dddddd" : "transparent"
                        Rectangle {
                            width: parent.width
                            height: parent.height / 2
                            anchors.bottom: parent.bottom
                            color: camera1.pressed ? "#dddddd" : "transparent"
                        }
                        Text {
                            font.pixelSize: 30
                            text: qsTr("OV5640")
                            font.family: "Montserrat Light"
                            anchors.centerIn: parent
                            color: camera1.checked? "#007aff" : "#8e8e93"
                        }
                    }
                    onCheckedChanged: {
                        if (camera1.checked)
                            cameraItem.choseCamera(0)
                    }
                }

                Rectangle {
                    width: column1.width
                    height: 1
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: "#d2d3d5"
                }

                RadioButton {
                    id: camera2
                    checked: false
                    width: rectBg1.width
                    anchors.horizontalCenter: parent.horizontalCenter
                    height: 80
                    indicator: Rectangle {
                        anchors.fill: parent
                        radius: rectBg1.radius
                        color: parent.pressed ? "#dddddd" : "transparent"
                        Rectangle {
                            width: parent.width
                            height: parent.height / 2
                            anchors.top: parent.top
                            color: camera2.pressed ? "#dddddd" : "transparent"
                        }
                        Text {
                            font.pixelSize: 30
                            text: qsTr("无其他摄像头")
                            font.family: "Montserrat Light"
                            anchors.centerIn: parent
                            color: camera2.checked? "#007aff" : "#8e8e93"
                        }
                    }
                    onCheckedChanged: {
                        if (camera2.checked)
                            cameraItem.choseCamera(2)
                    }
                }
            }
        }
        Item  {
            width: parent.width
            height: 80
            Button {
                anchors.fill: parent
                background: Rectangle {
                    anchors.fill: parent
                    color: parent.pressed ? "#dddddd" : "white"
                    radius: height / 5
                    Text {
                        text: qsTr("完成")
                        font.family: "Montserrat Light"
                        anchors.centerIn: parent
                        color: "#007aff"
                        font.pixelSize: 30
                        font.bold: true
                    }
                }
                onClicked: {
                    camera_dawer_bottom.close()
                }
            }
        }
    }
}
