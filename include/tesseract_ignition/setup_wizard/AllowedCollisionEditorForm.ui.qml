import QtQuick 2.4
import QtQuick.Controls 1.4 as QC1
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3

Item {
    width: 400
    height: 400
    property alias removeButton: removeButton
    property alias tableView: tableView
    property alias acmModel: acmModel
    property alias generateButton: generateButton
    property alias slider: slider

    id: acmEditorPage

    Slider {
        id: slider
        anchors.right: generateButton.left
        anchors.rightMargin: 5
        anchors.left: label.right
        anchors.leftMargin: 5
        anchors.top: parent.top
        anchors.topMargin: 10
    }

    Label {
        id: label
        y: 22
        text: qsTr("Resolution:")
        verticalAlignment: Text.AlignVCenter
        font.pointSize: 11
        height: 30
        anchors.left: parent.left
        anchors.leftMargin: 5
        anchors.verticalCenter: slider.verticalCenter
    }

    Button {
        id: generateButton
        x: 310
        y: 0
        width: 100
        text: qsTr("Generate")
        anchors.right: parent.right
        anchors.rightMargin: 5
        anchors.verticalCenter: slider.verticalCenter
    }

    ListModel {
        id: acmModel
        ListElement {
            name: 'item1'
            link1: "link_1"
            link2: "link_2"
            reason: "Adjacent"
        }
        ListElement {
            name: 'item1'
            link1: "link_5"
            link2: "link_2"
            reason: "Adjacent"
        }
        ListElement {
            name: 'item2'
            link1: "link_2"
            link2: "link_3"
            reason: "Adjacent"
        }
        ListElement {
            name: 'item3'
            link1: "link_3"
            link2: "link_4"
            reason: "Adjacent"
        }
        ListElement {
            name: 'item4'
            link1: "link_4"
            link2: "link_5"
            reason: "Adjacent"
        }
        ListElement {
            name: 'item5'
            link1: "link_5"
            link2: "link_6"
            reason: "Adjacent"
        }
        ListElement {
            name: 'item5'
            link1: "link_5"
            link2: "link_6"
            reason: "Adjacent"
        }
        ListElement {
            name: 'item5'
            link1: "link_5"
            link2: "link_6"
            reason: "Adjacent"
        }
        ListElement {
            name: 'item5'
            link1: "link_5"
            link2: "link_6"
            reason: "Adjacent"
        }
    }

    // https://stackoverflow.com/questions/45168702/canonical-way-to-make-custom-tableview-from-listview-in-qt-quick
    QC1.TableView {
        id: tableView
        frameVisible: true
        anchors.bottom: removeButton.top
        anchors.bottomMargin: 6
        sortIndicatorColumn: 1
        sortIndicatorVisible: false
        backgroundVisible: true
        anchors.right: parent.right
        anchors.rightMargin: 5
        anchors.left: parent.left
        anchors.leftMargin: 5
        anchors.top: slider.bottom
        anchors.topMargin: 10
        model: acmModel

        QC1.TableViewColumn {
            id: nameColumn
            role: "name"
            title: "Item"
            width: 100
        }
        QC1.TableViewColumn {
            id: link1Column
            role: "link1"
            title: "Link 1"
            width: 100
        }
        QC1.TableViewColumn {
            id: link2Column
            role: "link2"
            title: "Link 2"
            width: 100
        }
        QC1.TableViewColumn {
            id: reasonColumn
            role: "reason"
            title: "Reason"
            width: tableView.viewport.width - nameColumn.width
                   - link1Column.width - link2Column.width
        }
    }

    Button {
        id: removeButton
        x: 308
        y: 186
        text: qsTr("Remove")
        anchors.right: parent.right
        anchors.rightMargin: 5
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 5
    }
}




/*##^## Designer {
    D{i:2;anchors_y:22}
}
 ##^##*/
