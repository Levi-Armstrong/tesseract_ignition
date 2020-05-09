import QtQml.Models 2.2
import QtQuick 2.9
import QtQuick.Controls 1.4 as QC1
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.1
import QtQuick.Layouts 1.3
import QtQuick.Controls.Styles 1.4

Item {
    id: element

    //  Models that should get assigned
    property ListModel userDefinedStatesModel: userDefinedStatesModel
    property ListModel kinematicGroupsModel: kinematicGroupsModel
    property ListModel jointGroupsModel: jointGroupsModel

    property alias jointGroupListView: jointGroupListView
    property alias removeUserDefinedJointStateButton: removeUserDefinedJointStateButton
    property alias userDefinedJointStateTableView: userDefinedJointStateTableView
    property alias addUserDefinedJointStateButton: addUserDefinedJointStateButton
    property alias userDefinedJointStateNameTextField: userDefinedJointStateNameTextField
    property alias jointStateGroupNameComboBox: jointStateGroupNameComboBox

    Label {
        id: userDefinedJointStateNameLabel
        width: 125
        height: 40
        text: qsTr("Joint State Name:")
        anchors.top: parent.top
        anchors.topMargin: 5
        anchors.left: parent.left
        anchors.leftMargin: 5
        verticalAlignment: Text.AlignVCenter
    }

    TextField {
        id: userDefinedJointStateNameTextField
        y: 5
        text: qsTr("")
        placeholderText: "Joint State Name"
        anchors.right: parent.right
        anchors.rightMargin: 5
        anchors.left: userDefinedJointStateNameLabel.right
        anchors.leftMargin: 5
        anchors.verticalCenter: userDefinedJointStateNameLabel.verticalCenter
        validator: RegExpValidator {
            regExp: /[0-9A-Za-z_]+/
        }
    }

    QC1.TableView {
        id: userDefinedJointStateTableView
        height: element.height * 0.25
        anchors.bottom: removeUserDefinedJointStateButton.top
        anchors.bottomMargin: 8
        anchors.left: parent.left
        anchors.leftMargin: 5
        anchors.right: parent.right
        anchors.rightMargin: 5
        model: userDefinedStatesModel

        QC1.TableViewColumn {
            id: groupNameColumn
            role: "group_name"
            title: "Group Name"
            width: 125
        }
        QC1.TableViewColumn {
            id: stateNameColumn
            role: "state_name"
            title: "State Name"
            width: 125
        }
        QC1.TableViewColumn {
            id: jointNamesColumn
            role: "joint_names"
            title: "Joint Names"
            width: 125
        }
        QC1.TableViewColumn {
            id: jointValuesColumn
            role: "joint_values"
            title: "Joint Values"
            width: userDefinedJointStateTableView.viewport.width - groupNameColumn.width
                   - stateNameColumn.width - jointNamesColumn.width
        }
    }

    Button {
        id: removeUserDefinedJointStateButton
        x: 190
        text: qsTr("Remove")
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 5
        anchors.right: parent.right
        anchors.rightMargin: 5
    }

    Label {
        id: userDefinedGroupNameLabel
        width: 125
        height: 40
        text: qsTr("Group Name:")
        anchors.top: userDefinedJointStateNameLabel.bottom
        anchors.topMargin: 10
        anchors.left: parent.left
        anchors.leftMargin: 5
        verticalAlignment: Text.AlignVCenter
    }

    ComboBox {
        id: jointStateGroupNameComboBox
        y: 55
        anchors.left: userDefinedGroupNameLabel.right
        anchors.leftMargin: 5
        anchors.right: parent.right
        anchors.rightMargin: 5
        model: kinematicGroupsModel
        textRole: "name"
    }

    ListView {
        id: jointGroupListView
        spacing: 5
        anchors.bottom: addUserDefinedJointStateButton.top
        anchors.bottomMargin: 5
        anchors.right: parent.right
        anchors.rightMargin: 5
        anchors.top: userDefinedGroupNameLabel.bottom
        anchors.topMargin: 10
        anchors.left: parent.left
        anchors.leftMargin: 5
        model: jointGroupsModel
        delegate: Item {
            id: element1
            width: parent.width
            height: 40

            Label {
                id: jointLabel1
                width: 125
                height: 40
                text: model.name
                anchors.left: parent.left
                anchors.leftMargin: 5
                verticalAlignment: Text.AlignVCenter
            }
            Slider {
                id: slider1
                stepSize: 0.01
                anchors.right: spinBox1.left
                anchors.rightMargin: 5
                anchors.left: jointLabel1.right
                anchors.leftMargin: 5
                anchors.verticalCenter: jointLabel1.verticalCenter
                from: model.min
                to: model.max
                value: model.data
                Binding on value {
                    when: spinBox1.focus
                    value: spinBox1.value
                }
                onValueChanged: {
                    model.data = value
                }
                Connections {
                    target: slider1
                    onValueChanged: TesseractSetupWizard.onJointValue(
                                        model.name, slider1.value)
                }
            }
            QC1.SpinBox {
                id: spinBox1
                anchors.verticalCenter: jointLabel1.verticalCenter
                anchors.right: parent.right
                anchors.rightMargin: 5
                style: SpinBoxStyle {
                    background: Rectangle {
                        implicitWidth: 70
                        implicitHeight: 40
                        border.color: "gray"
                    }
                }
                decimals: 2
                value: model.data
                minimumValue: model.min
                maximumValue: model.max
                Binding on value {
                    when: slider1.pressed
                    value: slider1.value
                }
            }
        }

        ScrollIndicator.vertical: ScrollIndicator {
        }
    }

    Button {
        id: addUserDefinedJointStateButton
        x: 523
        y: 265
        text: qsTr("Add State")
        anchors.right: parent.right
        anchors.bottomMargin: 5
        anchors.rightMargin: 5
        anchors.bottom: userDefinedJointStateTableView.top
    }

    Connections {
        target: jointStateGroupNameComboBox
        onCurrentTextChanged: TesseractSetupWizard.onLoadJointGroup(
                                  jointStateGroupNameComboBox.currentText)
    }

    Connections {
        target: addUserDefinedJointStateButton
        onClicked: TesseractSetupWizard.onAddUserDefinedJointState(
                       jointStateGroupNameComboBox.currentText,
                       userDefinedJointStateNameTextField.text)
    }

    Connections {
        target: removeUserDefinedJointStateButton
        onClicked: TesseractSetupWizard.onRemoveUserDefinedJointState(
                       userDefinedJointStateTableView.currentRow)
    }
}




/*##^## Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
 ##^##*/
