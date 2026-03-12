# HypertrophyTracker (iOS)

Offline-only iOS 17+ workout tracker for a 12-week heavy hypertrophy program.

## Tech
- SwiftUI
- SwiftData (iOS 17+)

## Features (MVP)
- Program start date → app computes current week (1–12) and day (1–7)
- Daily morning mobility + cardio checklist
- Evening workout templates (Day 1–7 split)
- Set-by-set workout logging
- Auto progression:
  - Major lifts (Back Squat, Bench Press, Deadlift, OHP): +5 lb/week from Week 1 base
  - Week 7 deload: -20% and rounded to nearest 5 lb
  - Accessories: if last performance hit all sets/reps, increase next time
    - Barbell/machine/cable: +5 lb
    - Dumbbells: +5 lb per hand
    - Bodyweight + added load (pull-ups/dips): +5 lb added load
- Daily checkbox-only nutrition + recovery tracking (meals, supplements, water/sleep goal met)

## Run
1. Open `HypertrophyTracker.xcodeproj` in Xcode (iOS 17+)
2. Select an iPhone simulator
3. Run

## First use
Go to **Settings** and set your **Program Start Date**.
The app seeds templates automatically on first launch.

## Notes
- All data is stored on-device via SwiftData.
- No account, no network.
