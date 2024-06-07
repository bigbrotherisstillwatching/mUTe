import QtQuick 2.7
import Lomiri.Components 1.3

Item {

    id: utPicker
    property var nameFilters: []
    property string msg: ""

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

    Button {
        id: btnImport
        iconName: "add-to-playlist"
        width: units.gu(5)
        height: units.gu(5)
        color: btnImport.pressed ? "#32517F" : (drkMd ? "#292929" : "white")
        onClicked: picker.show()
    }

    UTFileImportHandler{
        id: picker
        onAccept: utPicker.storeFiles(files)
    }
}

