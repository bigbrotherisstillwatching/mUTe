#include "restarter.h"
#include <QGuiApplication>
#include <QCoreApplication>
#include <QProcess>


Restarter::Restarter(QObject *parent) :
    QObject (parent)
{
}

void Restarter::makeRestart()
{
qApp->quit();
 QProcess::startDetached(qApp->arguments()[0], qApp->arguments()); //application restart
}
