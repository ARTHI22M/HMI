#ifndef CUSTOM_H
#define CUSTOM_H

#include <QObject>
class custom : public QObject
{
    Q_OBJECT
public:
    explicit custom(QObject *parent = nullptr);
signals:
    void dataAdded();
public slots:
    void store(const QString& name, const QString& joint1,const QString& joint2,const QString& joint3,const QString& joint4,const QString& joint5,const QString& joint6);



};


#endif // CUSTOM_H

