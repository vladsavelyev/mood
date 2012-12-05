#include "controller.h"
#include <QPainter>
#include <QString>

#include <QGraphicsRectItem>

Controller::Controller(int size) :
    QGraphicsScene()
{
    fieldSize = size;
    cells.resize(fieldSize);
    for(size_t i = 0; i < cells.size(); ++i)
    {
        cells[i].assign(cells.size(), 0);
    }
    for(size_t i = 0; i < cells.size(); ++i)
        for(size_t j = 0; j < cells.size(); ++j)
        {
            Ball* ell = new Ball(i * cellSize + 1, j * cellSize + 1, cellSize - 2, cellSize - 2);
            addItem(ell);
            cells[i][j] = ell;
        }
}

void Controller::drawBackground(QPainter *painter, const QRectF &rect)
{
    painter->setPen(Qt::black);
    for(size_t i = 0; i < cells.size(); ++i)
        for(size_t j = 0; j < cells.size(); ++j)
        {
                painter->drawRect(i * cellSize, j * cellSize, cellSize, cellSize);
        }

     QGraphicsScene::drawBackground(painter, rect);
}


void Controller::save()
{

    QFileDialog fileDialog;
    fileDialog.setFileMode(QFileDialog::AnyFile);
    int result = fileDialog.exec();
    if (result != 1) {
        return;
    }
    std::ofstream myfile;
    myfile.open (fileDialog.selectedFiles()[0].toStdString().c_str());
    for(size_t i = 0; i < cells.size(); ++i)
        for(size_t j = 0; j < cells.size(); ++j)
        {
            myfile <<  cells[i][j]->isWall;
        }
    myfile.close();

}
