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
/*            onPlaying: {
                if(status == EndOfMedia && list.currentIndex < list.count-1) {
                    audioPlayer.stop()
                    playing == false
                    delay(100, function() {
                        list.currentIndex += 1
                        audioPlayer.play()
                        playing = true
                    })
                } else if(status == EndOfMedia && list.currentIndex == list.count-1) {
                    audioPlayer.stop()
                    playing == false
                    delay(100, function() {
                        list.currentIndex = 0
                        audioPlayer.play()
                        playing = true
                    })
                } else if(playing == false) {
                    audioPlayer.stop()
                }
            }*/
        }

        Row {
            id: row1
            spacing: units.gu(5)
            anchors.horizontalCenter: parent.horizontalCenter
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
        }

        ListView {
            id: list
            anchors.top: row1.bottom
            anchors.topMargin: units.gu(3)
            width: parent.width
//            height: parent.height
            height: flick1.contentHeight/2
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
                Item {
                    width: parent.width
                    height: 40
                    Column {
                        Text { text: fileName }
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
    }
}
