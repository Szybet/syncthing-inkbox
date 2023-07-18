#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include <QMainWindow>
#include <QProcess>

QT_BEGIN_NAMESPACE
namespace Ui { class MainWindow; }
QT_END_NAMESPACE

class MainWindow : public QMainWindow
{
    Q_OBJECT

public:
    MainWindow(QWidget *parent = nullptr);
    ~MainWindow();
    QProcess* process;
    void refresh();

private slots:
    void on_refreshButton_clicked();

    void on_databaseButton_clicked();

    void on_exitButton_clicked();

    void on_infoButton_clicked();

private:
    Ui::MainWindow *ui;
};
#endif // MAINWINDOW_H
