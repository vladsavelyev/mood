#include <stdio.h>
#include <stdlib.h>

#include "mainwindow.h"
#include "controller.h"
#include <QLayout>
#include <QMenuBar>

MainWindow::MainWindow(int size_, QWidget *parent) :
    QMainWindow(parent), size(size_)
{
    init();
     menuBar = new QMenuBar(this);

     QAction* newGame = new QAction("Clear", this);
     connect(newGame, SIGNAL(triggered()), this, SLOT(init()));
     QAction* save = new QAction("Save", this);
     connect(save, SIGNAL(triggered()), gameScene, SLOT(save()));

     menuBar->addAction(newGame);
     menuBar->addAction(save);
     this->setMenuBar(menuBar);
}

void MainWindow::init()
{
    gameScene = new Controller(size);
    gameView = new QGraphicsView(gameScene);
    setCentralWidget(gameView);
}
