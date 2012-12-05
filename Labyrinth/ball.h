#ifndef BALL_H
#define BALL_H

#include <QGraphicsItem>
#include <QObject>
#include <QtDeclarative/QDeclarativeItem>
#include <vector>

class Ball : public QGraphicsRectItem {
    QPointF pos;
    QPainter *painter_;
public:
    bool isWall;
    Ball(qreal x, qreal y, qreal w, qreal h);
    void paint(QPainter *painter, const QStyleOptionGraphicsItem *option, QWidget *widget = 0);
    void mouseDoubleClickEvent(QGraphicsSceneMouseEvent *event);
};

#endif // BALL_H
