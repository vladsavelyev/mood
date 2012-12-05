#include <QGraphicsScene>
#include <QGraphicsView>

#include <QtGui/QApplication>
#include "mainwindow.h"

int main(int argc, char *argv[])
{
    QApplication a(argc, argv);
    MainWindow* mv = new MainWindow(5);

    mv->show();

    return a.exec();
}

