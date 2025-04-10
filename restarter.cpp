#include "restarter.h"
#include <QApplication>
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
