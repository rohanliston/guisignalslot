#ifndef COMPONENTCONNECTOR_H
#define COMPONENTCONNECTOR_H

#include <QQuickItem>
#include <QMap>
#include <QStringList>
#include <QMetaMethod>
#include <QPainter>

class ComponentConnector : public QQuickItem
{
    Q_OBJECT
    Q_PROPERTY(QStringList customSignalNames        READ customSignalNames                          NOTIFY customSignalNamesChanged)
    Q_PROPERTY(QStringList customSlotNames          READ customSlotNames                            NOTIFY customSlotNamesChanged)
    Q_PROPERTY(QStringList customPropertyNames      READ customPropertyNames                        NOTIFY customPropertyNamesChanged)
    Q_PROPERTY(QStringList inheritedPropertyNames   READ inheritedPropertyNames                     NOTIFY inheritedPropertyNamesChanged)
    Q_PROPERTY(QString     componentName            READ componentName     WRITE  setComponentName  NOTIFY componentNameChanged)
    Q_PROPERTY(QObject*    targetObject             READ targetObject      WRITE setTargetObject    NOTIFY targetObjectChanged)

public:
    explicit ComponentConnector(QQuickItem *parent = 0);
    virtual ~ComponentConnector() {}

    void componentComplete();

    QStringList customSignalNames() const;
    QStringList customSlotNames() const;
    QStringList customPropertyNames() const;
    QStringList inheritedPropertyNames() const;
    QString componentName() const;
    QObject* targetObject() const;
    void setTargetObject(QObject *targetObject);

signals:

    void customSlotNamesChanged(QStringList value);
    void customSignalNamesChanged(QStringList value);
    void customPropertyNamesChanged(QStringList value);
    void inheritedPropertyNamesChanged(QStringList value);
    void componentNameChanged(QString value);
    void targetObjectChanged();

public slots:

    void setComponentName(QString value);

protected:
    void interrogateTarget();

private:
    QMap<QString, QMetaMethod> _customSignals;
    QMap<QString, QMetaMethod> _customSlots;
    QMap<QString, QMetaProperty> _customProperties;
    QMap<QString, QMetaProperty> _inheritedProperties;
    QString _componentName;
    QObject* _targetObject;
};

QML_DECLARE_TYPE(ComponentConnector)

#endif // COMPONENTCONNECTOR_H
