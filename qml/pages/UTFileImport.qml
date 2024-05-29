import QtQuick 2.7
//import QtQuick.Controls 2.7 as Qqc
import Lomiri.Components 1.3
import Qt.labs.settings 1.0

Item {

    id: utPicker
    property var nameFilters: []
    property string msg: ""
    property alias drkMd: settings.darkMode

    signal filesAdded

    //check for allowed extensions
    function isRightFileType(fileName){
        var extension = fileName.substring(fileName.length-3,fileName.length)
        for (var j = 0; j < utPicker.nameFilters.length; j++){
            if (utPicker.nameFilters[j]===extension){
                //console.log(allowedExtension, extension)
                return true
            }
        }
        return false
    }

    function storeFiles(items){
        for (var i = 0; i < items.length; i++)
        {
            //check for good extension
            var ok = isRightFileType(items[i])
            if (ok) {
                utFileManager.importFile(items[i])
                utPicker.msg = qsTr("File added to playlist")
            }else{
                utPicker.msg = qsTr("Wrong extension type")
            }

        }

        utPicker.filesAdded()
    }

    Settings {
        id: settings
//        property string shuffle: ""
        property bool darkMode
    }

    Button {
        id: btnImport
//        text: "Import File"
        iconName: "add-to-playlist"
        width: units.gu(5)
        height: units.gu(5)
        color: {
            if(utPicker.drkMd === true) {
                btnImport.pressed ? "#32517F" : "#292929"
            } else {
                btnImport.pressed ? "#32517F" : "white"
            }
        onClicked: picker.show()
/*        ToolTip{
            id:toolTip
            //delay: 1000
            timeout: 2000
            visible:utPicker.msg.length > 0
            text: utPicker.msg
        }*/
    }

    UTFileImportHandler{
        id: picker
        onAccept: utPicker.storeFiles(files)
    }
}

