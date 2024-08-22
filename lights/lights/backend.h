#ifndef BACKEND_H
#define BACKEND_H

#include <QObject>
#include <QList>

struct MyData {
    QString j1;
    QString j2;
    QString j3;
    QString j4;
    QString j5;
    QString j6;

    // Add more fields as needed
};

class Backend : public QObject
{
    Q_OBJECT

public:
    Backend();
signals:
    void dataUpdated();
    QStringList animate(QStringList &anidata);
    void speedchange(const int& value);
public slots:
    void checkAndRetrieveData(const QString &itemName);
    void insertdata(const QString &pname);
    QStringList showdata();
    QStringList animationdata(const QString &program);

private:
    QList<MyData> dataList;

};

#endif // BACKEND_H
