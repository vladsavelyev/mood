#ifndef CONTROLLER_H
#define CONTROLLER_H

#include <QGraphicsScene>
#include <QGraphicsEllipseItem>
#include <vector>
#include <QFileDialog>
#include <fstream>
#include "ball.h"

class Controller : public QGraphicsScene
{
    Q_OBJECT
    std::vector<std::vector<Ball*> > cells;

    static const int cellSize = 20;
    int width, height;
public:
    explicit Controller(int,int);
    void init(int w, int h);

signals:
public slots:
    void save();
    void changeSize(int width, int height);
    void clear();

};

#endif // CONTROLLER_H
