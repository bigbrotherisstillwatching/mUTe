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

Rectangle {
    id: mainPage
    anchors.fill: parent

    property bool playing: false
    property bool shuffle: false
    property bool repeatcurrent: false
    property bool repeatall: false
//    property alias lstcnt: list.count

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
//        property string listcount: ""
    }

    function createShuffleArray(listcount) {
//        let arr = Array.apply(null, Array(listcount))
//            .map(function (y, i) { return i; });
        let arr = Array.from({ length: listcount }, (x, i) => i);
        let currentIndex = arr.length;

        // While there remain elements to shuffle...
        while (currentIndex != 0) {

            // Pick a remaining element...
            let randomIndex = Math.floor(Math.random() * currentIndex);
            currentIndex--;

            // And swap it with the current element.
            [arr[currentIndex], arr[randomIndex]] = [arr[randomIndex], arr[currentIndex]];
        }

/*        var s = arr

        try {
            s = JSON.parse(settings.value("shuffle"))
        } catch (e) {
            s = {}
        }*/

//        settings.setValue("shuffle", JSON.stringify(s))
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

//        s.shift();

        const array1 = s;

        const firstElement = array1.shift();

//        console.log(array1);
//        // Expected output: Array [2, 3]
        settings.setValue("shuffle", JSON.stringify(array1))

        return firstElement;

//        settings.setValue("shuffle", JSON.stringify(s))

    }

/*    Component.onCompleted: {
        delay(1000, function() {
            createShuffleArray(list.count)
        })
//        settings.listcount = lstcnt
//        createArray()
    }*/

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
        contentHeight: units.gu(175)
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
//            playlist: Playlist {
//                id: playlist
//                PlaylistItem { source: folderModel; }
//            }
            onPlaybackStateChanged: {
                if(mainPage.playing === true && mainPage.shuffle === false && mainPage.repeatcurrent === false && mainPage.repeatall === false && audioPlayer.playbackState === MediaPlayer.StoppedState && audioPlayer.status === 7 && list.currentIndex < list.count-1) {
                    list.currentIndex += 1
                    audioPlayer.play()
                } else if(mainPage.playing === true && mainPage.shuffle === false && mainPage.repeatcurrent === false && mainPage.repeatall === false && audioPlayer.playbackState === MediaPlayer.StoppedState && audioPlayer.status === 7 && list.currentIndex === list.count-1) {
                    audioPlayer.stop()
                    mainPage.playing = false
                } else if(mainPage.playing === true && mainPage.shuffle === false && mainPage.repeatcurrent === false && mainPage.repeatall === true && audioPlayer.playbackState === MediaPlayer.StoppedState && audioPlayer.status === 7 && list.currentIndex === list.count-1) {
                    list.currentIndex = 0
                    audioPlayer.play()
                } else if(mainPage.playing === true && mainPage.shuffle === false && mainPage.repeatcurrent === false && mainPage.repeatall === true && audioPlayer.playbackState === MediaPlayer.StoppedState && audioPlayer.status === 7 && list.currentIndex < list.count-1) {
                    list.currentIndex += 1
                    audioPlayer.play()
                } else if(mainPage.playing === true && mainPage.shuffle === false && mainPage.repeatcurrent === true && mainPage.repeatall === false && audioPlayer.playbackState === MediaPlayer.StoppedState && audioPlayer.status === 7) {
                    audioPlayer.play()
                } else if(mainPage.playing === true && mainPage.shuffle === true && mainPage.repeatcurrent === false && mainPage.repeatall === true && audioPlayer.playbackState === MediaPlayer.StoppedState && audioPlayer.status === 7) {
                    list.currentIndex = Math.floor(Math.random() * ((list.count-1) - 0 + 1)) + 0
                    delay(500, function() {
                        audioPlayer.play()
                    })
//                    audioPlayer.play()
                } else if(mainPage.playing === true && mainPage.shuffle === true && mainPage.repeatcurrent === false && mainPage.repeatall === false && audioPlayer.playbackState === MediaPlayer.StoppedState && audioPlayer.status === 7) {
                    if(firstShuffleArrayItem() === undefined) {
                        audioPlayer.stop()
                    } else {
//                        list.currentIndex = firstShuffleArrayItem()
                        list.currentIndex = removeFirstShuffleArrayItem()
                        audioPlayer.play()
//                        delay(500, function() {
//                            removeFirstShuffleArrayItem()
//                        })
                    }
                }
            }
        }

        Item {
            id: itm1
//            property string text: list.model.get(list.currentIndex, "fileName")
            property string text: {
                var flNm = list.model.get(list.currentIndex, "fileName");
//                var nameLength = flNm.length;
                var dotLastIndex = flNm.lastIndexOf('.');
                var finalName = flNm.substring(0, dotLastIndex);

                return finalName;
            }
            property string spacing: "          "
            property string combined: text + spacing
            property string display: combined.substring(step) + combined.substring(0, step)
            property int step: 0
            width: parent.width
//            height: units.gu(9)
            height: units.gu(6)

            Rectangle {
                id: rec1
                height: itm1.height
                width: itm1.width
                color: "transparent"
                border.color: "white"
//                border.width: 70
//                border.width: 50
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
/*            text: {
                var m = Math.floor(audioPlayer.position / 60000)
                var ms = (audioPlayer.position / 1000 - m * 60).toFixed(1)
                return `${m}:${ms.padStart(4, 0)}`
            }*/
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
//            from: 0.00
//            to: 1.00
            to: 1.0
            live: true
//            stepSize: 0.01
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: mediaTime.bottom
//            anchors.topMargin: units.gu(1)
//            enabled: true
//            enabled: audioPlayer.seekable
            value: audioPlayer.position / audioPlayer.duration
//            onMoved: audioPlayer.setPosition(value * audioPlayer.duration)
            onMoved: audioPlayer.seek(value * audioPlayer.duration)

/*            MouseArea {
                anchors.fill: parent
                enabled: true
            }*/

            background: Rectangle {
                id: rec2
                x: (prgrssbr.width  - width) / 2
                y: (prgrssbr.height - height) / 2
                implicitWidth: 200
                width: prgrssbr.availableWidth
                height: 10
                radius: 5
//                color: settings.darkMode ? "#808080" : "#f1f1f1"
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
                implicitWidth: 26
                implicitHeight: 26
                radius: 13
                color: prgrssbr.pressed ? "#32517F" : "white"
            }
        }

/*        Text {
            id: mediaTime
            anchors.top: prgrssbr.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            horizontalAlignment: Text.AlignHCenter
            text: {
                var m = Math.floor(audioPlayer.position / 60000)
                var ms = (audioPlayer.position / 1000 - m * 60).toFixed(1)
                return `${m}:${ms.padStart(4, 0)}`
            }
        }*/

/*        Item {
            id: itm1
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: units.gu(3)
//            property alias text: txt3.text
//            property int itm1spacing: 50
//            width: txt3.width + itm1spacing
            width: parent.width * 0.75
            height: txt3.height
            clip: true

            Text {
                id: txt3
//                text: "Hello World!"
                text: list.model.get(list.currentIndex, "fileName")
                NumberAnimation on x { running: true; from: 0; to: -itm1.width; duration: 5000; loops: Animation.Infinite }

                Text {
                    x: itm1.width
                    text: txt3.text
                }
            }
        }*/

/*        Item {
            id: itm1
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: units.gu(3)
            property string text: list.model.get(list.currentIndex, "fileName")
            property string spacing: "      "
            property string combined: text + spacing
            property string display: combined.substring(step) + combined.substring(0, step)
            property int step: 0

            Timer {
                id: timer2
                interval: 200
                running: true
                repeat: true
                onTriggered: parent.step = (parent.step + 1) % parent.combined.length
            }

            Text {
                text: parent.display
            }
        }*/

        Row {
            id: row1
            spacing: units.gu(3)
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: prgrssbr.bottom
//            topPadding: units.gu(1)

            Button {
                id: previous
//                text: "previous"
                iconName: "media-skip-backward"
                width: units.gu(5)
                height: units.gu(5)
//                anchors.right: playpause.left
                color: "white"
                onClicked: {
                    if(list.currentIndex == 0) {
                        list.currentIndex = list.count-1
                    } else {
                        list.currentIndex -= 1
                    }
                    if(playing == true) {
                        delay(100, function() {
                            audioPlayer.stop()
                            playing = false
                        })
                        delay(200, function() {
                            audioPlayer.play()
                            playing = true
                        })
                    } else if(playing == false) {
                        audioPlayer.play()
                        playing = true
                    }
                }
            }
        
            Button {
                id: playstop
//                text: "play/pause"
                iconName: {
                    if(playing == true) {
                        "media-playback-stop"
                    } else if(playing == false) {
                        "media-playback-start"
                    }
                }
                width: units.gu(5)
                height: units.gu(5)
//                anchors.right: next.left
                color: "white"
                onClicked: {
                    if(playing == true) {
                        audioPlayer.stop()
                        playing = false
                    } else {
                        audioPlayer.play()
                        playing = true
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
//                text: "next"
                iconName: "media-skip-forward"
                width: units.gu(5)
                height: units.gu(5)
//                anchors.right: parent.right
                color: "white"
                onClicked: {
                    if(list.currentIndex == list.count-1) {
                        list.currentIndex = 0
                    } else {
                        list.currentIndex += 1
                    }
                    if(playing == true) {
                        delay(100, function() {
                            audioPlayer.stop()
                            playing = false
                        })
                        delay(200, function() {
                            audioPlayer.play()
                            playing = true
                        })
                    } else if(playing == false) {
                        audioPlayer.play()
                        playing = true
                    }
                }
            }

/*            Button {
                id: shufflebttn
                iconName: "media-playlist-shuffle"
                width: units.gu(5)
                height: units.gu(5)
                color: shuffle ? "green" : "white"
                onClicked: {
                    shuffle = !shuffle
                    repeatcurrent = false
                    repeatall = false
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
            }*/

        }

        Row {
            id: row2
            spacing: units.gu(3)
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: row1.bottom
//            topPadding: units.gu(3)
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
//                    repeatall = false
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
//                    shuffle = false
                }
            }

        }

        ListView {
            id: list
            anchors.top: row2.bottom
//            anchors.topMargin: units.gu(3)
            anchors.topMargin: units.gu(2)
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
//            width: parent.width
//            height: parent.height
//            height: flick1.contentHeight/2
            model: folderModel
            clip: true
            onCurrentIndexChanged: {
                // This will handle changing playlist with all possible selection methods
                audioPlayer.source = folderModel.get(currentIndex, "fileURL")
            }
            FolderListModel {
                id: folderModel
                folder: "file:///home/phablet/.cache/mute.bigbrotherisstillwatching/"
                showDirs: false
                nameFilters: ["*.mp3"]
            }
            delegate: Component {
                id: cmpnnt1
                Item {
                    id: itm2
                    width: list.width
//                    height: 40
                    height: units.gu(6.5)
                    anchors.left: parent.left
                    anchors.right: parent.right

/*                    Rectangle {
                        id: rec5
                        height: parent.height
                        width: parent.width
                        anchors.left: parent.left
                        anchors.right: parent.right
                        color: "white"
//                        border.color: "black"
//                        border.width: 2
                        z: 0
                    }*/

                    Rectangle {
                        id: rec5
                        height: 1
                        width: parent.width
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.bottom: parent.bottom
                        color: "black"
//                        border.color: "black"
//                        border.width: 2
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
                            list.currentIndex = index
                        }
                    }
                }
            }
            highlight: Rectangle {
                id: rec6
                color: 'grey'
//                z: 1
            }
            focus: true
        }

        Text {
            id: txt1
            text: firstShuffleArrayItem()
        }

/*        Text {
            id: txt2
            text: audioPlayer.playbackState
            anchors.top: txt1.bottom
        }*/
    }
}
