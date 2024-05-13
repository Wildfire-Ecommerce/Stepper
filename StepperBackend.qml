import QtQuick 2.0
import org.asteroidos 1.0

Item {
    id: stepCounterBackend

    property int stepCount: 0
    property double previousAcceleration: 0.0
    property double stepThreshold: 1.5
    property string state: "Idle"
    property double rotationThreshold: 1.0
    property int inactivityTime: 0
    property int inactivityTimeThreshold: 60

    Timer {
        id: inactivityTimer
        interval: 10000 // 10 seconds
        onTriggered: {
            stepCounterBackend.inactivityTime += 10;
            if (stepCounterBackend.inactivityTime > stepCounterBackend.inactivityTimeThreshold) {
                motionSensor.dataRate = 10; // Decrease the sampling rate
                inactivityTimer.stop();
            }
        }
    }

    MotionSensor {
        id: motionSensor
        active: true
        dataRate: 50 // Increase the initial sampling rate
        onErrorChanged: {
            var errorText = "MotionSensor error: " + error;
            console.error(errorText);
            Qt.appendToFile("/home/nemo/error.log", errorText + "\n");
        }
        onReadingChanged: {
            var acceleration = Math.sqrt(Math.pow(reading.acceleration.x, 2) +
                                         Math.pow(reading.acceleration.y, 2) +
                                         Math.pow(reading.acceleration.z, 2));

            if (Math.abs(acceleration - previousAcceleration) > stepThreshold) {
                stepCounterBackend.inactivityTime = 0;
                if (!inactivityTimer.running) inactivityTimer.start();
                motionSensor.dataRate = 50; // Increase the sampling rate
            }

            // State machine for step detection
            switch (state) {
                case "Idle":
                    if (acceleration > stepThreshold) state = "StepStarted";
                    break;
                case "StepStarted":
                    if (acceleration < -stepThreshold) state = "StepFinished";
                    break;
                case "StepFinished":
                    if (acceleration > -stepThreshold) {
                        state = "Idle";
                        if (!gyroscopeSensor.available || Math.abs(gyroscopeSensor.reading.y) < rotationThreshold) {
                            if (!heartRateSensor.available || heartRateSensor.reading.bpm > 100) {
                                stepCounterBackend.stepCount++;
                            }
                        }
                    }
                    break;
            }

            previousAcceleration = acceleration;
        }
    }

    GyroscopeSensor {
        id: gyroscopeSensor
        active: true
        onErrorChanged: {
            var errorText = "GyroscopeSensor error: " + error;
            console.error(errorText);
            Qt.appendToFile("/home/nemo/error.log", errorText + "\n");
        }
    }

    HeartRateSensor {
        id: heartRateSensor
        active: true
        onErrorChanged: {
            var errorText = "HeartRateSensor error: " + error;
            console.error(errorText);
            Qt.appendToFile("/home/nemo/error.log", errorText + "\n");
        }
    }

    PressureSensor {
        id: pressureSensor
        active: true
        onErrorChanged: {
            var errorText = "PressureSensor error: " + error;
            console.error(errorText);
            Qt.appendToFile("/home/nemo/error.log", errorText + "\n");
        }
    }

    Settings {
        id: settings
        property alias stepCount: stepCounterBackend.stepCount
        onErrorChanged: {
            var errorText = "Settings error: " + error;
            console.error(errorText);
            Qt.appendToFile("/home/nemo/error.log", errorText + "\n");
        }
    }

    Component.onDestruction: {
        settings.stepCount = stepCounterBackend.stepCount;
    }

    Component.onCompleted: {
        stepCounterBackend.stepCount = settings.stepCount;
    }
}
