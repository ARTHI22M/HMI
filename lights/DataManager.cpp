#include "DataManager.h"
#include <QSqlQuery>
#include <QSqlError>
#include <QDir>
#include <QDebug>
#include <QByteArray>

DataManager::DataManager(QObject* parent) : QObject(parent)
{
    m_database = QSqlDatabase::addDatabase("QSQLITE");
    QString dbPath = QDir::homePath() + "E:/qt/Examples/Qt-6.2.4/quick3d/lights/custom.db"; // Change the path
    m_database.setDatabaseName(dbPath);

    if (!m_database.open()) {
        qDebug() << "Database connection error:" << m_database.lastError().text();
        return;
    }

    QSqlQuery query;
    query.exec("CREATE TABLE IF NOT EXISTS data (id INTEGER PRIMARY KEY AUTOINCREMENT, serializedData BLOB)");

    if (!query.exec()) {
        qDebug() << "Creation error:" << query.lastError().text();
    }

    qDebug() << "Database connection successful!";
}
void DataManager::saveData(const QByteArray& serializedData)
{
    QSqlQuery insertquery;
    insertquery.prepare("INSERT INTO data (serializedData) VALUES (:data)");
    insertquery.bindValue(":data", serializedData);

    if (!insertquery.exec()) {
        qDebug() << "Insertion error:" << insertquery.lastError().text();
    }
}

QByteArray DataManager::getData()
{
    QByteArray result;

    QSqlQuery query("SELECT serializedData FROM data");
    while (query.next()) {
        QByteArray data = query.value(0).toByteArray();
        result += data;
    }

    return result;
}
