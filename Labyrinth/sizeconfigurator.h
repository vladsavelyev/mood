#ifndef SIZECONFIGURATOR_H
#define SIZECONFIGURATOR_H

#include <QWidget>
#include <QLabel>
#include <QSpinBox>
#include <QHBoxLayout>

class SizeConfigurator : public QWidget
{
    Q_OBJECT
public:
    explicit SizeConfigurator(QWidget *parent = 0);
    ~SizeConfigurator();
    QLabel *sizeLabelW;
    QSpinBox *sizeSpinBoxW;
    QLabel *sizeLabelH;
    QSpinBox *sizeSpinBoxH;
signals:
    void save(int, int);
public slots:
    void saveC();
};

#endif // SIZECONFIGURATOR_H
