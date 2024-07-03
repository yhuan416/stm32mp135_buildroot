/******************************************************************
Copyright © Deng Zhimao Co., Ltd. 2021-2030. All rights reserved.
* @projectName   QDesktop
* @brief         Adc.qml
* @author        Deng Zhimao
* @email         dengzhimao@alientek.com
* @link          www.openedv.com
* @date          2022-12-24
*******************************************************************/
import QtQuick 2.0
import AQuickPlugin 1.0
import adcthread 1.0
Item {
    id: app_adc
    y: app_adc.height
    x: 0
    opacity: 0
    property real showPropertyChangeOpacity: 1
    property real showPropertyChangeX: 0
    property real showPropertyChangeY: 0
    property bool show: false

    state: ""
    states:[
        State {
            name: "show"
            PropertyChanges {
                target: app_adc
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
        color: "white"
    }
    Text {
        text: qsTr("ADC")
        anchors.top: circular_bg.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        color: "#88101010"
        font.pixelSize: 100
    }

    ACircularProgress {
        id: circular_bg
        width: 200
        height: 200
        anchors.centerIn: parent
        angel: -90
        startAngle: -120
        spanAngle: -300
        circularRadius: (width - circularWidth) / 2
        circularWidth: 20
        startColor: "#88808080"
        endColor: "#88808080"
    }

    ACircularProgress {
        id: circular
        width: 200
        height: 200
        anchors.centerIn: parent
        angel: -90
        startAngle: -120
        spanAngle: -80
        circularRadius: (width - circularWidth) / 2
        circularWidth: 20
        startColor: "green"
        endColor: "#31b573"
        Behavior on spanAngle { PropertyAnimation { duration: 200; easing.type: Easing.Linear } }
    }

    Item {
        visible: true
        anchors.centerIn: parent
        width: circular.width - circular.circularWidth * 2
        height: width
        Rectangle {
            anchors.centerIn: parent
            width: parent.width / 5 * 3
            height: width
            radius: width
            color: "#f0f0f0"
            border.width: 4
            border.color: "#22808080"
            gradient: Gradient {
                GradientStop { position: 0.0; color: "#dadada" }
                GradientStop { position: 1.0; color: "white" }
            }

            Text {
                id: adcText
                font.pixelSize: 20
                anchors.centerIn: parent
            }
        }
    }

    AdcThread {
        id: adc
        start: true
        interval: 500
        onValueChanged: {
            var adcValue = value * 0.8056
            adcText.text = Math.round(adcValue) + "mV"
            circular.spanAngle = -value * 0.073260
        }
    }
}

