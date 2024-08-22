#include "custom.h"
#include <QObject>
#include <QDebug>
#include <QSqlDatabase>
#include <QSqlQuery>
#include <QSqlError>
#include <QQuickView>

custom::custom(QObject *parent): QObject{parent}

{

}
void custom::store(const QString& name, const QString& joint1,const QString& joint2,const QString& joint3,const QString& joint4,const QString& joint5,const QString& joint6)
{
    QSqlDatabase db = QSqlDatabase::addDatabase("QSQLITE");
    db.setDatabaseName("E:/qt/Examples/Qt-6.2.4/quick3d/lights/custom.db");
    db.open();
    if(db.open()){
        qDebug()<<"Connected";
    }
    else{
        qDebug() <<"notConnected";
    }
    // Execute a SQL query to verify the login credentials
    qDebug()<<name;
    //qDebug()<<password;
    QSqlQuery insertQuery;
    insertQuery.prepare("INSERT INTO custom_variable(name,J1,J2,J3,J4,J5,J6) VALUES (?,?,?,?,?,?,?)");
    insertQuery.addBindValue(name);
    insertQuery.addBindValue(joint1);
    insertQuery.addBindValue(joint2);
    insertQuery.addBindValue(joint3);
    insertQuery.addBindValue(joint4);
    insertQuery.addBindValue(joint5);
    insertQuery.addBindValue(joint6);
    if (!insertQuery.exec()) {
        qDebug() << "Failed to execute insert query:" << insertQuery.lastError().text();
        db.close();
        return;
    }
    else{
        qDebug() << "Inserted successful";
        emit dataAdded();
    }
db.close();
}
