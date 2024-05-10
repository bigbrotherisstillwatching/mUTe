/*
 * Copyright (C) 2024  bbisw
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; version 3.
 *
 * utequalizer is distributed in the hope that it will be useful,
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
                }
            }
        }

        Item {
            id: itm1
            property string text: list.model.get(list.currentIndex, "fileName")
            property string spacing: "     "
            property string combined: text + spacing
            property string display: combined.substring(step) + combined.substring(0, step)
            property int step: 0
            width: parent.width
            height: units.gu(9)

            Rectangle {
                id: rec1
                height: itm1.height
                width: itm1.width
                color: "transparent"
                border.color: "red"
                border.width: 70
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
            anchors.top: itm11.bottom
            topPadding: units.gu(3)

            Button {
                id: previous
//                text: "previous"
                iconName: "media-seek-backward"
                width: units.gu(5)
                height: units.gu(5)
//                anchors.right: playpause.left
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
                id: playpause
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
                id: next
//                text: "next"
                iconName: "media-seek-forward"
                width: units.gu(5)
                height: units.gu(5)
//                anchors.right: parent.right
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

            Button {
                id: shufflebttn
                iconName: "media-playlist-shuffle"
                width: units.gu(5)
                height: units.gu(5)
                color: shuffle ? "green" : "white"
                onClicked: shuffle = !shuffle
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

        }

        ListView {
            id: list
            anchors.top: row1.bottom
            anchors.topMargin: units.gu(3)
            width: parent.width
            height: parent.height
//            height: flick1.contentHeight/2
            model: folderModel
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
                    width: parent.width
                    height: 40
                    Column {
                        id: clmn1
                        Text {
                            id: txt4
                            text: fileName
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
                color: 'grey'
            }
            focus: true
        }

        Text {
            id: txt1
            text: audioPlayer.status
        }

        Text {
            id: txt2
            text: audioPlayer.playbackState
            anchors.top: txt1.bottom
        }
    }
}
