# study-mobile-app
Study and practice learning Flutter, Firebase, and FastAPI.

## Features
- Timetable builder (subjects by day/time)
- Event scheduling & reminders
- Focus mode / study timer
- AI Planner: predicts recommended study hours based on user inputs

## Tech Stack
- Frontend: Flutter (Dart)
- Backend: Firebase (Auth, Firestore)
- AI Service: FastAPI (Python) + ML model (e.g., Linear Regression/MLR)

## System Overview
Flutter app sends user inputs as JSON to FastAPI → model predicts study plan → results returned to the app and displayed.
Firebase stores user data (events, timetable, todos).

## Screenshots / Demo
- (Add screenshots here)
- Demo video: (link)

## How to Run

### Mobile (Flutter)
1. `flutter pub get`
2. Create Firebase project + add `google-services.json` / `GoogleService-Info.plist`
3. `flutter run`

### AI Service (FastAPI)
1. `pip install -r requirements.txt`
2. `uvicorn main:app --reload --host 0.0.0.0 --port 8000`
