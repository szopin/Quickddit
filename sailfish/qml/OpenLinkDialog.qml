/*
    Quickddit - Reddit client for mobile phones
    Copyright (C) 2014  Dickson Leong
    Copyright (C) 2015-2016  Sander van Grieken

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see [http://www.gnu.org/licenses/].
*/

import QtQuick 2.0
import Sailfish.Silica 1.0

AbstractDialog {
    id: openLinkDialog

    readonly property string title: qsTr("Open URL")
    property string url
    property string source

    acceptDestination: globalUtils.getWebViewPage()

    onAccepted: {
        pageStack.replace(globalUtils.getWebViewPage(), {url: url});
    }

    Column {
        anchors { top: parent.top; left: parent.left; right: parent.right }
        spacing: constant.paddingLarge

        DialogHeader { }

        Label {
            anchors { left: parent.left; right: parent.right; margins: constant.paddingLarge }
            text: openLinkDialog.title
            font.pixelSize: constant.fontSizeXXLarge
            color: constant.colorLight
        }

        Label {
            anchors { left: parent.left; right: parent.right; margins: constant.paddingLarge }
            horizontalAlignment: Text.AlignHCenter
            color: Theme.highlightColor
            wrapMode: Text.WrapAnywhere
            maximumLineCount: 4
            elide: Text.ElideRight
            text: url
        }

        Row {
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: constant.paddingMedium

            Button {
                text: qsTr("Open in browser")
                visible: url != ""
                onClicked: {
                    Qt.openUrlExternally(url);
                    infoBanner.alert(qsTr("Launching web browser..."));
                    openLinkDialog.reject();
                }
            }

            Button {
                text: qsTr("Copy URL")
                onClicked: {
                    QMLUtils.copyToClipboard(url);
                    infoBanner.alert(qsTr("URL copied to clipboard"));
                    openLinkDialog.reject();
                }
            }
        }

        Label {
            anchors { left: parent.left; right: parent.right; margins: constant.paddingLarge }
            text: "Source"
            visible: source != ""
            font.pixelSize: constant.fontSizeLarge
            color: constant.colorLight
        }

        Label {
            anchors { left: parent.left; right: parent.right; margins: constant.paddingLarge }
            horizontalAlignment: Text.AlignHCenter
            color: Theme.highlightColor
            wrapMode: Text.WrapAnywhere
            maximumLineCount: 4
            elide: Text.ElideRight
            visible: source != ""
            text: source
        }

        Row {
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: constant.paddingMedium

            Button {
                text: qsTr("Open in browser")
                visible: source != ""
                onClicked: {
                    Qt.openUrlExternally(source);
                    infoBanner.alert(qsTr("Launching web browser..."));
                    openLinkDialog.reject();
                }
            }

            Button {
                text: qsTr("Copy URL")
                visible: source != ""
                onClicked: {
                    QMLUtils.copyToClipboard(source);
                    infoBanner.alert(qsTr("URL copied to clipboard"));
                    openLinkDialog.reject();
                }
            }
        }

    }

}
