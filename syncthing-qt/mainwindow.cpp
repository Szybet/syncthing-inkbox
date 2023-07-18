#include "mainwindow.h"
#include "ui_mainwindow.h"

#include <QNetworkInterface>
#include <QFile>
#include <QMessageBox>
#include <QScreen>

MainWindow::MainWindow(QWidget *parent)
    : QMainWindow(parent)
    , ui(new Ui::MainWindow)
{
    ui->setupUi(this);

    QString program = "/app-bin/syncthing.sh";
    QStringList arguments;
    process = new QProcess(this);
    process->setProcessChannelMode(QProcess::MergedChannels);
    process->start(program, arguments);
    process->waitForFinished(5000); // Gather some logs

    refresh();

    const QHostAddress &localhost = QHostAddress(QHostAddress::LocalHost);
    for (const QHostAddress &address: QNetworkInterface::allAddresses()) {
        if (address.protocol() == QAbstractSocket::IPv4Protocol && address != localhost) {
            ui->networkLabel->setText(ui->networkLabel->text() + " http://" + address.toString() + ":8384");
        }
    }
}

MainWindow::~MainWindow()
{
    delete ui;
}

void MainWindow::refresh() {
    ui->textBrowser->setPlainText(QString::fromLocal8Bit(process->readAllStandardOutput()));
}

void MainWindow::on_refreshButton_clicked()
{
    refresh();
}


void MainWindow::on_databaseButton_clicked()
{
    QFile* file = new QFile("/system-onboard/.database/LocalLibrary.db");
    file->remove();
    QMessageBox msgBox;
    msgBox.setText("Local library database deleted");
    msgBox.exec();
}


void MainWindow::on_exitButton_clicked()
{
    process->kill();
    process->waitForFinished(3000);
    QApplication::quit();
}


void MainWindow::on_infoButton_clicked()
{
    QMessageBox msgBox;
    msgBox.setText("Notes:\n"
                   "- Access the IP address via browser obviously\n"
                   "- A lot of folders / files syncing could crash the device because of lack of ram\n"
                   "- Syncthing uses 100% of the CPU while syncing - things may lag\n"
                   "- Expect high battery usage - it's a ereader not server"
                   "Settings suggestion, I don't enforce anything, but:\n"
                   "- Ignore permissions is suggested for all folders\n"
                   "- Don't monitor folders and set rescan time very high - basically only manual refreshes\n");
    msgBox.setStyleSheet("QLabel{min-width: 600px;}");
    msgBox.exec();
}

