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
import Lomiri.Components 1.3
import QtQuick.Layouts 1.3
import Qt.labs.settings 1.0
import QtQuick.Window 2.2

MainView {
    id: root
    objectName: 'mainView'
    applicationName: 'mute.bigbrotherisstillwatching'
    automaticOrientation: false

    PageStack {
        id: pageStack
        anchors {
            fill: parent
        }
    }

    Component.onCompleted: pageStack.push(Qt.resolvedUrl("pages/MainPage.qml"))
}
