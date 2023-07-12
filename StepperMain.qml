import QtQuick 2.0
import org.asteroidos 1.0

ApplicationWindow {
    id: mainWindow

    StackView {
        id: stackView
        initialItem: mainMenu
        anchors.fill: parent
    }

    Component {
        id: mainMenu

        Page {
            ListView {
                width: parent.width
                height: parent.height
                model: ListModel {
                    ListElement { name: "Count steps" }
                    ListElement { name: "Settings" }
                }
                delegate: Text {
                    text: model.name
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            if (model.name === "Count steps") {
                                stackView.push(stepCounterPage)
                            } else if (model.name === "Settings") {
                                stackView.push(settingsPage)
                            }
                        }
                    }
                }
            }
        }
    }

    Component {
        id: stepCounterPage
        StepCounterBackend {}
    }

    Component {
        id: settingsPage
        Settings {}
    }
}
