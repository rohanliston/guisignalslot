#include <QtGui/QGuiApplication>
#include "qtquick2applicationviewer.h"
#include "ComponentConnector.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QtQuick2ApplicationViewer viewer;
    qmlRegisterType<ComponentConnector>("ComponentConnector", 1, 0, "ComponentConnector");
    viewer.setMainQmlFile(QStringLiteral("qml/guisignalslot/main.qml"));
    viewer.showExpanded();

    return app.exec();
}
