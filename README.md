# 🗒️ Flutter Notebook App

A simple note taking app built with Flutter.  This application serves as a demo of clean architecture and how to use [Drift](https://pub.dev/packages/drift) and [Riverpod](https://pub.dev/packages/riverpod) to manage state and interact with a local SQLite database.  The application is intentionally short on functionality and styling to focus on the internals of the application.  The project also includes an extensive list of tests.

Loosely based on the [Todo App](https://github.com/simolus3/drift/tree/develop/examples/app) example in the Drift documentation.

## 🏗️ Architecture
Here I have split the application into 2 distinct layers, data and app.  

### Data Layer
This layer defines the database structure and provides an Object Relational Mapper (ORM) to allow access to the data, along with mapper classes to map the ORM objects to the application models.  Drift provides a lot of this for use.

### App Layer
Within this layer we have 3 further layers, following the [Model View Controller (MVC)](https://en.wikipedia.org/wiki/Model%E2%80%93view%E2%80%93controller) architecture.  

- Models provide us with objects to hold the data.

- Views includes screens and widgets used to present the data to the user.  

- The Controller contains the logic to access the data from the data layer, populate the Models and carry out any business logic.  This is where the Riverpod providers are defined to provide the data to the views.

Following an architecture like this helps make code navigation easier, either for yourself when returning to a codebase after a break, or for other developers who may be working on the project.  While the architecture you choose to use my be different to this one, hopefully this will serve as an example.

## 📦 Packages Used
The project uses the following packages:
- [Drift](https://pub.dev/packages/drift) for database management.
- [Riverpod](https://pub.dev/packages/riverpod) for state management.
- [go_router](https://pub.dev/packages/go_router) for routing.
- [Freezed](https://pub.dev/packages/freezed) for code generation of the Models

## 🖥️ Instructions
To run the app you will need to install flutter.  Follow this [Get Started](https://docs.flutter.dev/get-started/install) guide.

- Clone the repository
```bash
git clone https://github.com/zjcz/flutter_notebook.git
```
- Install the dependencies
```bash
flutter pub get
```
- Start the emulator or connect a device

- Run the application
```bash
flutter run
```

## 📱 Features
- Add, edit and delete notes
- Assign a category to a note, and manage the category (add, edit and delete)
- Filter notes list by Category, change the sort order
- Works on mobile, desktop and web (tested on Android, Linux and Chrome)
- Uses the system colors of the device, support for Light and Dark themes

## 🟢 GitHub Actions
The project contains a GitHub action to run the tests when changes are pushed.

## ✅ ToDo
As mentioned above, this is far from a complete application but was intended as a way of practicing using Riverpod and the best way to structure an application.  If I have time there are a few things I'd like to work on to make this a usable application:
- [ ] Improve the UI (tidy up front screen to present the list of notes better)
- [ ] Add search functionality

