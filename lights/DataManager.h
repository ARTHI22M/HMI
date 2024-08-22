#pragma once

#include <QObject>
#include <QSqlDatabase>
#include <QByteArray>
#include <QVariantList>

class DataManager : public QObject
{
    Q_OBJECT

public:
    DataManager(QObject* parent = nullptr);

    Q_INVOKABLE void saveData(const QByteArray& serializedData);
    Q_INVOKABLE QByteArray getData();

private:
    QSqlDatabase m_database;
};
