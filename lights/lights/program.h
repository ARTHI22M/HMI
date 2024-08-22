#ifndef PROGRAM_H
#define PROGRAM_H
#include <QObject>
#include <QSqlQueryModel>
#include <QString>
#include <QList>
class program : public QObject
{
    Q_OBJECT
public:
    explicit program(QObject *parent = nullptr);
    Q_INVOKABLE void saveData(const QString& data);
    Q_INVOKABLE QList<QString> getData();
signals:
    void programstart();



public slots:
    QStringList getdata();

private:
    QSqlQueryModel *categoryModel;
    QSqlQueryModel *itemsModel;
    QList<QString> m_dataList;
};

#endif // PROGRAM_H

