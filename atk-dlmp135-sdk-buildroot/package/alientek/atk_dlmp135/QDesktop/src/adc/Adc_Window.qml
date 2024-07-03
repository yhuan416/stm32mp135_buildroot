/******************************************************************
Copyright © Deng Zhimao Co., Ltd. 2021-2030. All rights reserved.
* @projectName   QDesktop
* @brief         Adc_Window_copy.qml
* @author        Deng Zhimao
* @email         dengzhimao@alientek.com
* @link          www.openedv.com
* @date          2022-12-24
*******************************************************************/
import QtQuick 2.12
import QtQuick.Window 2.12

import AQuickPlugin 1.0
import adcthread 1.0
Window {
    id: root
    visible: true
    width: 800
    height: 480
    color: "white"

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

