# Workout_App
Iphone App to keep track of my 12 week workout progress 
App name + MVP scope
App name (working): Heavy Hypertrophy 12W Tracker

Included in MVP
Program templates (your split + all exercises)
Today screen (morning + evening)
Morning routine checklist + timers
Evening workout session logger (set-by-set)
Progression engine:
Major lifts: +5/week, Week 7 deload −20%, round to nearest 5
Accessories: progress next time that exercise appears if you hit prescribed work
Dumbbells: +5 per hand
Pull-ups: “added weight” progresses
Checkbox-only:
Meals 1–6
Supplements list
Water / Sleep checkmarks (or “met goal” toggles)
Nice-to-have (can be phase 2)
Charts (Charts framework)
Notifications
Data export (CSV)
Progression rules (precise)
Week calculation
weekNumber = floor(daysSinceStart / 7) + 1 clamped 1…12
dayIndex = (daysSinceStart % 7) + 1 mapping to Day 1–7 split
Rounding
Round to nearest 5 lb:
rounded = (weight / 5).rounded() * 5
Deload (Week 7)
For any computed target weight in week 7:
deloaded = roundToNearest5(normal * 0.80)
Major lifts (Bench, Back Squat, Deadlift, OHP)
Use your Week 1 weights as base:
Back Squat W1 = 260
Bench W1 = 235
Deadlift W1 = 315
OHP W1 = 155
normalTarget = week1 + (weekNumber - 1) * 5
If week 7 → deload rule above
Accessories (auto-progress “next occurrence”)
Each accessory exercise tracks its own “current working weight” based on history:

Rule:

If last time you performed that exercise you completed:
all sets and each set reps ≥ prescribed reps
then next target weight = previous target + increment
Else keep same target
Increment defaults:

Barbell/machine/cable: +5 lb
Dumbbells: +5 lb per hand (so +10 total load)
Bodyweight + added load (pull-ups, dips): +5 lb added load
Week 7 deload: apply −20% to the target weight (or added load), round to nearest 5.

Important behavior detail (what I will implement):

Accessories progress based on the most recent completed session entry for that exercise name (simple + predictable).
If you manually override a weight in-session, that becomes the new reference.
Data model (SwiftData) — final form
Templates (shipped with app)
TemplateDay
dayIndex (1–7)
title
kind: training / activeRecovery / rest
TemplateExercise
name
sets
reps
modality: barbell | dumbbell | machine | cable | bodyweightPlusLoad | timed
week1Weight (optional)
isMajorLift (Bool)
Logs (user-generated)
WorkoutSession
date
weekNumber, dayIndex
title (copied from template)
exercises: [ExerciseLog]
ExerciseLog
name
prescribedSets, prescribedReps
targetWeight (stored)
targetAddedLoad (stored, for pull-ups/dips)
performedSets: [SetLog]
SetLog
setNumber
reps
weight (for barbell/dumbbell/etc)
addedLoad (for bodyweight+load)
completed (Bool)
Daily checklists
MorningRoutineLog
date
mobilityCompleted Bool
cardioCompleted Bool
NutritionChecklistLog
date
meals1to6: [Bool] (stored as 6 bools)
supplements: creatine/whey/fishOil/magnesium/vitD3/electrolytes/citrulline/betaAlanine (bools)
waterGoalMet Bool
sleepGoalMet Bool
Preloaded training templates (from your plan)
I will encode exactly:

Day 1 – Heavy Legs (Quad Power)

Back Squat 5×5 @ 260 (major)
Romanian Deadlift 4×6 @ 225
Leg Press 4×8 @ 450
Walking Lunges 3×10 each leg @ 60 dbs
Leg Extension 3×10 @ 170
Standing Calf Raise 4×12 @ 220
Day 2 – Heavy Chest

Bench Press 5×5 @ 235 (major)
Incline DB Press 4×6 @ 85 dbs
Weighted Dips 4×6 @ +45 added load (progress added load)
Flat DB Press 3×8 @ 90 dbs
Cable Fly 3×12 @ 50
Day 3 – Back + Heavy Biceps

Deadlift 5×4 @ 315 (major)
Pull-ups 4×8 @ +25 added load (progress added load)
Barbell Row 4×6 @ 205
Lat Pulldown 3×10 @ 180
Barbell Curl 4×6 @ 115
Incline Curl 3×10 @ 40 dbs
Hammer Curl 3×10 @ 50 dbs
Day 4 – Active recovery

(no heavy session; app shows guidance + optional light log)
Day 5 – Posterior Chain + Legs

Front Squat 4×5 @ 225
Hip Thrust 4×6 @ 315
Bulgarian Split Squat 3×8 @ 70 dbs
Leg Curl 4×10 @ 140
Hack Squat 3×8 @ 270
Seated Calf Raise 4×12 @ 180
Day 6 – Shoulders + Arms

Overhead Barbell Press 5×5 @ 155 (major)
Lateral Raises 4×12 @ 30 dbs
Rear Delt Fly 4×12 @ 25 dbs
EZ Bar Curl 4×8 @ 95
Preacher Curl 3×10 @ 80
Cable Curl 3×12 @ 70
Close Grip Bench Press 4×6 @ 205
Overhead Tricep Extension 3×10 @ 90
Day 7 – Rest

(no heavy session)
Morning routine is daily regardless of day index.

UX details (what you’ll see)
Today tab
“Week 3 • Day 2 – Heavy Chest”
Morning routine: Start → timers → Complete
Evening workout: Start Session
Nutrition checklist: Meals 1–6 + supplements toggles
During workout
Each exercise card shows:
Target: sets×reps + weight (or added load)
Quick buttons: “Fill all sets with target”
Tap reps/weight to edit per set
Finish saves and updates progression state for next time.
