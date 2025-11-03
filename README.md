# Flutter Climate App Workshop

Welcome to the **Flutter Climate App Workshop**, which is designed to guide you through enterprise Flutter development with hands-on learning and practical exercises. By the end of this workshop, you'll understand core Flutter patterns and be ready to (learn more about) build(ing) production-ready applications.

---

## **Table of Contents**

1. [Workshop Overview](#workshop-overview)
2. [Prerequisites](#prerequisites)
3. [Part 1: Overview](#part-1-Overview)
    - [Flutter Overview](#1-flutter-overview-5-min)
    - [Project Architecture Walkthrough](#2-project-architecture-walkthrough-10-min)
4. [Part 2: Workshop Exercises](#part-2-workshop-exercises)
    - [Exercise 1: Implement Location Selection Logic](#exercise-1-implement-location-selection-logic-15-min)
    - [Exercise 2: Implement Error State Handling](#exercise-2-implement-error-state-handling-15-min)
    - [Exercise 3: Implement Conditional UI Rendering](#exercise-3-implement-conditional-ui-rendering-15-min)
    - [Exercise 4: Add Location Input Validation (Optional)](#exercise-4-add-location-input-validation-optional-extension)
    - [Exercise 5: Implement Chart Data Scaling (Optional)](#exercise-5-implement-chart-data-scaling-optional-extension)
5. [Part 3: Wrap-Up](#part-3-wrap-up)
6. [Why Learn Flutter?](#why-learn-flutter)
7. [Learning Resources](#learning-resources)
8. [Quick Reference](#quick-reference)

---

## **Workshop Overview**

This workshop is structured as:

- **Presentation**: TODO minutes
- **Hands-on Exercises**: TODO minutes (3 core exercises + 2 optional extensions)

### What You'll Build

You'll work with a Climate Data visualization app that demonstrates Flutter patterns:

- **MVVM Architecture** with reactive state management
- **Functional error handling** using the 'Either' monad
- **API integration** with weather data
- **Interactive charts** and map visualization

### Learning Approach

Rather than building from scratch, you'll complete targeted features in an existing codebase. This mirrors real-world enterprise development where you'll often extend and maintain existing applications.

---

## **Prerequisites**

Before starting the workshop, ensure you have:

✅ **Docker installed** (run `docker version` to verify)  
✅ **Flutter SDK installed** (run `flutter doctor` to verify)  
✅ **IDE configured** (VS Code with Flutter extension OR IntelliJ with Flutter Extension)  
✅ **Project dependencies installed** (run `flutter pub get` in project directory 'task')  
✅ **App successfully runs** (test with `flutter run`)

> **Note:** If you encounter setup issues, refer to the [Official Flutter Installation Guide](https://docs.flutter.dev/get-started/install), or ask the referents of this workshop.

---

## **Part 1: Overview

### 1. What is Flutter?

Flutter is Google's open-source UI toolkit for building natively compiled applications for mobile, web, and desktop from a single codebase.

**Key Advantages:**

- **Cross-platform**: Write once, deploy to iOS, Android, Web, Windows, macOS, Linux
- **Beautiful UI**: Rich widget library with Material and Cupertino designs
- **Hot Reload**: See changes instantly (exceptions apply) without losing app state
- 💼 **Enterprise-Ready**: Used by Alibaba, BMW, Google Pay, eBay

**Why Dart?**

- Optimized for UI development with async/await support
- Ahead-of-time (AOT) compilation for production performance
- Just-in-time (JIT) compilation for fast development cycles

> **Learn More:** [What is Flutter?](https://docs.flutter.dev/resources/architectural-overview)

---

### 2. Project Architecture

#### Directory Structure

Our Climate App follows **Clean Architecture** principles:

```
lib/
├── config/           # Dependency injection setup (watch_it)
├── core/            # Shared theme and styling
├── data/            # External concerns (API clients, repositories)
│   ├── repositories/
│   └── services/api/
├── domain/          # Business entities (Location model)
│   └── models/
├── ui/              # Presentation layer
│   └── climate/
│       ├── view_model/     # Business logic (ClimateViewModel)
│       └── widgets/        # UI components (Screens, Diagrams)
├── routing/         # Navigation configuration
└── web
    ├── favicon.png
    ├── icons/
    ├── index.html
    └── manifest.json

```

> **Learn More:** [Flutter App Architecture](https://docs.flutter.dev/app-architecture)

#### Key Architectural Patterns

**1. MVVM (Model-View-ViewModel)**

```
ClimateScreen (View)  →  watches  →  ClimateViewModel  →  uses  →  ClimateRepository
                                            ↓
                                    notifyListeners()
                                            ↓
                                       UI rebuilds
```

**Benefits:**

- Separation of concerns: UI doesn't know about API details
- Testable business logic without UI dependencies
- Reusable ViewModels across different screens

**2. Reactive State Management (watch_it)**

```dart
final selectedLocation = watchPropertyValue(
  (ClimateViewModel vm) => vm.selectedLocation,
);
```

When the ViewModel calls `notifyListeners()`, only widgets watching that specific property rebuild - not the entire screen.

> **Learn More:** [State Management Approaches](https://docs.flutter.dev/data-and-backend/state-mgmt/options)

**3. Functional Error Handling (Either Monad)**

```dart
Either<String, WeatherApiModel>  // Left = error, Right = success
```

This pattern makes errors explicit and type-safe - no hidden exceptions for expected failures.

> **Learn More:** [Error Handling Best Practices](https://dart.dev/effective-dart/usage#do-use-rethrow-to-rethrow-a-caught-exception)

**4. Dependency Injection (Service Locator)**

```dart
// Registration (dependencies.dart)
sl.registerLazySingleton<ClimateViewModel>(
  () => ClimateViewModel(climateRepository: sl()),
);

// Usage
sl<ClimateViewModel>().selectLocation('Berlin');
```

Benefits: Loose coupling, easier testing, centralized configuration.

---

## **Part 2: Workshop Exercises

### Exercise Overview

Each exercise teaches a core Flutter pattern by implementing a missing feature:

| Exercise                  | Time     | Difficulty | Concepts                                         |
| ------------------------- | -------- | ---------- | ------------------------------------------------ |
| **1. Location Selection** | TODO min | **         | State updates, side effects, Map data structures |
| **2. Error Handling**     | TODO min | ***        | Either monad, pattern matching, error states     |
| **3. Conditional UI**     | TODO min | ***        | Ternary operators, null safety, loading states   |
| **4. Input Validation**   | TODO min | **         | Form validation, user feedback, SnackBars        |
| **5. Data Scaling**       | TODO min | ****       | List operations, mathematical transformations    |

> **Tip:** Complete exercises in order. Each builds on concepts from the previous one.

---

## Exercise 1: Implement Location Selection Logic

**File:** `lib/ui/climate/view_model/climate_view_model.dart`

### Learning Objectives

- ✅ Trigger state changes from user actions
- ✅ Understand the notifyListeners() pattern
- ✅ Work with Map data structures
- ✅ Chain side effects (fetch data after selection)

### Context

Users can select locations from the drawer menu. When a location is tapped, the app should:

1. Update which location is currently selected
2. Fetch climate data for that location from the API
3. Notify all watching widgets to rebuild with new data

**The Reactive Flow:**

```
User taps "Berlin" → selectLocation("Berlin") → 
_selectedLocation = "Berlin" → fetchClimateData() → 
notifyListeners() → ClimateScreen rebuilds → Shows Berlin weather
```

### Your Task

Implement the `selectLocation` method that's currently a comment at **line 48**.

### Requirements

1. ✅ Check if the location exists in the `_locations` Map
2. ✅ If valid:
    - Update `_selectedLocation` to the new location name
    - Call `fetchClimateData()` to load data
    - Call `notifyListeners()` to trigger UI rebuild

### Starting Code

```dart
void selectLocation(String name) {
  // TODO: Exercise 1
  // 1. Check if location exists: _locations.containsKey(name)
  // 2. Update _selectedLocation = name
  // 3. Call fetchClimateData()
  // 4. Call notifyListeners()
}
```

### Success Criteria

✅ Clicking different locations in the drawer updates the climate chart  
✅ The location name in the AppBar changes  
✅ The map marker moves to the new coordinates  
✅ A loading spinner briefly appears while fetching data

### Hints 💡

- **Map Operations:** Use `_locations.containsKey(name)` to safely check existence  
- **State Updates:** `notifyListeners()` is the "magic" that triggers rebuilds  
- **Side Effects:** `fetchClimateData()` is already implemented - just call it  
- **Defensive Programming:** Always validate before mutating state

> **Learn More:** [Managing State in Flutter](https://docs.flutter.dev/data-and-backend/state-mgmt/simple)

### 💡 Solution

```dart
void selectLocation(String name) {
  if (_locations.containsKey(name)) {
    _selectedLocation = name;
    fetchClimateData();
    notifyListeners();
  }
}
```

**Why this works:**

- `containsKey()` prevents crashes from invalid location names
- Setting `_selectedLocation` updates the state
- `fetchClimateData()` is async but we don't await (fire-and-forget pattern)
- `notifyListeners()` broadcasts the state change to all listeners


---

## Exercise 2: Implement Error State Handling

**File:** `lib/ui/climate/view_model/climate_view_model.dart`

### Learning Objectives

- ✅ Understand the Either monad for error handling
- ✅ Use pattern matching with `match()`
- ✅ Manage multiple state variables consistently
- ✅ Implement enterprise-grade error handling

### Context

API calls can fail for many reasons:

- Network connectivity issues
- Invalid coordinates
- Server errors (500, 503)
- Rate limiting

Instead of throwing exceptions, our app uses the **Either** type from functional programming:

```dart
Either<String, WeatherApiModel>
   ↓             ↓
  Left         Right
 (Error)     (Success)
```

The `match()` method safely handles both cases without try-catch blocks.

### Your Task

Complete the error handling in the `fetchClimateData()` method at **lines 63-72**.

### Requirements

**When the API call fails** (Left side of Either):

1. Set `_errorMessage` to the error string
2. Set `_climateData` to `null` (clear stale data)

**When the API call succeeds** (Right side of Either):

1. Set `_climateData` to the received weather data
2. Set `_errorMessage` to `null` (clear previous errors)

> **Important:** Always set **both** state variables to maintain consistency.

### Starting Code

```dart
result.match(
  (error) {
    // TODO: Exercise 2a - Handle error case
    // Set _errorMessage = error
    // Set _climateData = null
  },
  (data) {
    // TODO: Exercise 2b - Handle success case
    // Set _climateData = data
    // Set _errorMessage = null
  },
);
```

### Success Criteria

✅ Invalid coordinates display an error message in the UI  
✅ Valid coordinates show the climate chart  
✅ Network errors show meaningful messages  
✅ Error messages disappear when new successful data loads  
✅ Old chart data clears when an error occurs

### Testing Your Implementation

**Test Case 1: Simulate API Error**

Temporarily modify `lib/data/services/api/api_client.dart` at line 33:

```dart
// Replace this line:
return Either.right(weatherData);

// With this:
return Either.left('Test error: API unavailable');
```

Select any location - you should see your error message.

**Test Case 2: Invalid Coordinates**

Add a location with invalid coordinates (e.g., latitude = 200).

### Hints 💡

- **Pattern Matching:** The `match()` function takes two callbacks: `(leftValue)` and `(rightValue)`
- **State Consistency:** Never have both `_errorMessage` and `_climateData` set simultaneously  
  - **Already Implemented:** `notifyListeners()` is called after `match()` completes  
  - **Functional Style:** No exceptions, no null checks - exhaustive pattern matching

> **Learn More:**
>
> - [Handling Errors in Flutter](https://docs.flutter.dev/testing/errors)
> - [Either Type Pattern](https://pub.dev/packages/fpdart)

### 💡 Solution

```dart
result.match(
  (error) {
    _errorMessage = error;
    _climateData = null;
  },
  (data) {
    _climateData = data;
    _errorMessage = null;
  },
);
```

**Why this pattern works:**

- **Type Safety:** Compiler ensures both cases are handled
- **Explicit Errors:** No hidden exceptions - all errors are values
- **Maintainability:** Adding new error types doesn't break existing code
- **Testability:** Easy to mock Either<Error, Success> in unit tests

**Enterprise Benefit:** This pattern scales to complex apps where multiple error types (validation, network, business logic) need different handling strategies.


---

## Exercise 3: Implement Conditional UI Rendering

**File:** `lib/ui/climate/widgets/climate_screen.dart`

### Learning Objectives

- ✅ Use ternary operators to conditionally render widgets
- ✅ Handle loading, error, success, and empty states
- ✅ Understand Flutter's declarative UI paradigm
- ✅ Implement proper state priority ordering

### Context

The app body needs to display different widgets based on four possible states:

| State       | When                   | What to Show                    |
| ----------- | ---------------------- | ------------------------------- |
| **Loading** | `isLoading == true`    | Circular progress indicator     |
| **Error**   | `errorMessage != null` | Error text                      |
| **Success** | `climateData != null`  | Climate chart with data         |
| **Empty**   | None of above          | 'Select a location' placeholder |
|             |                        |                                 |

**The Declarative Approach:**

In Flutter, UI = f(state). We describe what to show for each state, and Flutter handles the updates:

```dart
// NOT imperative: "If loading, show spinner, else hide it"
// YES declarative: "When loading, the child IS a spinner"
child: isLoading ? Spinner() : Chart()
```

### Your Task

Implement the conditional rendering logic in `_ClimateBody.build()` starting at **line 185**.

### Requirements

Build the widget tree using **nested ternary operators** in this priority order:

1. **First check:** `isLoading` → show loading spinner
2. **Then check:** `errorMessage != null` → show error text
3. **Then check:** `climateData != null` → show chart
4. **Otherwise:** show placeholder message

> **Critical:** Order matters! Loading state has highest priority.

### Starting Code

```dart
child: Center(
  child: // TODO: Exercise 3
  // Use nested ternary operators:
  // isLoading ? LoadingWidget : (errorMessage != null ? ErrorWidget : ...)
  
  // Widget templates:
  // Loading: const CircularProgressIndicator(color: Colors.white)
  // Error: Text(errorMessage, style: const TextStyle(color: Colors.white))
  // Success: const ClimateDiagram()
  // Empty: const Text('Select a location to view climate data', 
  //                    style: TextStyle(color: Colors.white70))
),
```

### Success Criteria

✅ Loading spinner appears immediately when selecting a new location  
✅ Error messages display in white text against the dark blue background  
✅ Climate chart renders when data loads successfully  
✅ Placeholder message shows on first app launch  
✅ States transition smoothly (Loading → Success or Loading → Error)

### Testing State Transitions

**Scenario 1: Normal Flow**

1. Launch app → See placeholder
2. Select location → See spinner (brief)
3. Data loads → See chart

**Scenario 2: Error Flow**

1. Add invalid location → See spinner (brief)
2. API fails → See error message
3. Select valid location → See spinner → See chart (error cleared)

### Hints 💡

- **Ternary Syntax:** `condition ? trueWidget : falseWidget`  
  - **Nesting Ternaries:** Chain them with proper indentation for readability  
  - **Const Constructors:** Use `const` where possible for performance (compile-time optimization)  
  - **State Priority:** Check most important state first (loading blocks everything else)

> **Learn More:**
>
> - [Building Layouts in Flutter](https://docs.flutter.dev/ui/layout)
> - [Conditional Rendering Patterns](https://docs.flutter.dev/cookbook/design/drawer)

### 💡 Solution

```dart
child: Center(
  child: isLoading
      ? const CircularProgressIndicator(color: Colors.white)
      : errorMessage != null
      ? Text(
          errorMessage,
          style: const TextStyle(color: Colors.white),
        )
      : climateData != null
      ? const ClimateDiagram()
      : const Text(
          'Select a location to view climate data',
          style: TextStyle(color: Colors.white70),
        ),
),
```

**Why this structure works:**

**Priority Ordering:**

- Loading trumps everything (users should know something is happening)
- Errors take precedence over stale data
- Success only shows when no loading or errors
- Empty state is the final fallback

**Performance Considerations:**

- `const` constructors are created at compile-time (zero runtime cost)
- `Center` widget doesn't rebuild - only its child changes
- Conditional rendering prevents unnecessary widget creation

**Readability Tip:** Some developers prefer extracting this to a separate method:

```dart
Widget _buildContent() {
  if (isLoading) return const CircularProgressIndicator(...);
  if (errorMessage != null) return Text(errorMessage, ...);
  if (climateData != null) return const ClimateDiagram();
  return const Text('Select a location...', ...);
}
```

Both approaches are valid - ternaries are more concise, if-statements are more explicit.

---

## Exercise 4: Add Location Input Validation (Optional)

**File:** `lib/ui/climate/widgets/climate_screen.dart`

### Learning Objectives

- ✅ Implement form input validation
- ✅ Provide user feedback with SnackBars
- ✅ Prevent invalid data from entering the system
- ✅ Handle edge cases gracefully

### Context

Currently, the "Add Location" dialog accepts any coordinate values. This causes problems:

- Latitude = 200 → API returns error
- Longitude = -500 → Invalid request
- Empty name → Silent failure

**Geographic Coordinate Constraints:**

- **Latitude:** -90° (South Pole) to +90° (North Pole)
- **Longitude:** -180° (West) to +180° (East)

### Your Task

Add validation to `_showAddLocationDialog` before calling `addLocation()` at **lines starting at 73**.

### Requirements

1. Validate name is not empty (already implemented)
2. Validate latitude: `-90 ≤ lat ≤ 90`
3. Validate longitude: `-180 ≤ lon ≤ 180`
4. Show SnackBar with error message if validation fails
5. Only add location and close dialog if all validations pass

### Starting Code

```dart
if (name.isNotEmpty && lat != null && lon != null) {
  // TODO: Exercise 4 - Add coordinate validation
  // Check: lat >= -90 && lat <= 90 && lon >= -180 && lon <= 180
  // If valid: call addLocation and close dialog
  // If invalid: show SnackBar with error message
  
  sl<ClimateViewModel>().addLocation(name, lat, lon);
  Navigator.pop(context);
}
```

### SnackBar Template

```dart
ScaffoldMessenger.of(context).showSnackBar(
  const SnackBar(
    content: Text('Invalid coordinates. Latitude: -90 to 90, Longitude: -180 to 180'),
    backgroundColor: Colors.red,
    duration: Duration(seconds: 3),
  ),
);
```

### Success Criteria

✅ Valid coordinates (e.g., Paris: 48.8566, 2.3522) are accepted  
✅ Invalid latitude (e.g., 100) shows error, dialog stays open  
✅ Invalid longitude (e.g., -200) shows error, dialog stays open  
✅ Error message is clear and actionable  
✅ Dialog only closes after successful validation

### Test Cases

| Location   | Latitude | Longitude | Expected Result                 |
| ---------- | -------- | --------- | ------------------------------- |
| Tokyo      | 35.6762  | 139.6503  | ✅ Success                       |
| Invalid 1  | 100      | 50        | ❌ Error: Latitude out of range  |
| Invalid 2  | 45       | -200      | ❌ Error: Longitude out of range |
| North Pole | 90       | 0         | ✅ Success (boundary)            |
| South Pole | -90      | 0         | ✅ Success (boundary)            |

### Hints 💡

- **Boundary Testing:** Remember to allow exactly -90, 90, -180, 180  
- **User Experience:** Keep the dialog open on error so users can correct their input  
- **Error Messages:** Be specific about what's wrong and what values are valid  
- **Compound Conditions:** Use `&&` to combine multiple validation checks

> **Learn More:**
>
> - [Form Validation in Flutter](https://docs.flutter.dev/cookbook/forms/validation)
> - [SnackBars](https://api.flutter.dev/flutter/material/ScaffoldMessenger-class.html)

### 💡 Solution

```dart
if (name.isNotEmpty && lat != null && lon != null) {
  String? errorMessage;
  
  if (lat < -90 || lat > 90) {
    errorMessage = 'Latitude must be between -90 and 90 degrees';
  } else if (lon < -180 || lon > 180) {
    errorMessage = 'Longitude must be between -180 and 180 degrees';
  }
  
  if (errorMessage == null) {
    sl<ClimateViewModel>().addLocation(name, lat, lon);
    Navigator.pop(context);
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(errorMessage),
        backgroundColor: Colors.red,
      ),
    );
  }
}
```

**Production Enhancement:** In a real app, you'd also validate:

- Name doesn't contain special characters
- Location name doesn't already exist (prevent duplicates)
- Coordinates point to land (optional, using geocoding API)

---

## Exercise 5: Implement Chart Data Scaling (Optional)

**File:** `lib/ui/climate/widgets/climate_diagram.dart`

### Learning Objectives

- ✅ Perform mathematical transformations on datasets
- ✅ Use functional programming with `reduce()`
- ✅ Handle edge cases (division by zero)
- ✅ Understand chart visualization scaling

### Context

The climate chart displays two metrics on the same Y-axis:

- **Temperature:** Ranges from -20°C to +40°C (60° range)
- **Precipitation:** Ranges from 0mm to 100mm (100mm range)

**The Problem:**

Without scaling, precipitation bars would be invisible compared to temperature:

```
Temperature: 25°C  →  Chart shows at 25 units
Precipitation: 25mm →  Chart shows at 25 units (same height!)
```

But 25mm of rain is a LOT more significant than 25°C in this context.

**The Solution:**

Scale precipitation to use ~80% of the temperature range:

```
If temp range = 60° and max precip = 100mm:
Scale factor = (60 * 0.8) / 100 = 0.48
Precip value of 50mm displays as: 50 * 0.48 = 24 chart units
```

### Your Task

Calculate the scaling factor for precipitation data starting at **line 16**.

### Requirements

1. Find the maximum precipitation value
2. Find the temperature range (max temp - min temp)
3. Calculate scale factor: `(tempRange * 0.8) / maxPrecipitation`
4. Handle edge case: if max precipitation is 0, use scale factor of 1.0

> **Why 0.8?** This reserves 20% of chart space above precipitation bars, preventing them from being too heavy on the visualization.

### Starting Code

```dart
// TODO: Exercise 5
// 1. Find maxPrecipitation: precip.reduce(math.max)
// 2. Find maxTemperature: maxTemp.reduce(math.max)
// 3. Find minTemperature: minTemp.reduce(math.min)
// 4. Calculate tempRange = maxTemperature - minTemperature
// 5. Calculate precipScale:
//    - If maxPrecipitation > 0: (tempRange * 0.8) / maxPrecipitation
//    - Else: 1.0 (prevent division by zero)

final maxPrecipitation = 0.0; // Replace this
final precipScale = 1.0;      // Replace this
```

### Success Criteria

✅ Precipitation bars are visible and proportional on the chart  
✅ Precipitation scales appropriately with temperature axis  
✅ Right Y-axis labels show correct precipitation values in mm  
✅ No crashes when precipitation is 0 (e.g., desert locations)  
✅ Chart remains readable with varying data ranges

### Understanding the Math

**Example Calculation (Berlin):**

- Max temperature: 35°C
- Min temperature: -5°C
- Temp range: 40°C
- Max precipitation: 80mm

```dart
precipScale = (40 * 0.8) / 80 = 0.4

// When displaying 60mm precipitation:
displayValue = 60 * 0.4 = 24°C equivalent on chart

// When showing tooltip (lines 178-209):
actualValue = displayValue / precipScale = 24 / 0.4 = 60mm ✅
```

### Hints 💡

- **List.reduce():** Applies a function across all list elements  
- **math.max/min:** Dart's built-in comparison functions  
- **Division by Zero:** Always check if denominator > 0 before dividing  
- **Ternary Operator:** Perfect for conditional expressions  
- **Import Needed:** `import 'dart:math' as math;` (already present)

> **Learn More:**
>
> - [List Methods in Dart](https://api.dart.dev/stable/dart-core/List-class.html)
> - [Charts in Flutter](https://pub.dev/packages/fl_chart)

### 💡 Solution
```dart
final maxPrecipitation = precip.reduce(math.max);
final maxTemperature = maxTemp.reduce(math.max);
final minTemperature = minTemp.reduce(math.min);

final tempRange = maxTemperature - minTemperature;
final precipScale = maxPrecipitation > 0
    ? (tempRange * 0.8) / maxPrecipitation
    : 1.0;
```

**How It's Used in the Chart:**

**Displaying Precipitation (lines 134-149):**

```dart
LineChartBarData(
  spots: List.generate(
    precip.length,
    (i) => FlSpot(i.toDouble(), precip[i] * precipScale), // Scaled up
  ),
  // ... styling
),
```

**Tooltip Labels (lines 189-192):**

```dart
if (touchedSpot.barIndex == 0) {
  label = 'Precipitation';
  value = '${precip[index].toStringAsFixed(1)} mm'; // Original value
  color = Colors.green;
}
```

**Right Y-Axis Labels (lines 73-84):**

```dart
getTitlesWidget: (value, meta) {
  if (value < 0) return const Text('');
  final precipValue = value / precipScale; // Scale back down
  return Text('${precipValue.toInt()} mm', ...);
}
```

**Why This Works:**

1. Data is scaled UP for display on the chart
2. Labels are scaled DOWN to show actual values
3. Visual proportions match data significance
4. Edge case (zero precipitation) is handled gracefully

**Alternative Approach (Min-Max Normalization):**

```dart
// Normalize both datasets to 0-1 range, then scale to chart
final tempNormalized = temp / tempRange;
final precipNormalized = precip / maxPrecip;
```

This gives even more control but is overkill for this use case.

---

## **Part 3: Congratulations! 🎉

You've completed the Flutter Climate App workshop. Let's summarize what you've learned:


1. **🔄 Reactive State Management**  
   Changes in ViewModel automatically update UI through `notifyListeners()` and `watchPropertyValue()`

2. **⚠️ Functional Error Handling**  
   `Either` type makes errors explicit and type-safe - no hidden exceptions

3. **🧩 Widget Composition**  
   Complex UIs are built from simple, reusable pieces (Lego bricks)

4. **📢 Declarative UI**  
   UI = f(state). You describe what to show, Flutter handles the how

5. **🎯 Conditional Rendering**  
   Ternary operators and null-aware operators for clean state transitions


#### **Enterprise Architecture Benefits:**

- **Clear Separation of Concerns**: UI ↔ Business Logic ↔ Data Layer  
- **Testable ViewModels**: No UI dependencies, pure Dart logic  
- **Type-Safe Error Handling**: Compiler catches missing error cases  
- **Performance Optimization**: Selective rebuilds with `watchPropertyValue`  
- **Maintainable Codebase**: SOLID principles, dependency injection

---
### Where to Go From Here

#### **Official Flutter Resources**

📚 **Essential Reading:**

- [Flutter Codelabs](https://docs.flutter.dev/codelabs) - 15+ hands-on tutorials
- [Widget Catalog](https://docs.flutter.dev/ui/widgets) - Complete widget reference with examples
- [Cookbook](https://docs.flutter.dev/cookbook) - Solutions to common patterns
- [API Reference](https://api.flutter.dev/) - Searchable documentation

🎓 **Learning Paths:**

- [Flutter Basics Course](https://docs.flutter.dev/get-started/learn-more) - Official beginner curriculum
- [State Management Guide](https://docs.flutter.dev/data-and-backend/state-mgmt/intro) - Choosing the right approach
- [Testing Best Practices](https://docs.flutter.dev/testing/overview) - Unit, widget, integration tests

#### **State Management Alternatives**

The app uses **watch_it**, but explore these popular options:

|Package|Best For|Learning Curve|Use Case|
|---|---|---|---|
|**[Riverpod](https://riverpod.dev/)**|Modern apps|Medium|Most flexible, compile-time safety|
|**[Bloc](https://bloclibrary.dev/)**|Enterprise apps|High|Event-driven, Redux-like|
|**[Provider](https://pub.dev/packages/provider)**|Simple apps|Low|Officially recommended by Flutter team|
|**[GetX](https://pub.dev/packages/get)**|Rapid development|Low|All-in-one (routing, DI, state)|

> **Recommendation:** Start with Provider for learning, graduate to Riverpod for production apps.

#### **Testing in Flutter**

Production apps need comprehensive testing:

**Unit Tests** (Fast, Isolated)

```dart
test('selectLocation updates state', () {
  final viewModel = ClimateViewModel(repository: mockRepo);
  viewModel.selectLocation('Berlin');
  expect(viewModel.selectedLocation, 'Berlin');
});
```

**Widget Tests** (Medium Speed)

```dart
testWidgets('Shows error message when API fails', (tester) async {
  await tester.pumpWidget(ClimateScreen());
  await tester.tap(find.text('Invalid Location'));
  await tester.pump();
  expect(find.text('Invalid response'), findsOneWidget);
});
```

**Integration Tests** (Slow, Comprehensive)

```dart
testWidgets('Complete user flow', (tester) async {
  app.main();
  await tester.pumpAndSettle();
  await tester.tap(find.byIcon(Icons.menu));
  await tester.tap(find.text('Berlin'));
  expect(find.byType(ClimateDiagram), findsOneWidget);
});
```

> **Learn More:** [Flutter Testing Guide](https://docs.flutter.dev/testing)

#### **Community and Support**

🤝 **Get Help:**

- [Stack Overflow (flutter tag)](https://stackoverflow.com/questions/tagged/flutter)
- [Flutter Community Slack](https://fluttercommunity.dev/joinslack)
- [r/FlutterDev](https://www.reddit.com/r/FlutterDev/) - Active Reddit community
- [Flutter Discord](https://discord.gg/N7Yshp4) - Real-time chat

---
### When to Choose Flutter

**✅ Great Fit:**

- Apps needing consistent UI across platforms
- Rapid prototyping and MVPs
- Startups with limited resources
- Apps with heavy animations
- Internal enterprise tools

**⚠️ Consider Alternatives:**

- Apps requiring cutting-edge native APIs (wait for Flutter support)
- Teams with existing native expertise (migration cost)
- Simple CRUD apps (web might suffice)
- Apps needing smallest possible binary size

---
### Essential Flutter Commands

```bash
# Development
flutter doctor               # Check installation & dependencies
flutter pub get              # Install packages from pubspec.yaml
flutter run                  # Run app on connected device
flutter run -d chrome        # Run on web browser
flutter run --release        # Production build (optimized)

# Debugging
flutter clean                # Delete build cache (fixes weird errors)
flutter analyze              # Static code analysis
flutter test                 # Run unit & widget tests
flutter drive                # Run integration tests

# Code Generation (for freezed, json_serializable)
flutter pub run build_runner build              # Generate once
flutter pub run build_runner watch              # Auto-generate on save
flutter pub run build_runner build --delete-conflicting-outputs  # Force rebuild

# Device Management
flutter devices              # List connected devices
flutter emulators            # List available emulators
flutter emulators --launch <id>  # Start an emulator

# Performance
flutter pub run devtools     # Launch DevTools (profiling, inspector)
flutter run --profile        # Profile mode (performance testing)

# Build & Release
flutter build apk            # Android APK
flutter build appbundle      # Android App Bundle (for Play Store)
flutter build ios            # iOS build (requires Mac)
flutter build web            # Web deployment
```

### Performance Best Practices

#### **1. Use Const Constructors**

```dart
// ❌ Rebuilt on every frame
return Container(
  child: Text('Hello'),
);

// ✅ Created once at compile-time
return const Text('Hello');
```

#### **2. Extract Widgets**

```dart
// ❌ Everything rebuilds when counter changes
build() {
  return Column(
    children: [
      ExpensiveWidget(),  // Rebuilds unnecessarily
      Text('$counter'),
    ],
  );
}

// ✅ ExpensiveWidget only rebuilds if its props change
class ExpensiveWidget extends StatelessWidget {
  const ExpensiveWidget({super.key});
  // ...
}
```

#### **3. Avoid Building in Loops**

```dart
// ❌ Creates new widgets in loop
return Column(
  children: items.map((item) => Text(item)).toList(),
);

// ✅ Use ListView.builder (lazy loading)
return ListView.builder(
  itemCount: items.length,
  itemBuilder: (context, index) => Text(items[index]),
);
```

---

**Happy coding and enjoy building with Flutter! 🚀**

---


# ESD Standard Information

[![Review Assignment Due Date](https://classroom.github.com/assets/deadline-readme-button-22041afd0340ce965d47ae6ef1cefeee28c7c493a6346c4f15d667ab976d596c.svg)](https://classroom.github.com/a/t1er-CAW)
# ESD template

Please make sure all artifacts are in this GitHub repository.  
That includes:

- Code
- Workshop materials
- Presentation (if applicable)
- References
- Docker (compose) file (if applicable)
