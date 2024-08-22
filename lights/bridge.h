#ifndef BRIDGE_H
#define BRIDGE_H

#include<QObject>

class Bridge :public QObject
{
    Q_OBJECT
public:
    explicit Bridge(QObject * parent=nullptr);
signals:
    void radioButton1Clicked(bool checked);
    void radioButton2Clicked(bool checked);
    void radioButton3Clicked(bool checked);
    void radioButton4Clicked(bool checked);
    void radioButton5Clicked(bool checked);
    void radioButton6Clicked(bool checked);
    void degreevalue1(const int& degree1,const int& speed);
    void degreevalue2(const int& degree2,const int& speed);
    void degreevalue3(const int& degree3,const int& speed);
    void degreevalue4(const int& degree4,const int& speed);
    void degreevalue5(const int& degree5,const int& speed);
    void degreevalue6(const int& degree6,const int& speed);



};

#endif // BRIDGE_H





