# StudyNest

A mobile study planner that helps students organize their subjects, assignments, deadlines, and study tasks. It also provides a personal library for study materials and YouTube search for educational videos.

## Features

- **Subject Management** — Organize and manage academic subjects.
- **Task Management** — Track assignments, deadlines, and task completion.
- **Study Resources** — Organize personal study materials by subject.
- **YouTube Search** — Find educational videos related to study topics.

## Technologies

- Flutter
- Dart
- YouTube Data API v3

## YouTube API setup

Enable the YouTube Data API v3 in your Google Cloud project and create an API
key restricted to the YouTube Data API. Pass the key at build or run time; do
not add it to source files or commit it to the repository.

```powershell
flutter run --dart-define=YOUTUBE_API_KEY=your_api_key
```

For a release build, pass the same define to `flutter build`.

## Member

- Recca Lee M. Pendioday — [@L1Pendz](https://github.com/L1Pendz)
