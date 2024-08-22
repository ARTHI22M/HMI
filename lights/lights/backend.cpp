#include "backend.h"
#include <QDebug>
#include <QtSql>
#include <QByteArray>

Backend::Backend()
{
    // Initialize your database connection here
    QSqlDatabase db = QSqlDatabase::addDatabase("QSQLITE");
    db.setDatabaseName("E:/qt/Examples/Qt-6.2.4/quick3d/lights/custom.db");

    if (!db.open()) {
        qDebug() << "Database connection failed!";
    }
}
QString resultList1;
QString resultList2;
QString resultList3;
QString resultList4;
QString resultList5;
QString resultList6;
QStringList result;
void Backend::checkAndRetrieveData(const QString &itemName)
{
    dataList.clear(); // Clear the previous data if needed

    QSqlQuery query;
    query.prepare("SELECT * FROM custom_variable WHERE name = :itemName");
    query.bindValue(":itemName", itemName);
    //QByteArray byteArray;
    // QDataStream stream(&byteArray, QIODevice::WriteOnly);
    if (query.exec()) {
        while (query.next()) {
            MyData data;
            data.j1 = query.value(1).toString();
            data.j2 = query.value(2).toString();
            data.j3 = query.value(3).toString();
            data.j4 = query.value(4).toString();
            data.j5 = query.value(5).toString();
            data.j6 = query.value(6).toString();


            dataList.append(data);


        }
    }

    else {
        qDebug() << " Query execution failed: " << query.lastError().text();
    }





    for (const MyData &item : dataList) {
        resultList1+=item.j1+",";
        resultList2+=item.j2+",";
        resultList3+=item.j3+",";
        resultList4+=item.j4+",";
        resultList5+=item.j5+",";
        resultList6+=item.j6+",";




    }


}

void Backend::insertdata(const QString &pname)

{   qDebug() << resultList1;
    qDebug() << resultList2;
    qDebug() << resultList3;
    qDebug() << resultList4;
    qDebug() << resultList5;
    qDebug() << resultList6;

    QSqlQuery insertQuery;
    insertQuery.prepare("INSERT INTO program (pname,J1,J2,J3,J4,J5,J6) VALUES (:pname,:J1,:J2,:J3,:J4,:J5,:J6)");

    insertQuery.bindValue(":pname",pname);
    insertQuery.bindValue(":J1",resultList1);
    insertQuery.bindValue(":J2",resultList2);
    insertQuery.bindValue(":J3",resultList3);
    insertQuery.bindValue(":J4",resultList4);
    insertQuery.bindValue(":J5",resultList5);
    insertQuery.bindValue(":J6",resultList6);
    if (insertQuery.exec()) {
        qDebug() << "List inserted successfully.";
        emit dataUpdated();



    } else {
        qDebug() << "Insertion failed: " << insertQuery.lastError().text();
    }

}

QStringList Backend::showdata()
{
    QSqlQuery retQuery;

    retQuery.prepare("SELECT (pname) FROM program  ");
    if (retQuery.exec()) {
        while (retQuery.next()) {
            result.append(retQuery.value(0).toString());
        }
    } else {
        qDebug() << " Show Query failed: " << retQuery.lastError().text();
    }
    return result;

}

QStringList Backend::animationdata(const QString &program)
{
    QSqlQuery aniQuery;
    QStringList anidata;
    aniQuery.prepare("SELECT * FROM program WHERE pname = :itemname  ");
    aniQuery.bindValue(":itemname",program);
    if (aniQuery.exec()) {
        while (aniQuery.next()) {
            anidata.append(aniQuery.value(1).toString());
            anidata.append(aniQuery.value(2).toString());
            anidata.append(aniQuery.value(3).toString());
            anidata.append(aniQuery.value(4).toString());
            anidata.append(aniQuery.value(5).toString());
            anidata.append(aniQuery.value(6).toString());
        }
    } else {
        qDebug() << "Animation Query failed: " << aniQuery.lastError().text();
    }
    //qDebug() << anidata;
    emit animate(anidata);
    return anidata;
}




