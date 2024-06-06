import QtQuick 2.7
import Lomiri.Components 1.3
//import Lomiri.Components.Popups 1.3 as Popups
import Lomiri.Content 1.1

Page {
    id: picker
    objectName: "contentPickerDialog"

    // Set the parent at construction time, instead of letting show()
    // set it later on, which for some reason results in the size of
    // the dialog not being updated.
    parent: QuickUtils.rootItem(this)

    property var activeTransfer: null
    property bool allowMultipleFiles
    property var contentHandler

    signal accept(var files)
    signal reject()

//    onAccept: hide()
//    onReject: hide()

    visible: true

//    Rectangle {
//        anchors.fill: parent
//        color: "black"

    header: PageHeader {
        id: header
        title: "Import"
        z: 1
        StyleHints {
            foregroundColor: drkMd ? "#808080" : "black"
            backgroundColor: drkMd ? "#121212" : "white"
            dividerColor: drkMd ? "#808080" : "black"
        }
        contents: Rectangle {
            id: hdrrec
            anchors.fill: parent
            color: drkMd ? "#121212" : "white"
            Text {
                id: hdrtxt
                anchors.left: hdrrec.left
                anchors.verticalCenter: hdrrec.verticalCenter
                text: header.title
                color: drkMd ? "#808080" : "black"
                font.pointSize: 40
            }
        }
        leadingActionBar.actions: [
            Action {
                iconName: "close"
//                text: "Back"
                onTriggered: {
                    pageStack.pop()
                }
            }
        ]
    }

    ContentTransferHint {
        anchors.fill: parent
        activeTransfer: picker.activeTransfer
    }

    ContentPeerPicker {
        id: peerPicker
        anchors.fill: parent
//        visible: true
        visible: parent.visible
        showTitle: false
        contentType: ContentType.Music
        handler: ContentHandler.Source

        onPeerSelected: {

            peer.selectionType = ContentTransfer.Single
            picker.activeTransfer = peer.request()

        }

        onCancelPressed: {
            picker.reject()
        }
    }
//}

    Connections {
        id: stateChangeConnection
        target: picker.activeTransfer
        onStateChanged: {
            //import
            if (picker.activeTransfer.state === ContentTransfer.Charged) {
                var selectedItems = []
                for(var i in picker.activeTransfer.items) {

                    selectedItems.push(String(picker.activeTransfer.items[i].url).replace("file://", ""))
                }
                //utPicker.storeFiles(selectedItems)
                picker.accept(selectedItems)
//                picker.hide()
                pageStack.pop()
            }
        }
    }
}
