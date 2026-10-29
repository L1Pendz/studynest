# StudyNest

StudyNest is a Flutter study planner that helps students organize subjects, assignments, deadlines, and study resources in one place. It stores planner data locally and includes YouTube search for educational videos.


## Features

- Create and manage subjects.
- Create, edit, filter, and complete tasks with due dates and priority thresholds.
- Attach study materials to subjects, including documents and links.
- Save selected document files in the app's local storage and open them later.
- Search YouTube for educational videos and save videos as study resources.
- Reset all local data or reset subjects, tasks, or materials separately.
- Recover from saved-data loading errors with retry and reset options.

## Packages and technologies

- **Flutter / Dart** — cross-platform application framework and language.
- **drift** — typed SQLite database layer.
- **drift_flutter** — Flutter integration for Drift databases.
- **path_provider** — access to application storage directories.
- **file_picker** — select study files from the device.
- **open_filex** — open local documents.
- **url_launcher** — open links and YouTube videos.
- **http** — make YouTube Data API requests.
- **cupertino_icons** — Cupertino-style icons.
- **build_runner** and **drift_dev** — generate Drift database code (development).
- **flutter_test** and **flutter_lints** — testing and linting (development).

## Requirements

- Flutter SDK compatible with pubspec.yaml (Dart 3.10.3 or newer).
- Android Studio or another configured Android toolchain to build Android APKs.
- A deployed Cloudflare Worker that proxies YouTube search. The rest of the planner works without it.

## Setup and run

From the repository root:

~~~powershell
flutter pub get
flutter run
~~~

To enable YouTube search, deploy the Cloudflare Worker described in the API key handling section below, then provide its HTTPS URL:

~~~powershell
flutter run --dart-define=YOUTUBE_SEARCH_WORKER_URL=https://your-worker.your-subdomain.workers.dev
~~~

Build a release APK with YouTube search enabled:

~~~powershell
flutter build apk --release --dart-define=YOUTUBE_SEARCH_WORKER_URL=https://your-worker.your-subdomain.workers.dev
~~~

The APK is generated at build/app/outputs/flutter-apk/app-release.apk.

### API key handling

The Flutter app sends search requests to a Cloudflare Worker. The Worker stores the YouTube Data API key as a Cloudflare Secret and adds it when it calls YouTube, so the key is not included in the app. Set the Worker secret named `YOUTUBE_API_KEY` in the Cloudflare dashboard. The Worker must accept `GET /search?q=...` and return YouTube's JSON response. Configure CORS response headers on the Worker if using Flutter Web. The Worker URL is public, so monitor YouTube quota and add request limits before distributing the app widely.

## Team

| Member | Role |
| --- | --- |
| Recca Lee M. Pendioday ([@L1Pendz](https://github.com/L1Pendz)) | Flutter app development |

## Debugging case: reset failed when deleting stored materials

### Bug

Using the reset flow could fail when clearing saved study materials. The material files are stored in the app's study_materials directory. The original cleanup attempted to delete that directory recursively. On the Windows development machine, this sometimes failed with an access-denied error, which interrupted the reset.

### How it was found

The issue was reproduced while running the app from VS Code with flutter run -d windows. The terminal showed:

~~~text
PathAccessException: Deletion failed
path = '...\study_materials' (OS Error: Access is denied, errno = 5)
#0 Directory.delete
#1 clearStoredMaterials
#2 _confirmAndReset
~~~

The call stack located the failure in clearStoredMaterials(), called by the reset handler _confirmAndReset(). The screenshots above show the terminal output and the corresponding code change.

### Fix

Cleanup now checks whether the directory exists, then deletes its files individually instead of recursively deleting the directory. The reset handler also catches and logs cleanup errors so a file-cleanup problem does not prevent the database reset from proceeding. The materials directory itself is left in place and can be reused.

Implementation: lib/features/resources/data/material_file_storage_io.dart and lib/app.dart.

## Screenshots

The screenshots below document the saved-data reset debugging case.

**Bug found in VS Code terminal**

![Reset failure and stack trace](docs/screenshots/studynest-bug-found.png)

**Code fix**

![Material file cleanup fix](docs/screenshots/studynest-bug-fix.png)
