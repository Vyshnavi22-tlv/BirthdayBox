# 🎂 BirthdayBox

### A Responsive Smart Birthday Management & Reminder Application

BirthdayBox is a modern, responsive Flutter application designed to help users manage birthdays, view upcoming celebrations, track birthday dates, and never miss an important day.

The application is designed to work seamlessly across **mobile, tablet, and desktop screens** and includes **Light/Dark themes, reusable custom widgets, responsive layouts, navigation, state management, form validation, and animations**.

---

## ✨ Features

### 🔐 Authentication

* Login screen
* Sign-up screen
* Email and password validation
* Password visibility toggle
* Responsive authentication UI

### 🏠 Dashboard

* Personalized welcome message
* Total birthday count
* Upcoming birthday count
* This month's birthday statistics
* Upcoming birthday cards
* Quick access to add birthdays

### 🎂 Birthday Management

* Add a new birthday
* Edit birthday information
* Delete birthday
* View birthday details
* Store relationship and notes
* Birthday countdown
* Upcoming birthday tracking

### 📅 Calendar

* Monthly calendar view
* Birthday indicators
* Select a date to view birthdays
* Birthday details from calendar

### 👤 Profile

* User profile
* Personal information
* Theme selection
* Notification settings
* Logout

### 🎨 UI & Customization

* Light Theme
* Dark Theme
* Custom cards
* Custom buttons
* Custom text fields
* Custom birthday widgets
* Consistent typography and spacing

### 📱 Responsive Design

BirthdayBox supports:

* 📱 Mobile
* 📲 Tablet
* 🖥️ Desktop

The interface automatically adapts based on screen width.

### 🎬 Animations

* Animated splash screen
* Fade animations
* Slide animations
* Animated birthday cards
* Birthday celebration animation
* Animated theme transitions

---

# 🧪 Flutter Lab Experiment Coverage

BirthdayBox is designed to demonstrate all the experiments required for the Flutter laboratory.

| Experiment                            | Implementation in BirthdayBox                                |
| ------------------------------------- | ------------------------------------------------------------ |
| **1(a) Install Flutter & Dart SDK**   | Flutter project setup                                        |
| **1(b) Dart Basics**                  | Classes, objects, variables, functions, conditions and lists |
| **2(a) Flutter Widgets**              | Text, Image, Container, Card, Icon, Button and TextField     |
| **2(b) Row, Column & Stack**          | Dashboard, birthday cards and birthday details               |
| **3(a) Responsive UI**                | Mobile, tablet and desktop layouts                           |
| **3(b) Media Queries & Breakpoints**  | `MediaQuery` and screen-width based layouts                  |
| **4(a) Navigator**                    | Navigation between application screens                       |
| **4(b) Named Routes**                 | Named routes for major application pages                     |
| **5(a) Stateful & Stateless Widgets** | Interactive forms, cards and reusable UI                     |
| **5(b) setState & Provider**          | Birthday data and global theme management                    |
| **6(a) Custom Widgets**               | BirthdayCard, StatCard, CustomButton, CustomTextField        |
| **6(b) Themes & Custom Styles**       | Light/Dark ThemeData and reusable styles                     |
| **7(a) Forms**                        | Login, Sign-up and Add Birthday forms                        |
| **7(b) Validation & Error Handling**  | Email, password, name, date and phone validation             |
| **8(a) Flutter Animation Framework**  | Splash and birthday animations                               |
| **8(b) Fade & Slide Animations**      | Animated cards and screen elements                           |

---

# 📱 Application Screens

## 1. Splash Screen

The application starts with an animated BirthdayBox logo.

**Concepts demonstrated:**

* Container
* Image/Icon
* Animation
* Theme
* Custom widgets

---

## 2. Login Screen

Users can enter their email and password.

### Validation

* Email cannot be empty
* Email must have a valid format
* Password cannot be empty
* Password must satisfy minimum requirements

**Concepts demonstrated:**

* Form
* TextFormField
* Validation
* Error handling
* Stateful widgets
* Custom input widgets

---

## 3. Sign-Up Screen

Users can create an account by entering:

* Name
* Email
* Password
* Confirm Password

The form validates user input before submission.

---

## 4. Dashboard

The dashboard provides a summary of the user's birthdays.

### Dashboard Components

* Total birthdays
* Birthdays this month
* Today's birthdays
* Upcoming birthdays
* Add Birthday button

Birthday information is displayed using reusable cards.

---

## 5. Add Birthday

Users can add birthday information using a form.

### Fields

* Name
* Date of Birth
* Relationship
* Phone Number
* Notes
* Profile Image

### Validation

The application checks:

* Required fields
* Valid phone number
* Valid date
* Valid name

---

## 6. Birthday Details

Displays complete information about a selected person.

Example:

```text
👩

Ananya
Friend

🎂 15 October

Birthday in:
02 Days

[ Edit ]    [ Delete ]
```

A countdown card and birthday animation can be displayed when the birthday is approaching.

---

## 7. Calendar

The Calendar screen displays birthdays according to their dates.

Users can select a date and view the birthdays associated with that date.

---

## 8. Profile

The profile screen allows users to:

* View profile information
* Change application theme
* Manage settings
* Logout

---

# 🌗 Theme System

BirthdayBox supports both Light and Dark themes.

### ☀️ Light Mode

Designed with a clean and bright interface.

### 🌙 Dark Mode

Designed for comfortable viewing in low-light environments.

The theme can be changed from the Profile/Settings screen.

Theme state is managed globally using **Provider**.

---

# 📐 Responsive Design

BirthdayBox uses responsive design techniques to provide different layouts for different screen sizes.

### 📱 Mobile

```text
Width < 600px
```

* Single-column layout
* Bottom navigation
* Full-width cards

### 📲 Tablet

```text
600px ≤ Width < 1024px
```

* Two-column cards
* Expanded dashboard
* Adaptive spacing

### 🖥️ Desktop

```text
Width ≥ 1024px
```

* Sidebar navigation
* Multi-column dashboard
* Larger cards
* Expanded content area

Responsive layouts are implemented using Flutter's:

* `MediaQuery`
* `LayoutBuilder`
* Breakpoints
* Flexible widgets
* Expanded widgets

---

# 🧩 Custom Widgets

The application uses reusable widgets to maintain consistency and reduce duplicate code.

### BirthdayCard

Displays birthday information.

```text
┌─────────────────────────┐
│ 👩 Ananya               │
│ 🎂 Tomorrow             │
│ Friend                  │
└─────────────────────────┘
```

### StatCard

Displays dashboard statistics.

```text
┌───────────────┐
│ 🎂 12         │
│ Birthdays     │
└───────────────┘
```

### CustomButton

Reusable application button.

### CustomTextField

Reusable styled input field.

### CountdownCard

Displays the remaining time until a birthday.

---

# 🔄 Navigation

BirthdayBox uses Flutter's navigation system.

### Named Routes

```text
/login
/signup
/home
/birthdays
/add-birthday
/birthday-details
/calendar
/profile
```

Example navigation flow:

```text
Splash
   ↓
Login
   ↓
Dashboard
   ├── Birthdays
   │      └── Birthday Details
   │
   ├── Add Birthday
   │
   ├── Calendar
   │
   └── Profile
```

---

# 🔄 State Management

BirthdayBox demonstrates two Flutter state management approaches.

## setState()

Used for local UI state such as:

* Password visibility
* Form state
* Selected date
* Temporary UI changes
* Local animations

## Provider

Used for application-wide state such as:

* Birthday list
* Theme
* User information
* Birthday updates

---

# 🎬 Animations

The application uses Flutter's animation framework to improve the user experience.

### Splash Animation

```text
Logo
 ↓
Fade In
 ↓
Scale
 ↓
Dashboard
```

### Birthday Card Animation

Birthday cards use:

* FadeTransition
* SlideTransition

### Birthday Celebration

When a birthday occurs:

```text
🎈       🎈

    🎂

HAPPY BIRTHDAY!

   🎉 🎊 🎉
```

---

# 🗂️ Project Structure

```text
birthday_box/
│
├── android/
├── ios/
├── linux/
├── macos/
├── web/
├── windows/
│
├── lib/
│   │
│   ├── main.dart
│   │
│   ├── models/
│   │   └── birthday.dart
│   │
│   ├── screens/
│   │   ├── splash_screen.dart
│   │   ├── login_screen.dart
│   │   ├── signup_screen.dart
│   │   ├── dashboard_screen.dart
│   │   ├── birthdays_screen.dart
│   │   ├── add_birthday_screen.dart
│   │   ├── birthday_details_screen.dart
│   │   ├── calendar_screen.dart
│   │   └── profile_screen.dart
│   │
│   ├── widgets/
│   │   ├── birthday_card.dart
│   │   ├── stat_card.dart
│   │   ├── custom_button.dart
│   │   ├── custom_textfield.dart
│   │   ├── countdown_card.dart
│   │   └── responsive_layout.dart
│   │
│   ├── providers/
│   │   ├── birthday_provider.dart
│   │   └── theme_provider.dart
│   │
│   ├── theme/
│   │   └── app_theme.dart
│   │
│   └── routes/
│       └── app_routes.dart
│
├── test/
│
├── pubspec.yaml
└── README.md
```

---

# 🛠️ Technologies Used

| Technology        | Purpose                          |
| ----------------- | -------------------------------- |
| Flutter           | Cross-platform UI development    |
| Dart              | Application programming language |
| Provider          | State management                 |
| Material Design   | UI components                    |
| MediaQuery        | Responsive layouts               |
| LayoutBuilder     | Adaptive layouts                 |
| Flutter Animation | UI animations                    |

---

# ⚙️ Requirements

Before running the project, install:

* Flutter SDK
* Dart SDK
* Android Studio / VS Code
* Android Emulator or physical Android device

For desktop development:

* Windows / macOS / Linux desktop support depending on target platform

Check Flutter installation:

```bash
flutter doctor
```

---

# 🚀 Installation & Setup

### 1. Clone the repository

```bash
git clone <repository-url>
```

### 2. Open the project

```bash
cd birthday_box
```

### 3. Install dependencies

```bash
flutter pub get
```

### 4. Check connected devices

```bash
flutter devices
```

### 5. Run the application

```bash
flutter run
```

---

# 🧪 Testing Different Screen Sizes

### Mobile

Run using an Android emulator or mobile device.

### Tablet

Run using a tablet emulator or resize the application window.

### Desktop

Run:

```bash
flutter run -d windows
```

The UI automatically changes according to the available screen width.

---

# 🎯 Learning Objectives

Through BirthdayBox, the following Flutter concepts are demonstrated:

* Dart programming fundamentals
* Flutter widget architecture
* Stateless and Stateful widgets
* Layout design
* Responsive UI development
* Media queries and breakpoints
* Navigation
* Named routes
* State management
* Provider
* Custom widgets
* Theme management
* Forms
* Input validation
* Error handling
* Flutter animations
* Cross-platform UI development

---

# 🌟 Future Enhancements

Possible future improvements include:

* 🔔 Local birthday notifications
* ☁️ Firebase authentication
* ☁️ Cloud database
* 📷 Profile image upload
* 📤 Birthday sharing
* 🎁 Gift suggestions
* 🎵 Birthday reminder sounds
* 📅 Google Calendar integration
* 🔄 Cloud synchronization

---

# 👩‍💻 Project

**Project Name:** BirthdayBox
**Type:** Flutter Mobile & Desktop Application
**Domain:** Personal Productivity / Birthday Management
**Platform:** Android, iOS, Web & Desktop
**Language:** Dart
**Framework:** Flutter

---

## 🎂 Never Miss a Special Day!

BirthdayBox combines **responsive design, state management, reusable widgets, forms, themes, navigation, and animations** into one practical Flutter application.
