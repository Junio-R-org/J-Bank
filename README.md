# JunioRBank

J-Bank is a mobile application designed for simplified and partially automated cash accounting when issuing/exchanging cash abroad, particularly for groups of traveling students.

This is a free [Skip](https://skip.tools) dual-platform app project.
It builds a native app for both iOS and Android.

## Status

At the moment, the UI of participant screen list is implemented.

## TODO

### Core Features
- [ ] CSV import from email attachments
- [ ] Participant detail view with transaction history
- [ ] Transaction recording (receipts/deposits)
- [ ] Currency conversion with custom exchange rates
- [ ] Photo capture for participants
- [ ] Export functionality to CSV via email

### Screens to Implement
- [x] **Window 1**: Main participant list screen
- [ ] **Window 2**: Personal card/operations screen
- [ ] **Window 3**: Additional functions menu
- [ ] **Window 4**: Add shared expense screen
- [ ] **Window 5**: Add participant screen
- [ ] **Window 6**: Settings screen

### Features by Priority
1. **High Priority**
   - [ ] Participant transaction management
   - [ ] Currency conversion system
   - [ ] CSV data import/export
   
2. **Medium Priority**
   - [ ] Shared expense distribution
   - [ ] Participant photo management
   - [ ] Search functionality
   
3. **Low Priority**
   - [ ] Participant deletion (swipe gesture)
   - [ ] Settings persistence
   - [ ] UI/UX improvements

## Building

This project is both a stand-alone Swift Package Manager module,
as well as an Xcode project that builds and transpiles the project
into a Kotlin Gradle project for Android using the Skip plugin.

Building the module requires that Skip be installed using
[Homebrew](https://brew.sh) with `brew install skiptools/skip/skip`.

This will also install the necessary transpiler prerequisites:
Kotlin, Gradle, and the Android build tools.

Installation prerequisites can be confirmed by running `skip checkup`.

## Testing

The module can be tested using the standard `swift test` command
or by running the test target for the macOS destination in Xcode,
which will run the Swift tests as well as the transpiled
Kotlin JUnit tests in the Robolectric Android simulation environment.

Parity testing can be performed with `skip test`,
which will output a table of the test results for both platforms.

## Running

Xcode and Android Studio must be downloaded and installed in order to
run the app in the iOS simulator / Android emulator.
An Android emulator must already be running, which can be launched from
Android Studio's Device Manager.

To run both the Swift and Kotlin apps simultaneously,
launch the JunioRBank target from Xcode.
A build phases runs the "Launch Android APK" script that
will deploy the transpiled app a running Android emulator or connected device.
Logging output for the iOS app can be viewed in the Xcode console, and in
Android Studio's logcat tab for the transpiled Kotlin app.

## License

This software is licensed under the [GNU General Public License v2.0 or later](https://spdx.org/licenses/GPL-2.0-or-later.html).
