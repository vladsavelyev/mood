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
    void drawBackground(QPainter *painter, const QRectF &rect);

    static const int cellSize = 30;
    int fieldSize;
public:
    explicit Controller(int size);

signals:
public slots:
    void save();

};

#endif // CONTROLLER_H
