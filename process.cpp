#include "process.h"

Process::Process(QObject *parent) : QProcess(parent)
{
}

Process::~Process()
{
}

void Process::start(const QString &program, const QVariantList &arguments) {
    QStringList args;

    // convert QVariantList from QML to QStringList for QProcess
    for (int i = 0; i < arguments.length(); i++)
        args << arguments[i].toString();

    QProcess::start(program, args);
}

QByteArray Process::readAll() {
    return QProcess::readAll();
}

QByteArray Process::readAllStandardOutput() {
    return QProcess::readAllStandardOutput();
}

QByteArray Process::readAllStandardError() {
    return QProcess::readAllStandardError();
}
