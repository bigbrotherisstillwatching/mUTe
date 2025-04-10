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

#include <QGuiApplication>
#include <QCoreApplication>
#include <QUrl>
#include <QString>
#include <QQuickView>
#include <QStandardPaths>
#include "utfilemgr.h"
#include <QQmlContext>
#include <QtQml>
#include "process.h"

int main(int argc, char *argv[])
{
    QGuiApplication *app = new QGuiApplication(argc, (char**)argv);
    app->setApplicationName("mute.bigbrotherisstillwatching");

    QString dataDir;
    dataDir = QStandardPaths::writableLocation(QStandardPaths::AppDataLocation);

    qDebug() << "Starting app from main.cpp";

    qmlRegisterType<Process>( "Process", 1, 0, "Process" );

    QQuickView *view = new QQuickView();

    view->rootContext()->setContextProperty("dataDir", dataDir);

    UTFileMgr fileManager(dataDir);
    view->rootContext()->setContextProperty("UBUNTU_TOUCH", true);
    view->rootContext()->setContextProperty("utFileManager", &fileManager);

    view->setSource(QUrl("qrc:/Main.qml"));
    view->setResizeMode(QQuickView::SizeRootObjectToView);
    QObject::connect((QObject*)view->engine(), SIGNAL(quit()), app, SLOT(quit()));
    view->show();

    return app->exec();
}
