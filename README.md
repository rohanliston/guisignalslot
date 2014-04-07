# guisignalslot

A Qt/QML-based node editor that inspects QObject-based C++ classes and represents them graphically in a familiar node-connector UI. Once complete, this will provide a code-free way of connecting disparate Qt components together locally or over a network. 

Currently very early in development. Tested only on Linux, but should work fine on OSX/Windows.

![Screenshot](http://www.rohanliston.com/images/images/github/guisignalslot.png)

## Dependencies

* [Qt 5.2](http://qt-project.org/downloads)

## Build instructions

### Qt Creator

* Open `guisignalslot.pro` in Qt Creator.
* Right-click the project (denoted by bold text) in the projects pane and select 'run qmake'.
* Right-click the project again, and select 'build guisignalslot'.
* Right-click the project again, and select 'Run' (or hit Ctrl+R).

### Command line

* Navigate to the root directory of this project.
* Run `qmake`.
* Run `make`.
* Run `./guisignalslot`.
