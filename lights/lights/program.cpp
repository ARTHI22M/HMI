#include "program.h"
#include <QObject>
#include <QDebug>
#include <QSqlDatabase>
#include <QSqlQuery>
#include <QQuickView>
#include <QQmlProperty>

program::program(QObject *parent)
    :QObject(parent)
{


}
QStringList program::getdata(){
    QStringList data;
    QSqlDatabase db=QSqlDatabase::addDatabase("QSQLITE");
    db.setDatabaseName("E:/qt/Examples/Qt-6.2.4/quick3d/lights/custom.db");
    db.open();
    if(!db.open()){
        qDebug() <<"Error opening database";
        return data;
    }
    QSqlQuery query;
    query.prepare("SELECT name FROM custom_variable");
    if(query.exec()){
        while(query.next()){
            QString value=query.value(0).toString();
            data.append(value);
        }
    }
    else{
        qDebug() << "Error executing query";
    }
    return data;

}


void program::saveData(const QString& data)
{
    m_dataList.append(data);
    qDebug()<<  m_dataList[0];



}

QList<QString> program::getData()
{
    // You can add code here to retrieve the data securely.
    return m_dataList;
}
