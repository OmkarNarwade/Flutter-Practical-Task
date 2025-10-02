# Practical Task - Dynamic Posts App

## Overview
This Flutter application fetches posts from a public API and displays them in a dynamic list. Each post has a timer that starts when visible and pauses when scrolled away or clicked. Users can mark posts as read, and read posts are persisted using Hive.

## Features
- Fetch posts from `https://jsonplaceholder.typicode.com/posts`.
- Display post titles in a scrollable list with initial **light yellow** background.
- Timer for each post with random durations (10s, 20s, 25s) that pauses when posts are off-screen or clicked.
- Post detail screen with minimal, modern UI showing the post body.
- Mark posts as read, changing background color to white.
- Local storage using **Hive** to persist posts and read status.
- Pull-to-refresh for real-time updates from API.

## Architecture
- **State Management:** StatefulWidgets with `setState`.
- **Data Persistence:** Hive to cache posts and read status.
- **Networking:** `http` package for REST API calls.
- **Visibility Detection:** `visibility_detector` for managing timers based on visibility.
- **UI:** Minimal design using Flutter widgets, gradients, and smooth animations.

## Dependencies
- `google_fonts` – custom fonts
- `hive` & `hive_flutter` – local storage
- `http` – REST API calls
- `visibility_detector` – detect widget visibility
- `intl` – date/time formatting
- `shimmer` – loading placeholders

## Project Structure
```
practical_task/
│
├─ android/
├─ ios/
├─ lib/
│   ├─ main.dart
│   ├─ screens/
│   │   ├─ post_list_screen.dart
│   │   └─ post_detail_screen.dart
│
├─ pubspec.yaml
├─ README.md
├─ .gitignore
└─ assets/


## How to Run
1. Clone the repository:
```bash
git clone https://github.com/OmkarNarwade/Flutter-Practical-Task.git
cd Flutter-Practical-Task

2.Install dependencies:
```bash
flutter pub get

3.Run the app:
```bash
flutter run

### Notes

Ensure Android SDK and Flutter are properly installed.

The app uses Hive, so first launch may require initializing the Hive box.

Timers automatically pause/resume based on post visibility for better UX and performance.
