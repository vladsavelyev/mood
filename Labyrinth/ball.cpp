#include "ball.h"
#include <QPainter>
#include <QStyleOptionGraphicsItem>
#include <QWidget>
#include <QDebug>
#include <QGraphicsScene>
#include <QRectF>

Ball::Ball(qreal x, qreal y, qreal w, qreal h)
    :QGraphicsRectItem(x, y, w, h)
{
    isWall = false;
    pos.setX(x);
    pos.setY(y);
    setBrush(Qt::gray);
    setFlag(QGraphicsRectItem::ItemIsFocusable, true);
    setFlag(QGraphicsRectItem::ItemSendsScenePositionChanges, true);
}

void Ball::paint(QPainter *painter, const QStyleOptionGraphicsItem *option, QWidget *widget)
{
    if (isWall) {
        setBrush(Qt::gray);
    } else {
        setBrush(Qt::white);
    }
    QGraphicsRectItem::paint(painter, option, widget);
}

void Ball::mouseDoubleClickEvent(QGraphicsSceneMouseEvent *event)
{
    isWall = !isWall;
                update(this->rect());
}
