/******************************************************************
Copyright © Deng Zhimao Co., Ltd. 2021-2030. All rights reserved.
* @projectName   QDesktop
* @brief         Page1.qml
* @author        Deng Zhimao
* @email         dengzhimao@alientek.com
* @link          www.openedv.com
* @date          2021-08-31
*******************************************************************/
import QtQuick 2.0
import QtQuick.Controls 2.5

Item {
    property int rect_width: root_width / 720 * 280
    property int rect_height: root_width / 720 * 120
    property int rect_radius: root_width / 720 * 20
    property int rect_spacing: root_width / 720 * 80

    ListModel {
        id: model1
        ListElement {name: ""}
        ListElement {name: ""}
        ListElement {name: ""}
        ListElement {name: ""}
        ListElement {name: ""}
        ListElement {name: ""}
        ListElement {name: ""}
        ListElement {name: ""}
        function getIcon(index, id) {
            var data = [
                        ["qrc:/icons/music_app_icon.png"],
                        ["qrc:/icons/camera_app_icon.png"],
                        ["qrc:/icons/photos_app_icon.png"],
                        ["qrc:/icons/settings_app_icon.png"],
                        ["qrc:/icons/player_app_icon.png"],
                        ["qrc:/icons/adc_app_icon.png"],
                        ["qrc:/icons/wifi_app_icon.png"],
                        ["qrc:/icons/debug_app_icon.png"],
                    ]
            return data[index][0];
        }

        function getAppName(index, id) {
            var data = [
                        ["音乐"],
                        ["相机"],
                        ["照片"],
                        ["设置"],
                        ["播放器"],
                        ["ADC"],
                        ["Wifi"],
                        ["Debug"],
                    ]
            return data[index][0];
        }

        function geBbgColor(index, id) {
            var data = [
                        ["#13507c"],
                        ["#352867"],
                        ["#009e96"],
                        ["#3994d3"],
                    ]
            return data[index][0];
        }
    }
    Component {
        id: item_gridView_delegate
        Rectangle {
            width: item_gridView.cellWidth
            height: item_gridView.cellHeight
            color: "transparent"
            Rectangle {
                id: app_Rect
                width: appIconWidth
                height: width
                color: "transparent"
                anchors.top: parent.top
                anchors.topMargin: -5
                anchors.horizontalCenter: parent.horizontalCenter
                opacity: mouseArea.pressed ? 0.8 : 1.0
                Image {
                    id: appIcon1
                    source: item_gridView.model.getIcon(index, 0)
                    anchors.fill: parent
                    MouseArea {
                        id: mouseArea
                        anchors.fill: parent
                        onClicked: item_gridView.currentIndex = index
                    }
                }
            }
            Text {
                anchors.top: app_Rect.bottom
                anchors.topMargin: -10
                visible: true
                anchors.horizontalCenter: parent.horizontalCenter
                horizontalAlignment: Text.AlignHCenter
                id: appName2
                text: qsTr(item_gridView.model.getAppName(index, 0))
                color: "white"
                font.family: "Montserrat Regular"
                font.pixelSize: appIconWidth / 5
            }
        }
    }

    //    ListModel {
    //        id: model2
    //        ListElement {name: ""}
    //        ListElement {name: ""}
    //        ListElement {name: ""}
    //        ListElement {name: ""}
    //        ListElement {name: ""}
    //        function getIcon(index, id) {
    //            var data = [
    //                        ["qrc:/icons/music_app_icon.png"],
    //                        ["qrc:/icons/camera_app_icon.png"],
    //                        ["qrc:/icons/photos_app_icon.png"],
    //                        ["qrc:/icons/settings_app_icon.png"],
    //                        ["qrc:/icons/player_app_icon.png"],
    //                    ]
    //            return data[index][0];
    //        }

    //        function getAppName(index, id) {
    //            var data = [
    //                        ["音乐"],
    //                        ["相册"],
    //                        ["天气"],
    //                        ["相机"],
    //                    ]
    //            return data[index][0];
    //        }

    //        function geBbgColor(index, id) {
    //            var data = [
    //                        ["#13507c"],
    //                        ["#352867"],
    //                        ["#009e96"],
    //                        ["#3994d3"],
    //                    ]
    //            return data[index][0];
    //        }
    //    }
    //    Component {
    //        id: item_listView_delegate
    //        Rectangle {
    //            width: appIconWidth
    //            height: item_listView.height
    //            color: "transparent"
    //            opacity: mouseArea.pressed ? 0.8 : 1.0
    //            Rectangle {
    //                id: app_Rect
    //                width: appIconWidth
    //                height: width
    //                color: "transparent"
    //                anchors.centerIn: parent
    //                Image {
    //                    id: appIcon1
    //                    source: item_listView.model.getIcon(index, 0)
    //                    anchors.fill: parent
    //                    MouseArea {
    //                        id: mouseArea
    //                        anchors.fill: parent
    //                        onClicked: item_listView.currentIndex = index
    //                    }
    //                }
    //            }
    //            Text {
    //                anchors.top: app_Rect.bottom
    //                anchors.topMargin: -15
    //                visible: false
    //                anchors.horizontalCenter: parent.horizontalCenter
    //                id: appName2
    //                //text: qsTr(item_listView.model.getAppName(index, 0))
    //                color: "white"
    //                font.family: "Montserrat Light"
    //                font.pixelSize: 20
    //            }
    //        }
    //    }


    id: page1
    Item {
        id: app_item_control1
        width: parent.width
        height: parent.height
        x: 0
        y: 0
        opacity: 1
        Behavior on opacity { PropertyAnimation { duration: 0; easing.type: Easing.InOutBack } }
        Behavior on y { PropertyAnimation { duration: 0; easing.type: Easing.InOutBack } }
        //        onVisibleChanged: {
        //            if (main_swipeView.currentIndex === 0) {
        //                if (visible) {
        //                    app_item_control1.y = 0
        //                    app_item_control1.opacity = 1

        //                } else {
        //                    app_item_control1.y = -page1.height
        //                    app_item_control1.opacity = 0
        //                }
        //            }
        //        }

        Item {
            id: item1
            anchors.fill: parent
            Row {
                id: row
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.bottomMargin: botton_app_Item_parent.height + 30
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.topMargin: 40
                spacing: 0
                width: parent.width
                Item {
                    width: item1.width / 3
                    height: width
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            system_time = "00:00"
                            //timefromnetwork.updateTime()
                        }
                    }

                    Text {
                        anchors.left: parent.left
                        anchors.leftMargin: 30
                        id: time_text
                        text: system_time
                        color: time_display_color
                        font.family: "Montserrat Regular"
                        font.pixelSize:  appIconWidth / 2
                        //font.bold: true
                    }

                    Text {
                        id: date_text
                        anchors.left: parent.left
                        anchors.leftMargin: 30
                        anchors.top: time_text.bottom
                        text:  if (system_week == "Sun")
                                   "周日  " + system_date2
                               else if (system_week == "Mon")
                                   "周一  " + system_date2
                               else if (system_week == "Tue")
                                   "周二  " + system_date2
                               else if (system_week == "Wed")
                                   "周三  " + system_date2
                               else if (system_week == "Thu")
                                   "周四  " + system_date2
                               else if (system_week == "Fri")
                                   "周五  " + system_date2
                               else if (system_week == "Sat")
                                   "周六  " + system_date2

                        color: time_display_color
                        font.family: "Montserrat Light"
                        font.pixelSize:  appIconWidth / 4
                        //font.bold: true
                        visible: true
                    }
                }
                GridView {
                    id: item_gridView
                    visible: true
                    width: item1.width / 3 * 2
                    interactive: false
                    height: width
                    currentIndex: -1
                    clip: true
                    snapMode: ListView.SnapOneItem
                    cellWidth: item_gridView.width / (item_gridView.width / (appIconWidth + appIconWidth / 2) )
                    cellHeight: item_gridView.height / (item_gridView.height / appIconWidth) * 1.5
                    model: model1
                    delegate: item_gridView_delegate
                    onCurrentIndexChanged: {
                        if (currentIndex == -1)
                            return;
                        global_appIndex = currentIndex
                        item_gridView.currentIndex = -1
                    }
                }
            }


            //            Rectangle {
            //                id: botton_app_Item_parent
            //                width: item_listView.contentWidth
            //                height: appIconWidth + radius / 2
            //                radius: 30
            //                color: "#eeaaaaaa"
            //                visible: true
            //                anchors.bottom: parent.bottom
            //                anchors.bottomMargin: 30
            //                anchors.horizontalCenter: parent.horizontalCenter

            //                ListView {
            //                    id: item_listView
            //                    visible: true
            //                    anchors.centerIn: parent
            //                    height: parent.height
            //                    width: parent.width
            //                    interactive: false
            //                    orientation: ListView.Horizontal
            //                    currentIndex: -1
            //                    clip: true
            //                    snapMode: ListView.SnapOneItem
            //                    model: model2
            //                    delegate: item_listView_delegate
            //                    spacing: appIconWidth / 10
            //                    onCurrentIndexChanged: {
            //                        if (currentIndex == -1)
            //                            return;
            //                        global_appIndex = currentIndex
            //                        item_listView.currentIndex = -1
            //                    }
            //                }
            //            }
        }
    }
}
