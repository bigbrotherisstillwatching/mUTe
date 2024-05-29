/*
 * Copyright (C) 2024  bbisw
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; version 3.
 *
 * mute is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

import QtQuick 2.7
import QtQuick.Controls 2.7 as Qqc
import QtQuick.Layouts 1.3
import QtMultimedia 5.12
import Qt.labs.folderlistmodel 2.12
import Lomiri.Components 1.3
import Qt.labs.settings 1.0
import QtGraphicalEffects 1.12

Rectangle {
    id: mainPage
    anchors.fill: parent

    property bool playing: false
    property bool shuffle: false
    property bool repeatcurrent: false
    property bool repeatall: false

    Timer {
        id: timer
    }

    function delay(delayTime,cb) {
        timer.interval = delayTime;
        timer.repeat = false;
        timer.triggered.connect(cb);
        timer.start();
    }

    Settings {
        id: settings
        property string shuffle: ""
    }

    Connections {
        target: Qt.application

        onAboutToQuit: {
            audioPlayer.stop()
        }
    }

    function createShuffleArray(listcount) {

        let arr = Array.from({ length: listcount }, (x, i) => i);
        let currentIndex = arr.length;

        while (currentIndex != 0) {

            let randomIndex = Math.floor(Math.random() * currentIndex);
            currentIndex--;

            [arr[currentIndex], arr[randomIndex]] = [arr[randomIndex], arr[currentIndex]];
        }

        settings.setValue("shuffle", JSON.stringify(arr))
    }

    function firstShuffleArrayItem() {

        var s

        try {
            s = JSON.parse(settings.value("shuffle"))
        } catch (e) {
            s = {}
        }

        let f = s[0];
        return f;
    }

    function removeFirstShuffleArrayItem() {

        var s

        try {
            s = JSON.parse(settings.value("shuffle"))
        } catch (e) {
            s = {}
        }

        const array1 = s;

        const firstElement = array1.shift();

        settings.setValue("shuffle", JSON.stringify(array1))

        return firstElement;

    }

    PageHeader {
        id: header
        title: "mUTe"
        z: 1
        StyleHints {
            foregroundColor: "black"
            backgroundColor: "white"
            dividerColor: "black"
        }
        contents: Rectangle {
            id: hdrrec
            anchors.fill: parent
            color: "white"
            Text {
                id: hdrtxt
                anchors.left: hdrrec.left
                anchors.verticalCenter: hdrrec.verticalCenter
                text: header.title
                color: "black"
                font.pointSize: 40
            }
        }
    }

    Flickable {
        id: flick1
        anchors.top: header.bottom
//        contentHeight: units.gu(175)
//        contentHeight: itm1.height + mediaTime.height + prgrssbr.height + row1.height + row2.height + list.height
        contentHeight: mainPage.height - header.height
        contentWidth: mainPage.width
        width: mainPage.width
        height: mainPage.height - header.height
        anchors.horizontalCenter: mainPage.horizontalCenter
        flickableDirection: Flickable.VerticalFlick

        MouseArea {
            id: ma1
            anchors.fill: parent
 
            onClicked: {
                focus = true
            }
        }

        MediaPlayer {
            id: audioPlayer
            audioRole: MediaPlayer.MusicRole

            onPlaybackStateChanged: {
                if(mainPage.playing === true && mainPage.shuffle === false && mainPage.repeatcurrent === false && mainPage.repeatall === false && audioPlayer.playbackState === MediaPlayer.StoppedState && audioPlayer.status === 7 && list.currentIndex < list.count-1) {
                    list.currentIndex += 1
                    delay(250, function() {
                        audioPlayer.play()
                        playing = true
                    })
                } else if(mainPage.playing === true && mainPage.shuffle === false && mainPage.repeatcurrent === false && mainPage.repeatall === false && audioPlayer.playbackState === MediaPlayer.StoppedState && audioPlayer.status === 7 && list.currentIndex === list.count-1) {
                    audioPlayer.stop()
                    mainPage.playing = false
                } else if(mainPage.playing === true && mainPage.shuffle === false && mainPage.repeatcurrent === false && mainPage.repeatall === true && audioPlayer.playbackState === MediaPlayer.StoppedState && audioPlayer.status === 7 && list.currentIndex === list.count-1) {
                    list.currentIndex = 0
                    delay(250, function() {
                        audioPlayer.play()
                        playing = true
                    })
                } else if(mainPage.playing === true && mainPage.shuffle === false && mainPage.repeatcurrent === false && mainPage.repeatall === true && audioPlayer.playbackState === MediaPlayer.StoppedState && audioPlayer.status === 7 && list.currentIndex < list.count-1) {
                    list.currentIndex += 1
                    delay(250, function() {
                        audioPlayer.play()
                        playing = true
                    })
                } else if(mainPage.playing === true && mainPage.shuffle === false && mainPage.repeatcurrent === true && mainPage.repeatall === false && audioPlayer.playbackState === MediaPlayer.StoppedState && audioPlayer.status === 7) {
                    delay(250, function() {
                        audioPlayer.play()
                        playing = true
                    })
                } else if(mainPage.playing === true && mainPage.shuffle === true && mainPage.repeatcurrent === false && mainPage.repeatall === true && audioPlayer.playbackState === MediaPlayer.StoppedState && audioPlayer.status === 7) {
                    list.currentIndex = Math.floor(Math.random() * ((list.count-1) - 0 + 1)) + 0
                    delay(250, function() {
                        audioPlayer.play()
                        playing = true
                    })
                } else if(mainPage.playing === true && mainPage.shuffle === true && mainPage.repeatcurrent === false && mainPage.repeatall === false && audioPlayer.playbackState === MediaPlayer.StoppedState && audioPlayer.status === 7) {
                    if(firstShuffleArrayItem() === undefined) {
                        audioPlayer.stop()
                        mainPage.playing = false
                        mainPage.shuffle = false
                    } else {
                        list.currentIndex = removeFirstShuffleArrayItem()
                        delay(250, function() {
                            audioPlayer.play()
                            playing = true
                        })
                    }
                }
            }
        }

        Item {
            id: itm1
            property string text: {
                var flNm = list.model.get(list.currentIndex, "fileName");
                var dotLastIndex = flNm.lastIndexOf('.');
                var finalName = flNm.substring(0, dotLastIndex);

                return finalName;
            }
            property string spacing: "          "
            property string combined: text + spacing
            property string display: combined.substring(step) + combined.substring(0, step)
            property int step: 0
            width: parent.width
            height: units.gu(6)

            Rectangle {
                id: rec1
                height: itm1.height
                width: itm1.width
                color: "transparent"
                border.color: "white"
                border.width: units.gu(2)
                z: 1
            }

            Timer {
                id: timer2
                interval: 200
                running: true
                repeat: true
                onTriggered: itm1.step = (itm1.step + 1) % itm1.combined.length
            }

            Text {
                text: itm1.display
                anchors.horizontalCenter: rec1.horizontalCenter
                anchors.verticalCenter: rec1.verticalCenter
            }
        }

        Text {
            id: mediaTime
            anchors.top: itm1.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            horizontalAlignment: Text.AlignHCenter

            text: {
                let h,m,s;
                h = Math.floor(audioPlayer.position/1000/60/60);
                m = Math.floor((audioPlayer.position/1000/60/60 - h)*60);
                s = Math.floor(((audioPlayer.position/1000/60/60 - h)*60 - m)*60);

                s < 10 ? s = `0${s}`: s = `${s}`
                m < 10 ? m = `0${m}`: m = `${m}`
                h < 10 ? h = `${h}`: h = `${h}`

                return `${h}:${m}:${s}`
            }
        }

        Qqc.Slider {
            id: prgrssbr
            to: 1.0
            live: true
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: mediaTime.bottom
            value: audioPlayer.position / audioPlayer.duration
            onMoved: audioPlayer.seek(value * audioPlayer.duration)

            background: Rectangle {
                id: rec2
                x: (prgrssbr.width  - width) / 2
                y: (prgrssbr.height - height) / 2
                implicitWidth: 200
                width: prgrssbr.availableWidth
                height: 10
                radius: 5
                color: "#f1f1f1"

                Rectangle {
                    id: rec3
                    width: prgrssbr.visualPosition * parent.width
                    height: parent.height
                    color: "#32517F"
                    radius: 2
                }
            }

            handle: Rectangle {
                id: rec4
                visible: true
                x: prgrssbr.leftPadding + (prgrssbr.horizontal ? prgrssbr.visualPosition * (prgrssbr.availableWidth - width) : (prgrssbr.availableWidth - width) / 2)
                y: prgrssbr.topPadding + (prgrssbr.vertical ? prgrssbr.visualPosition * (prgrssbr.availableHeight - height) : (prgrssbr.availableHeight - height) / 2)
                implicitWidth: 52
                implicitHeight: 52
                radius: 26
                color: prgrssbr.pressed ? "#32517F" : "white"
            }
            DropShadow {
                anchors.fill: rec4
                horizontalOffset: 1
                verticalOffset: 1
                radius: 6
                samples: 13
                color: "black"
                source: rec4
                spread: 0
                cached: true
            }
        }

        Row {
            id: row1
            spacing: units.gu(3)
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: prgrssbr.bottom

            Button {
                id: previous
                iconName: "media-skip-backward"
                width: units.gu(5)
                height: units.gu(5)
                color: "white"
                onClicked: {
                    if(shuffle === true && repeatall === false) {
                        list.currentIndex = Math.floor(Math.random() * ((list.count-1) - 0 + 1)) + 0
                    } else if(shuffle === false && repeatall === false && list.currentIndex === 0) {
                        list.currentIndex = list.count-1
                    } else if(shuffle === true && repeatall === true) {
                        createShuffleArray(list.count)
                        list.currentIndex = removeFirstShuffleArrayItem()
                    } else if(shuffle === false && repeatall === false && list.currentIndex != 0) {
                        list.currentIndex -= 1
                    }
                    if(playing == true) {
                        audioPlayer.stop()
                        playing = false
                        delay(250, function() {
                            audioPlayer.play()
                            playing = true
                        })
                    } else if(playing == false) {
                        delay(250, function() {
                            audioPlayer.play()
                            playing = true
                        })
                    }
                }
            }
        
            Button {
                id: playstop
                iconName: {
                    if(playing === true) {
                        "media-playback-stop"
                    } else if(playing === false) {
                        "media-playback-start"
                    }
                }
                width: units.gu(5)
                height: units.gu(5)
                color: "white"
                onClicked: {
                    if(playing === true) {
                        audioPlayer.stop()
                        playing = false
                    } else {
                        delay(250, function() {
                            audioPlayer.play()
                            playing = true
                        })
                    }
                }
            }

            Button {
                id: pause
                iconName: "media-playback-pause"
                width: units.gu(5)
                height: units.gu(5)
                color: "white"
                onClicked: {
                    if(playing == true) {
                        audioPlayer.pause()
                        playing = false
                    }
                }
            }

            Button {
                id: next
                iconName: "media-skip-forward"
                width: units.gu(5)
                height: units.gu(5)
                color: "white"
                onClicked: {
                    if(shuffle === true && repeatall === false) {
                        list.currentIndex = Math.floor(Math.random() * ((list.count-1) - 0 + 1)) + 0
                    } else if(shuffle === false && repeatall === false && list.currentIndex === list.count-1) {
                        list.currentIndex = 0
                    } else if(shuffle === true && repeatall === true) {
                        createShuffleArray(list.count)
                        list.currentIndex = removeFirstShuffleArrayItem()
                    } else if(shuffle === false && repeatall === false && list.currentIndex != list.count-1) {
                        list.currentIndex += 1
                    }
                    if(playing == true) {
                        audioPlayer.stop()
                        playing = false
                        delay(250, function() {
                            audioPlayer.play()
                            playing = true
                        })
                    } else if(playing == false) {
                        delay(250, function() {
                            audioPlayer.play()
                            playing = true
                        })
                    }
                }
            }
        }

        Row {
            id: row2
            spacing: units.gu(3)
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: row1.bottom
            topPadding: units.gu(2)

            Button {
                id: shufflebttn
                iconName: "media-playlist-shuffle"
                width: units.gu(5)
                height: units.gu(5)
                color: shuffle ? "green" : "white"
                onClicked: {
                    shuffle = !shuffle
                    repeatcurrent = false
                    createShuffleArray(list.count)
                }
            }

            Button {
                id: repeatcurrentbttn
                iconName: "media-playlist-repeat-one"
                width: units.gu(5)
                height: units.gu(5)
                color: repeatcurrent ? "green" : "white"
                onClicked: {
                    repeatcurrent = !repeatcurrent
                    repeatall = false
                    shuffle = false
                }
            }

            Button {
                id: repeatallbttn
                iconName: "media-playlist-repeat"
                width: units.gu(5)
                height: units.gu(5)
                color: repeatall ? "green" : "white"
                onClicked: {
                    repeatall = !repeatall
                    repeatcurrent = false
                }
            }

            Item {
                id: importItem
//                width:100
//                height: 50
                width: units.gu(5)
                height: units.gu(5)


                //import
                Loader {
                    id: utFilePicker
                    anchors.fill: parent
                    //anchors.left: btnContainer.left
                    //anchors.centerIn: parent
                    Component.onCompleted: {
//                        if (typeof UBUNTU_TOUCH !== "undefined"){

                        //convert nameFilters for utFilePicker
                            var extensions = []
                            for (var j = 0; j < folderModel.nameFilters.length; j++){
                                var filter = folderModel.nameFilters[j]
                                var allowedExtension = filter.substring(filter.length-3,filter.length)
                                extensions.push(allowedExtension)

                            }
                            utFilePicker.setSource("./UTFileImport.qml", {nameFilters: extensions})
//                        }
                    }
                }

                Connections{
                    target: utFilePicker.item
                    onFilesAdded: console.log("Import done!")
                }
            }
        }

        ListView {
            id: list
            anchors.top: row2.bottom
            anchors.topMargin: units.gu(2)
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            model: folderModel
            clip: true
            onCurrentIndexChanged: {
                audioPlayer.source = folderModel.get(currentIndex, "fileURL")
            }
            FolderListModel {
                id: folderModel
//                folder: "file:///home/phablet/.cache/mute.bigbrotherisstillwatching/"
//                folder: "file:///home/phablet/.local/share/mute.bigbrotherisstillwatching/"
                folder: "file://" + dataDir
                showDirs: false
//                nameFilters: ["*.mp3"]
                nameFilters: ["*.ogg", "*.wav", "*.mp3", "*.m4a", "*.flac", "*.aac", "*.aiff"]
            }
            delegate: Component {
                id: cmpnnt1
                Item {
                    id: itm2
                    width: list.width
                    height: units.gu(6.5)
                    anchors.left: parent.left
                    anchors.right: parent.right

                    Rectangle {
                        id: rec5
                        height: 1
                        width: parent.width
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.bottom: parent.bottom
                        color: "black"
                        z: 1
                    }

                    Column {
                        id: clmn1
                        anchors.left: parent.left
                        anchors.right: parent.right
                        z: 1
                        Text {
                            id: txt4
                            text: fileName
                            height: parent.height
                            width: parent.width
                            leftPadding: units.gu(2)
                            rightPadding: units.gu(2)
                            maximumLineCount: 3
                            anchors.left: parent.left
                            anchors.right: parent.right
                            wrapMode: Text.Wrap
                        }
                    }
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            if(playing === true) {
//                                list.currentIndex = index
                                audioPlayer.stop()
                                playing = false
                                list.currentIndex = index
                                delay(250, function() {
                                    audioPlayer.play()
                                    playing = true
                                })
                            } else if(playing === false) {
                                list.currentIndex = index
                            }
                        }
                    }
                }
            }
            highlight: Rectangle {
                id: rec6
                color: 'grey'
            }
            highlightMoveDuration: 500
            highlightMoveVelocity: -1
            focus: true
        }
    }
}
