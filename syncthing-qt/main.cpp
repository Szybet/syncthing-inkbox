#include "mainwindow.h"

#include <QApplication>
#include <QFile>
#include <QDebug>

int main(int argc, char *argv[])
{
    QApplication a(argc, argv);

    a.setStyle("windows");
    QFile stylesheetFile("://eink.qss");
    stylesheetFile.open(QFile::ReadOnly);
    a.setStyleSheet(stylesheetFile.readAll());
    stylesheetFile.close();
    qDebug() << "Applied stylesheet for ereader";

    MainWindow w;
    w.show();
    return a.exec();
}
