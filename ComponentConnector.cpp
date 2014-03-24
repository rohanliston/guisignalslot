#include "ComponentConnector.h"
#include "TestClass.h"
#include <QPainter>

ComponentConnector::ComponentConnector(QQuickItem *parent) :
    QQuickItem(parent),
    _targetObject(0)
{
    setFlag(QQuickItem::ItemHasContents);
}

void ComponentConnector::componentComplete()
{
    QQuickItem::componentComplete();

    setWidth(360);
    setHeight(360);

    interrogateTarget();
}

QStringList ComponentConnector::customSlotNames() const
{
    return _customSlots.keys();
}

QStringList ComponentConnector::customPropertyNames() const
{
    return _customProperties.keys();
}

QStringList ComponentConnector::inheritedPropertyNames() const
{
    return _inheritedProperties.keys();
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

QObject *ComponentConnector::targetObject() const
{
    return _targetObject;
}

void ComponentConnector::setTargetObject(QObject *targetObject)
{
    if (_targetObject != targetObject) {
        _targetObject = targetObject;
        interrogateTarget();
        emit targetObjectChanged();
    }
}

void ComponentConnector::setComponentName(QString value)
{
    if(_componentName != value)
    {
        _componentName = value;
        emit componentNameChanged(value);
    }
}

/*!
 * \brief ComponentConnector::interrogateTarget
 *
 *  Finds all signals, slots and properties of the target class for inspection and adds them
 *  to the local properties of the ComponentConnector so they can be displayed in QML.
 *
 */
void ComponentConnector::interrogateTarget()
{
    //Clear old data (in case we had a previous target object)
    _customSignals.clear();
    _customSlots.clear();
    _customProperties.clear();
    _inheritedProperties.clear();

    //Interrogate signals and slots
    int startOfCustomMethods = _targetObject->metaObject()->methodOffset();
    int methodCount = _targetObject->metaObject()->methodCount();

    for(int i = startOfCustomMethods; i < methodCount; i++)
    {
        QMetaMethod currentMethod = _targetObject->metaObject()->method(i);

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

    //Interrogate custom and inherited properties
    int startOfCustomProperties = _targetObject->metaObject()->propertyOffset();
    int propertyCount = _targetObject->metaObject()->propertyCount();

    for (int i = startOfCustomProperties; i < propertyCount; ++i)
    {
        QMetaProperty currentProperty = _targetObject->metaObject()->property(i);
        qDebug() << "Found custom property: " << currentProperty.name();
        _customProperties.insert(currentProperty.name(), currentProperty);
    }

    for (int i = 0; i < startOfCustomProperties; ++i)
    {
        QMetaProperty currentProperty = _targetObject->metaObject()->property(i);
        qDebug() << "Found inherited property: " << currentProperty.name();
        _inheritedProperties.insert(currentProperty.name(), currentProperty);
    }

    emit customSignalNamesChanged(customSignalNames());
    emit customSlotNamesChanged(customSlotNames());
    emit customPropertyNamesChanged(customPropertyNames());
    emit inheritedPropertyNamesChanged(customPropertyNames());
    update();
}
