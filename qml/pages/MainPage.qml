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
import Process 1.0
import closx.restarter 1.0

Rectangle {
    id: mainPage
    anchors.fill: parent

    color: settings.darkMode ? "#121212" : "white"

    property bool playing: false
    property bool shuffle: false
    property bool repeatcurrent: false
    property bool repeatall: false
    property alias drkMd: settings.darkMode

    Component.onCompleted: {
        settings.setValue("shuffle", "")
        settings.setValue("firstShuffleArraySongPlayed", "no")
/*        delay(1000, function() {
            settings.setValue("latestIndex", list.currentIndex)
        })*/
/*        delay(1000, function() {
            list.currentIndex = settings.value("latestIndex")
        })*/
//        list.currentIndex = settings.value("latestIndex")
//        settings.setValue("latestIndex", list.currentIndex)
//        settings.setValue("songsAdded", "")
    }

    Timer {
        id: timer
    }

    Settings {
        id: settings
        property string shuffle: ""
        property bool darkMode
        property string firstShuffleArraySongPlayed: "no"
        property string latestIndex: ""
        property string latestPosition: ""
//        property string songsAdded: ""
    }

    Process {
        id: process
    }

    Connections {
        target: Qt.application

        onAboutToQuit: {
            audioPlayer.stop()
        }
    }

    Restarter {
        id: restarter
    }

/*###########FUNCTIONS##########*/

    function delay(delayTime,cb) {
        timer.interval = delayTime;
        timer.repeat = false;
        timer.triggered.connect(cb);
        timer.start();
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

    function lastShuffleArrayItem() {

        var s

        try {
            s = JSON.parse(settings.value("shuffle"))
        } catch (e) {
            s = {}
        }

        const lastElement = s[s.length - 1];
        return lastElement;
    
    }

    function nextShuffleArrayItem(listcurrentindex) {
        
        var s
        
        try {
            s = JSON.parse(settings.value("shuffle"))
        } catch (e) {
            s = {}
        }
    
        const index1 = s.indexOf(listcurrentindex);
    
        const index2 = s.find((element) => element === index1);
        
        const next = s[index2 + 1];
        
        return next;
        
    }

    function prevShuffleArrayItem(listcurrentindex) {
        
        var s
        
        try {
            s = JSON.parse(settings.value("shuffle"))
        } catch (e) {
            s = {}
        }
    
        const index1 = s.indexOf(listcurrentindex);
    
        const index2 = s.find((element) => element === index1);
        
        const prev = s[index2 - 1];
        
        return prev;
        
    }

/*##########FUNCTIONS#OVER##########*/

    PageHeader {
        id: header
        title: "mUTe"
        z: 1
        StyleHints {
            foregroundColor: settings.darkMode ? "#808080" : "black"
            backgroundColor: settings.darkMode ? "#121212" : "white"
            dividerColor: settings.darkMode ? "#808080" : "black"
        }
        contents: Rectangle {
            id: hdrrec
            anchors.fill: parent
            color: settings.darkMode ? "#121212" : "white"
            Text {
                id: hdrtxt
                anchors.left: hdrrec.left
                anchors.verticalCenter: hdrrec.verticalCenter
                text: header.title
                color: settings.darkMode ? "#808080" : "black"
                font.pointSize: 40
            }
        }
    }

    Flickable {
        id: flick1
        anchors.top: header.bottom
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
            notifyInterval: 1

            onPlaybackStateChanged: {
                if(mainPage.playing === true && mainPage.shuffle === false && mainPage.repeatcurrent === false && mainPage.repeatall === false && audioPlayer.playbackState === MediaPlayer.StoppedState && audioPlayer.status === 7 && list.currentIndex < list.count-1) {
                    list.currentIndex += 1
                    delay(250, function() {
                        audioPlayer.play()
                        mainPage.playing = true
                    })
                } else if(mainPage.playing === true && mainPage.shuffle === false && mainPage.repeatcurrent === false && mainPage.repeatall === false && audioPlayer.playbackState === MediaPlayer.StoppedState && audioPlayer.status === 7 && list.currentIndex === list.count-1) {
                    audioPlayer.stop()
                    mainPage.playing = false
                } else if(mainPage.playing === true && mainPage.shuffle === false && mainPage.repeatcurrent === false && mainPage.repeatall === true && audioPlayer.playbackState === MediaPlayer.StoppedState && audioPlayer.status === 7 && list.currentIndex === list.count-1) {
                    list.currentIndex = 0
                    delay(250, function() {
                        audioPlayer.play()
                        mainPage.playing = true
                    })
                } else if(mainPage.playing === true && mainPage.shuffle === false && mainPage.repeatcurrent === false && mainPage.repeatall === true && audioPlayer.playbackState === MediaPlayer.StoppedState && audioPlayer.status === 7 && list.currentIndex < list.count-1) {
                    list.currentIndex += 1
                    delay(250, function() {
                        audioPlayer.play()
                        mainPage.playing = true
                    })
                } else if(mainPage.playing === true && mainPage.shuffle === false && mainPage.repeatcurrent === true && mainPage.repeatall === false && audioPlayer.playbackState === MediaPlayer.StoppedState && audioPlayer.status === 7) {
                    delay(250, function() {
                        audioPlayer.play()
                        mainPage.playing = true
                    })
                } else if(mainPage.playing === true && mainPage.shuffle === true && mainPage.repeatcurrent === false && mainPage.repeatall === true && audioPlayer.playbackState === MediaPlayer.StoppedState && audioPlayer.status === 7) {
                    if(settings.value("firstShuffleArraySongPlayed") === "no") {
                        list.currentIndex = firstShuffleArrayItem()
                        settings.setValue("firstShuffleArraySongPlayed", "yes")
                    } else if(settings.value("firstShuffleArraySongPlayed") === "yes") {
                        if(nextShuffleArrayItem(list.currentIndex) === undefined) {
                            list.currentIndex = firstShuffleArrayItem()
                        } else {
                            list.currentIndex = nextShuffleArrayItem(list.currentIndex)
                        }
                    }
                    delay(250, function() {
                        audioPlayer.play()
                        mainPage.playing = true
                    })
                } else if(mainPage.playing === true && mainPage.shuffle === true && mainPage.repeatcurrent === false && mainPage.repeatall === false && audioPlayer.playbackState === MediaPlayer.StoppedState && audioPlayer.status === 7) {
                    if(settings.value("firstShuffleArraySongPlayed") === "no") {
                        list.currentIndex = firstShuffleArrayItem()
                        settings.setValue("firstShuffleArraySongPlayed", "yes")
                        delay(250, function() {
                            audioPlayer.play()
                            mainPage.playing = true
                        })
                    } else if(settings.value("firstShuffleArraySongPlayed") === "yes") {
                        if(nextShuffleArrayItem(list.currentIndex) === undefined) {
                            audioPlayer.stop()
                            mainPage.playing = false
                            mainPage.shuffle = false
                            settings.setValue("shuffle", "")
                            settings.setValue("firstShuffleArraySongPlayed", "no")
                        } else {
                            list.currentIndex = nextShuffleArrayItem(list.currentIndex)
                            delay(250, function() {
                                audioPlayer.play()
                                mainPage.playing = true
                            })
                        }
                    }                        
                }
            }
            onPlaying: settings.setValue("latestIndex", list.currentIndex)
        }

        Item {
            id: itm1
            property string text: {
                var flNm = list.model.get(list.currentIndex, "fileName");
//                var dotLastIndex = flNm.lastIndexOf('.');
                var dotLastIndex = flNm.lastIndexOf(".");
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
                border.color: settings.darkMode ? "#121212" : "white"
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
                color: settings.darkMode ? "#808080" : "black"
            }
        }

        Text {
            id: mediaTime
            anchors.top: itm1.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            horizontalAlignment: Text.AlignHCenter
            color: settings.darkMode ? "#808080" : "black"

            text: {
                let h,m,s,h2,m2,s2;
                h = Math.floor(audioPlayer.position/1000/60/60);
                m = Math.floor((audioPlayer.position/1000/60/60 - h)*60);
                s = Math.floor(((audioPlayer.position/1000/60/60 - h)*60 - m)*60);

                s < 10 ? s = `0${s}`: s = `${s}`
                m < 10 ? m = `0${m}`: m = `${m}`
                h < 10 ? h = `${h}`: h = `${h}`

                h2 = Math.floor(audioPlayer.duration/1000/60/60);
                m2 = Math.floor((audioPlayer.duration/1000/60/60 - h2)*60);
                s2 = Math.floor(((audioPlayer.duration/1000/60/60 - h2)*60 - m2)*60);

                s2 < 10 ? s2 = `0${s2}`: s2 = `${s2}`
                m2 < 10 ? m2 = `0${m2}`: m2 = `${m2}`
                h2 < 10 ? h2 = `${h2}`: h2 = `${h2}`

                return `${h}:${m}:${s} / ${h2}:${m2}:${s2}`
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
                color: settings.darkMode ? "#808080" : "#f1f1f1"

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
                color: prgrssbr.pressed ? "#32517F" : (settings.darkMode ? "#292929" : "white")
            }
            DropShadow {
                anchors.fill: rec4
                horizontalOffset: 0
                verticalOffset: 0.5
                radius: 0
                samples: 1
                color: settings.darkMode ? "black" : "gray"
                source: rec4
                spread: 0
                cached: true
            }
        }

        Row {
            id: row1
            spacing: units.gu(5)
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: prgrssbr.bottom

            Button {
                id: previous
                iconName: "media-skip-backward"
                width: units.gu(5)
                height: units.gu(5)
                color: previous.pressed ? "#32517F" : (settings.darkMode ? "#292929" : "white")
                onClicked: {
                    if(mainPage.shuffle === true && mainPage.repeatall === false && mainPage.repeatcurrent === false && list.currentIndex === firstShuffleArrayItem()) {
                        list.currentIndex = lastShuffleArrayItem()
                    } else if(mainPage.shuffle === true && mainPage.repeatall === false && mainPage.repeatcurrent === false && list.currentIndex != firstShuffleArrayItem() && list.currentIndex != lastShuffleArrayItem()) {
                        list.currentIndex = prevShuffleArrayItem(list.currentIndex)
                    } else if(mainPage.shuffle === true && mainPage.repeatall === false && mainPage.repeatcurrent === false && list.currentIndex === lastShuffleArrayItem()) {
                        list.currentIndex = prevShuffleArrayItem(list.currentIndex)
                    } else if(mainPage.shuffle === false && mainPage.repeatall === false && mainPage.repeatcurrent === false && list.currentIndex === 0) {
                        list.currentIndex = list.count-1
                    } else if(mainPage.shuffle === true && mainPage.repeatall === true && mainPage.repeatcurrent === false && list.currentIndex === firstShuffleArrayItem()) {
                        list.currentIndex = lastShuffleArrayItem()
                    } else if(mainPage.shuffle === true && mainPage.repeatall === true && mainPage.repeatcurrent === false && list.currentIndex != firstShuffleArrayItem() && list.currentIndex != lastShuffleArrayItem()) {
                        list.currentIndex = prevShuffleArrayItem(list.currentIndex)
                    } else if(mainPage.shuffle === true && mainPage.repeatall === true && mainPage.repeatcurrent === false && list.currentIndex === lastShuffleArrayItem()) {
                        list.currentIndex = prevShuffleArrayItem(list.currentIndex)
                    } else if(mainPage.shuffle === false && mainPage.repeatall === false && mainPage.repeatcurrent === false && list.currentIndex != 0) {
                        list.currentIndex -= 1
                    } else if(mainPage.shuffle === false && mainPage.repeatall === true && mainPage.repeatcurrent === false && list.currentIndex === 0) {
                        list.currentIndex = list.count-1
                    } else if(mainPage.shuffle === false && mainPage.repeatall === true && mainPage.repeatcurrent === false && list.currentIndex != 0) {
                        list.currentIndex -= 1
                    } else if(mainPage.shuffle === false && mainPage.repeatall === false && mainPage.repeatcurrent === true) {
                        //do nothing
                    }
                    if(playing === true) {
                        audioPlayer.stop()
                        playing = false
                        delay(250, function() {
                            audioPlayer.play()
                            playing = true
                        })
                    } else if(playing === false) {
                        //do nothing
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
                color: playstop.pressed ? "#32517F" : (settings.darkMode ? "#292929" : "white")
                onClicked: {
                    if(playing === true) {
                        audioPlayer.stop()
                        playing = false
                        audioPlayer.seek(0)
                        settings.setValue("firstShuffleArraySongPlayed", "no")
                        shuffle = false
                        repeatcurrent = false
                        repeatall = false
                        settings.setValue("shuffle", "")
                    } else if(playing === false) {
                        delay(250, function() {
                            audioPlayer.play()
                            playing = true
                        })
                    } else if(playing === false && shuffle === true) {
                        if(list.currentIndex === firstShuffleArrayItem()) {
                            settings.setValue("firstShuffleArraySongPlayed", "yes")
                        }
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
                color: pause.pressed ? "#32517F" : (settings.darkMode ? "#292929" : "white")
                onClicked: {
                    if(playing === true) {
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
                color: next.pressed ? "#32517F" : (settings.darkMode ? "#292929" : "white")
                onClicked: {
                    if(mainPage.shuffle === true && mainPage.repeatall === false && mainPage.repeatcurrent === false && list.currentIndex === firstShuffleArrayItem()) {
                        list.currentIndex = nextShuffleArrayItem(list.currentIndex)
                    } else if(mainPage.shuffle === true && mainPage.repeatall === false && mainPage.repeatcurrent === false && list.currentIndex != firstShuffleArrayItem() && list.currentIndex != lastShuffleArrayItem()) {
                        list.currentIndex = nextShuffleArrayItem(list.currentIndex)
                    } else if(mainPage.shuffle === true && mainPage.repeatall === false && mainPage.repeatcurrent === false && list.currentIndex === lastShuffleArrayItem()) {
                        list.currentIndex = firstShuffleArrayItem()
                    } else if(mainPage.shuffle === false && mainPage.repeatall === false && mainPage.repeatcurrent === false && list.currentIndex === list.count-1) {
                        list.currentIndex = 0
                    } else if(mainPage.shuffle === true && mainPage.repeatall === true && mainPage.repeatcurrent === false && list.currentIndex === firstShuffleArrayItem()) {
                        list.currentIndex = nextShuffleArrayItem(list.currentIndex)
                    } else if(mainPage.shuffle === true && mainPage.repeatall === true && mainPage.repeatcurrent === false && list.currentIndex != firstShuffleArrayItem() && list.currentIndex != lastShuffleArrayItem()) {
                        list.currentIndex = nextShuffleArrayItem(list.currentIndex)
                    } else if(mainPage.shuffle === true && mainPage.repeatall === true && mainPage.repeatcurrent === false && list.currentIndex === lastShuffleArrayItem()) {
                        list.currentIndex = firstShuffleArrayItem()
                    } else if(mainPage.shuffle === false && mainPage.repeatall === false && mainPage.repeatcurrent === false && list.currentIndex != list.count-1) {
                        list.currentIndex += 1
                    } else if(mainPage.shuffle === false && mainPage.repeatall === true && mainPage.repeatcurrent === false && list.currentIndex === list.count-1) {
                        list.currentIndex = 0
                    } else if(mainPage.shuffle === false && mainPage.repeatall === true && mainPage.repeatcurrent === false && list.currentIndex != list.count-1) {
                        list.currentIndex += 1
                    } else if(mainPage.shuffle === false && mainPage.repeatall === false && mainPage.repeatcurrent === true) {
                        //do nothing
                    }
                    if(playing === true) {
                        audioPlayer.stop()
                        playing = false
                        delay(250, function() {
                            audioPlayer.play()
                            playing = true
                        })
                    } else if(playing === false) {
                        //do nothing
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
                color: shufflebttn.pressed ? "#32517F" : (shuffle ? "#32517F" : (settings.darkMode ? "#292929" : "white"))
                onClicked: {
                    if(shuffle === true) {
                        shuffle = false
                        settings.setValue("shuffle", "")
                        settings.setValue("firstShuffleArraySongPlayed", "no")
                    } else if(shuffle === false) {
                        shuffle = true
                        createShuffleArray(list.count)
                    }
                    repeatcurrent = false
                }
            }

            Button {
                id: repeatcurrentbttn
                iconName: "media-playlist-repeat-one"
                width: units.gu(5)
                height: units.gu(5)
                color: repeatcurrentbttn.pressed ? "#32517F" : (repeatcurrent ? "#32517F" : (settings.darkMode ? "#292929" : "white"))
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
                color: repeatallbttn.pressed ? "#32517F" : (repeatall ? "#32517F" : (settings.darkMode ? "#292929" : "white"))
                onClicked: {
                    repeatall = !repeatall
                    repeatcurrent = false
                }
            }

            Item {
                id: importItem
                width: units.gu(5)
                height: units.gu(5)


                //import
                Loader {
                    id: utFilePicker
                    anchors.fill: parent
                    Component.onCompleted: {
                        var extensions = []
                        for (var j = 0; j < folderModel.nameFilters.length; j++){
                            var filter = folderModel.nameFilters[j]
                            var allowedExtension = filter.substring(filter.length-3,filter.length)
                            extensions.push(allowedExtension)

                        }
                        utFilePicker.setSource("./UTFileImport.qml", {nameFilters: extensions})
                    }
                }

                Connections {
                    target: utFilePicker.item
//                    onFilesAdded: console.log("Import done!")
                    onFilesAdded: {
                        console.log("Import done!")
                        if(playing === true) {
//                            settings.setValue("latestPosition", audioPlayer.position)
                            audioPlayer.pause()
                            playing = false
//                            settings.setValue("latestPosition", audioPlayer.position)
//                            audioPlayer.seek(settings.value("latestPosition"))
                            delay(1000, function() {
                                audioPlayer.play()
                                playing = true
                            })
//                            audioPlayer.play()
//                            playing = true
                        }
//                        delay(1000, function() {
//                            audioPlayer.seek(settings.value("latestPosition"))
//                            audioPlayer.play()
//                            playing = true
//                        })
//                        delay(1250, function() {
//                            audioPlayer.seek(settings.value("latestPosition"))
//                            audioPlayer.play()
//                            playing = true
//                        })
                    }
/*                    onFilesAdded: {
                        console.log("Import done!")
                        settings.setValue("songsAdded", "yes")
                        delay(1000, function() {
                            settings.setValue("songsAdded", "no")
                        })
                        if(settings.value("songsAdded") === "yes" && playing === true) {
                            audioPlayer.pause()
                            playing = false
                            delay(500, function() {
                                list.currentIndex = settings.value("latestIndex")
                                audioPlayer.play()
                                playing = true
                            })
                        } else if(settings.value("songsAdded") === "no" && playing === true) {
                            //do nothing
                        } else if(settings.value("songsAdded") === "yes" && playing === false) {
                            delay(500, function() {
                                list.currentIndex = settings.value("latestIndex")
                            })
                        } else if(settings.value("songsAdded") === "no" && playing === false) {
                            //do nothing
                        }
                    }*/
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
//                settings.setValue("latestIndex", list.currentIndex)
            }
            FolderListModel {
                id: folderModel
                folder: "file://" + dataDir
                showDirs: false
                nameFilters: ["*.ogg", "*.wav", "*.mp3", "*.m4a", "*.flac", "*.aac", "*.aiff"]
                onStatusChanged: {
                    if(folderModel.status === FolderListModel.Ready) {
                        if(list.currentIndex === "undefined") {
                            list.currentIndex = 0
                        } else {
                            list.currentIndex = settings.value("latestIndex")
                        }
                    }
                }
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
                        color: settings.darkMode ? "#808080" : "black"
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
                            color: settings.darkMode ? "#808080" : "black"
                        }
                    }
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            if(playing === true) {
                                audioPlayer.stop()
                                playing = false
                                list.currentIndex = index
//                                settings.setValue("latestIndex", list.currentIndex)
                                delay(250, function() {
                                    audioPlayer.play()
                                    playing = true
                                })
                            } else if(playing === false) {
                                list.currentIndex = index
//                                settings.setValue("latestIndex", list.currentIndex)
                            }
                        }
                    }
                }
            }
            highlight: Rectangle {
                id: rec6
                color: "#32517F"
            }
            highlightMoveDuration: 500
            highlightMoveVelocity: -1
            focus: true

            footer: Rectangle {
                id: footerItem
                width: list.width
                height: units.gu(7)
                z: 2
                color: settings.darkMode ? "#121212" : "white"

                Row {
                    id: row3
                    spacing: units.gu(3)
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter                

                    Button {
                        id: deleteallbttn
                        iconName: "delete"
                        width: units.gu(5)
                        height: units.gu(5)
                        color: deleteallbttn.pressed ? "#32517F" : (settings.darkMode ? "#292929" : "white")
                        onClicked: {
                            process.start("/bin/bash",["-c", "rm -rf /home/phablet/.local/share/mute.bigbrotherisstillwatching/*"])
                            settings.setValue("latestIndex", "")
//                            list.currentIndex = -1
//                            folderModel.remove(list.currentIndex)
                            delay(1000, function() {
                                restarter.makeRestart()
                            })
                        }
                    }

                    Button {
                        id: darkModebttn
                        iconName: settings.darkMode ? "weather-clear-symbolic" : "weather-clear-night-symbolic"
                        width: units.gu(5)
                        height: units.gu(5)
                        color: darkModebttn.pressed ? "#32517F" : (settings.darkMode ? "#292929" : "white")
                        onClicked: {
                            drkMd = !drkMd
                        }
                    }
                }

            }
            footerPositioning: ListView.PullBackFooter
        }
    }
}
