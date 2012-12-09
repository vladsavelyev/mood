#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include <QMainWindow>
#include <QGraphicsView>
#include <QStatusBar>
#include <QLabel>
#include "controller.h"
#include <QGraphicsView>

class MainWindow : public QMainWindow
{
    Q_OBJECT
    QStatusBar* statusBar;
    QMenuBar* menuBar;
    Controller* gameScene;
    QGraphicsView* gameView;
    int width, height;
public:
    explicit MainWindow(QWidget *parent = 0);
signals:

public slots:
    void init();
};

#endif // MAINWINDOW_H
