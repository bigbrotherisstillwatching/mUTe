import QtQuick 2.4
import QtQuick.Controls 2.2


Item {

    id:utPicker
    property var nameFilters :[]
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




    Button{
        id:btnImport
        text: "Import File"
        onClicked:  picker.show()
        ToolTip{
            id:toolTip
            //delay: 1000
            timeout: 2000
            visible:utPicker.msg.length > 0
            text: utPicker.msg
        }
    }



    UTFileImportHandler{
        id: picker
        onAccept: utPicker.storeFiles(files)
    }






}

