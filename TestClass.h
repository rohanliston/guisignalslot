#ifndef TESTCLASS_H
#define TESTCLASS_H

#include <QObject>
#include <QDebug>
#include <QString>
#include <QQuickItem>

class TestClass : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int testInt READ testInt WRITE setTestInt NOTIFY testIntChanged)

    int m_testInt;

public:
    explicit TestClass(QObject *parent = 0);

    int testInt() const { return m_testInt; }

signals:

    void testIntChanged(int arg);
    void customSignal();
    void customSignalWithArg(QString arg);

public slots:

    void setTestInt(int arg)
    {
        if(m_testInt != arg)
        {
            m_testInt = arg;
            emit testIntChanged(arg);
        }
    }

    void customSlot() { qDebug() << "Custom slot triggered!"; }
    void customSlotWithArgs(QString arg) { qDebug() << "Custom slot triggered with argument" << arg << "!"; }
};

QML_DECLARE_TYPE(TestClass)

#endif // TESTCLASS_H
