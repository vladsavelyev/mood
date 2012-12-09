#include "sizeconfigurator.h"
#include <QPushButton>
#include "QDebug"

SizeConfigurator::SizeConfigurator(QWidget *parent) :
    QWidget(parent)
{
    sizeLabelW = new QLabel("Width of field", this);

    sizeSpinBoxW = new QSpinBox(this);
    sizeSpinBoxW->setMinimum(20);
    sizeSpinBoxW->setMaximum(50);

    setLayout(new QHBoxLayout());

    layout()->addWidget(sizeLabelW);
    layout()->addWidget(sizeSpinBoxW);
    sizeLabelH = new QLabel("Height of field", this);

    sizeSpinBoxH = new QSpinBox(this);
    sizeSpinBoxH->setMinimum(20);
    sizeSpinBoxH->setMaximum(50);

    QPushButton* okButton = new QPushButton();
    okButton = new QPushButton("OK", this);
    connect(okButton, SIGNAL(clicked()), this, SLOT(saveC()));

    layout()->addWidget(sizeLabelH);
    layout()->addWidget(sizeSpinBoxH);
    layout()->addWidget(okButton);
}

void SizeConfigurator::saveC()
{
    emit save(sizeSpinBoxW->value(), sizeSpinBoxH->value());
    close();
}

SizeConfigurator::~SizeConfigurator()
{
    delete sizeLabelH;
    delete sizeSpinBoxH;
    delete sizeLabelW;
    delete sizeSpinBoxW;
}

