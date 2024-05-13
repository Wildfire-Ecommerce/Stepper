import QtQuick 2.0
import org.asteroidos 1.0

Page {
    id: settingsPage

    property alias stepThreshold: stepThresholdSlider.value
    property alias inactivityTime: inactivityTimeSlider.value

    Column {
        width: parent.width
        height: parent.height

        Row {
            Text { text: "Step threshold: " }
            Slider {
                id: stepThresholdSlider
                from: 1
                to: 3
                stepSize: 0.1
                value: stepCounterBackend.stepThreshold
                onValueChanged: {
                    stepCounterBackend.stepThreshold = value;
                }
            }
        }

        Row {
            Text { text: "Inactivity time: " }
            Slider {
                id: inactivityTimeSlider
                from: 30
                to: 120
                stepSize: 10
                value: stepCounterBackend.inactivityTimeThreshold
                onValueChanged: {
                    stepCounterBackend.inactivityTimeThreshold = value;
                }
            }
        }
    }
}
