#include <stdio.h>
#include <stdlib.h>

#include "mainwindow.h"
#include "sizeconfigurator.h"
#include "controller.h"
#include <QLayout>
#include <QMenuBar>

MainWindow::MainWindow(QWidget *parent) :
    QMainWindow(parent)
{
    width = 40;
    height = 20;
    init();
     menuBar = new QMenuBar(this);

     QAction* newGame = new QAction("Clear", this);
     connect(newGame, SIGNAL(triggered()), gameScene, SLOT(clear()));
     QAction* save = new QAction("Save", this);
     connect(save, SIGNAL(triggered()), gameScene, SLOT(save()));
     QAction* config = new QAction("Configure", this);
     SizeConfigurator* sizeConfigurator = new SizeConfigurator();
     connect(config, SIGNAL(triggered()), sizeConfigurator, SLOT(show()));
     connect(sizeConfigurator, SIGNAL(save(int, int)), gameScene, SLOT(changeSize(int,int)));

     menuBar->addAction(newGame);
     menuBar->addAction(save);
     menuBar->addAction(config);
     this->setMenuBar(menuBar);
}

void MainWindow::init()
{
    gameScene = new Controller(width, height);
    gameView = new QGraphicsView(gameScene);
    setCentralWidget(gameView);
}
