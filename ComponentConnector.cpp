#include "ComponentConnector.h"
#include "TestClass.h"
#include <QPainter>

ComponentConnector::ComponentConnector(QQuickItem *parent) :
    QQuickItem(parent)
{
    setFlag(QQuickItem::ItemHasContents);
}

void ComponentConnector::componentComplete()
{
    QQuickItem::componentComplete();

    setWidth(360);
    setHeight(360);

    TestClass* test = new TestClass();
    int startOfCustomMethods = test->metaObject()->methodOffset();
    int methodCount = test->metaObject()->methodCount();

    for(int i = startOfCustomMethods; i < methodCount; i++)
    {
        QMetaMethod currentMethod = test->metaObject()->method(i);

        if(currentMethod.methodType() == QMetaMethod::Slot)
        {
            qDebug() << "Found slot:" << currentMethod.name();
            _customSlots.insert(currentMethod.name(), currentMethod);
        }
        else if(currentMethod.methodType() == QMetaMethod::Signal)
        {
            qDebug() << "Found signal:" << currentMethod.name();
            _customSignals.insert(currentMethod.name(), currentMethod);
        }
    }
    delete test;

    emit customSignalNamesChanged(customSignalNames());
    emit customSlotNamesChanged(customSlotNames());
    update();
}

QStringList ComponentConnector::customSlotNames() const
{
    return _customSlots.keys();
}

QStringList ComponentConnector::customSignalNames() const
{
    return _customSignals.keys();
}

QString ComponentConnector::componentName() const
{
    if(_componentName.isNull() || _componentName.isEmpty())
        return "Unnamed Component";

    return _componentName;
}

void ComponentConnector::setComponentName(QString value)
{
    if(_componentName != value)
    {
        _componentName = value;
        emit componentNameChanged(value);
    }
}
