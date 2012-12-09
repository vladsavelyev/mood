#include "controller.h"
#include <QPainter>
#include <QString>

#include <QGraphicsRectItem>


Controller::Controller(int w, int h) :
    QGraphicsScene()
{
    init(w, h);
}

void Controller::init(int w, int h)
{
    width = w; height = h;
    cells.clear();
     cells.resize(w);
     for(size_t i = 0; i < width; ++i)
     {
         cells[i].resize(height);
     }
     for(size_t i = 0; i < width; ++i)
         for(size_t j = 0; j < height; ++j)
         {
             Ball* ell = new Ball(i * cellSize + 1, j * cellSize + 1, cellSize - 2, cellSize - 2);
             addItem(ell);
             cells[i][j] = ell;
         }
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
    myfile << "<?xml version=\"1.0\" encoding=\"UTF-8\"?>" << std::endl;
    myfile << "<field width=\"" << width << "\" height=\"" << height << "\">" << std::endl;
    myfile << "<cells>";
    for(size_t j = 0; j < height; ++j)
        for(size_t i = 0; i < width; ++i)
        {
            myfile <<  cells[i][j]->isWall;
        }
    myfile << "</cells>" << std::endl;
    myfile << "</field>";
    myfile.close();

}

void Controller::changeSize(int width_, int height_)
{
    for(size_t i = 0; i < width; ++i)
        for(size_t j = 0; j < height; ++j)
        {
            if (cells[i][j])
            {
                removeItem(cells[i][j]);
            }
        }
    init(width_, height_);
}

void Controller::clear()
{
    changeSize(width, height);
}
