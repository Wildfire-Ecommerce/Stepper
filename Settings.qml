import QtQuick 2.0
import org.asteroidos 1.0

Page {
    id: settingsPage

    property alias stepThreshold: stepThresholdSlider.value
    property alias inactivityTime: inactivityTimeSlider.value

    ListView {
        width: parent.width
        height: parent.height
        model: ListModel {
            ListElement { name: "Step threshold"; value: stepCounterBackend.stepThreshold }
            ListElement { name: "Inactivity time"; value: stepCounterBackend.inactivityTimeThreshold }
        }
        delegate: Row {
            Text { text: model.name + ": " }
            Slider {
                id: stepThresholdSlider
                from: 1
                to: 3
                stepSize: 0.1
                value: model.value
                onValueChanged: {
                    if (model.name === "Step threshold") {
                        stepCounterBackend.stepThreshold = value;
                    } else if (model.name === "Inactivity time") {
                        stepCounterBackend.inactivityTimeThreshold = value;
                    }
                }
            }
        }
    }
}
