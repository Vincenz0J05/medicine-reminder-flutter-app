
# Medication Reminder App

This repository contains the source code for a medication reminder application for Android, built with Flutter. iOS support is planned for future releases.

## Setup for Viewing and Testing

Follow these steps to set up the project on your local machine for viewing and testing:

### Prerequisites

- Flutter SDK (latest stable version recommended)
- Android Studio with Flutter & Dart plugins installed
- Git installed on your machine
- An Android emulator or device for testing

### Installation

1. Clone the repository to your local machine:
   ```sh
   git clone https://github.com/Vincenz0J05/medicine-reminder-flutter-app
   ```

2. Navigate to the project directory:
   ```sh
   cd your-repo-name
   ```

3. Install the dependencies:
   ```sh
   flutter pub get
   ```

4. Open an Android emulator or connect an Android device.

5. Run the app:
   ```sh
   flutter run
   ```

## Project Structure

- `lib/main.dart`: Entry point of the application.
- `lib/models`: Data models used in the app.
- `lib/services`: Services for handling backend logic and Firebase integration.
- `lib/widgets`: Reusable widgets for the app's UI.
- `lib/screens`: Screens or pages of the app.

## Testing

To run tests, execute the following command in the terminal:

```sh
flutter test
```

This command will run all the test cases defined in the project.

## Notes

This app is currently only available for Android devices. It is not yet configured for iOS but may be in future updates.

## Disclaimer

This code is provided for viewing and testing purposes only. It is not intended for production use.
