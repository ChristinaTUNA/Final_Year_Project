# 🍳 CooKit – Smart Grocery & Recipe Assistant  
*A Multimodal AI-Powered Application to Minimize Food Waste and Decision Fatigue via Personalized Recommendations*

---

## 📦 Libraries Used

<p align="left">
  <a href="https://flutter.dev/"><img src="https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white" /></a>
  <a href="https://dart.dev/"><img src="https://img.shields.io/badge/Dart-%230175C2.svg?style=for-the-badge&logo=dart&logoColor=white" /></a>
  <a href="https://firebase.google.com/"><img src="https://img.shields.io/badge/Firebase-FFCA28?style=for-the-badge&logo=firebase&logoColor=black" /></a>
  <a href="https://riverpod.dev/"><img src="https://img.shields.io/badge/Riverpod-410c6b?style=for-the-badge&logo=flutter&logoColor=white" /></a>
  <a href="https://ai.google.dev/"><img src="https://img.shields.io/badge/Google%20Gemini-8E75B2?style=for-the-badge&logo=google&logoColor=white" /></a>
  <a href="https://spoonacular.com/food-api"><img src="https://img.shields.io/badge/Spoonacular-1DB954?style=for-the-badge&logo=leaf&logoColor=white" /></a>
  <a href="https://pub.dev/packages/http"><img src="https://img.shields.io/badge/HTTP-005571?style=for-the-badge&logo=http&logoColor=white" /></a>
  <a href="https://pub.dev/packages/image_picker"><img src="https://img.shields.io/badge/Image_Picker-E30066?style=for-the-badge&logo=camera&logoColor=white" /></a>
  <a href="https://pub.dev/packages/google_fonts"><img src="https://img.shields.io/badge/Google_Fonts-4285F4?style=for-the-badge&logo=google-fonts&logoColor=white" /></a>
  <a href="https://pub.dev/packages/equatable"><img src="https://img.shields.io/badge/Equatable-005571?style=for-the-badge&logo=dart&logoColor=white" /></a>
</p>

---

## 📋 Project Overview

**CooKit** is an intelligent mobile application designed to solve grocery management and meal-planning challenges. By combining **computer vision** with a **heuristic recommendation engine**, users can digitize pantry items using the camera and instantly receive personalized **“Cook Now”** recipes based on available ingredients.

---

## 📊 Data Sources & APIs

**Hybrid real-time + cached architecture**

- **Recipe Data**: Spoonacular API  
  - Endpoints: `complexSearch`, `findByIngredients`, `getRecipeInformation`
- **Image Recognition**: Google Gemini API  
  - Model: `gemini-2.5-flash`
- **Backend & Caching**: Firebase  
  - Authentication (Email / Google)  
  - Firestore (NoSQL)

---

## 📁 Project Structure

```
 CooKit/
├── android/
├── ios/
├── lib/
│ ├── core/ # Global utilities (Theme, Router, Constants)
│ │ ├── router/
│ │ └── theme/
│ ├── data/ # Data Layer (Models & Services)
│ │ ├── models/ # Recipe, ListItem, ScannedIngredient, UserPreferences
│ │ └── services/
│ │ ├── gemini_service.dart
│ │ ├── recipe_service.dart
│ │ ├── recommendation_service.dart
│ │ └── user_database_service.dart
│ └── features/ # UI Layer (MVVM Modules)
│ ├── chatbot/ # Chef Mato AI Chat
│ ├── explore/ # Search & Filter Logic
│ ├── home/ # Dashboard & Smart Sections
│ ├── lists/ # Pantry & Shopping List
│ ├── login/ # Authentication Flow
│ ├── profile/ # User Settings
│ ├── recipe/ # Recipe Details
│ └── scan/ # Camera & Results Sheet
└── pubspec.yaml
```

---

## 🤖 Modules Implemented

### 1. AI Ingredient Scanner
- **Technology**: Google Gemini 2.5 Flash  
- **Method**: Multimodal prompt engineering with JSON-enforced output  
- **Capabilities**:
  - Loose produce recognition
  - Label reading
  - Quantity estimation
  - Category classification  
- **UX Enhancements**:
  - Skeleton loaders
  - Optimistic UI updates

### 2. Heuristic Recommendation Engine
- **Model**: Weighted Sum Model (WSM)
- **Formula**:
```
Score = (PantryMatch × 0.5) + (DietPref × 0.3) + (TimePref × 0.2)
```
- **Purpose**: Local re-ranking of API results for relevance and speed

### 3. Hybrid Search Architecture
- **Context-aware logic switch**
- `"apple, flour"` → `findByIngredients` (Inventory Mode)
- `"Pasta"` → `complexSearch` (Discovery Mode)

### 4. Reactive State Management
- **Technology**: Flutter Riverpod (MVVM)
- **Implementation**: Firestore-backed `StreamProvider`
- **Result**: Instant dashboard updates when pantry changes

---

## 🚀 Getting Started

### Prerequisites
```bash
flutter --version   # 3.0+
dart --version
```

### Installation
```bash
git clone https://github.com/yourusername/cookit.git
cd cookit
flutter pub get
```

### Configure API Keys
- Create a file named .env in the root directory of the project and add your API keys:
  ```bash
  SPOONACULAR_API_KEY=your_spoonacular_key_here
  GOOGLE_AI_KEY=your_gemini_api_key_here
  ```

### Run the App
```bash
flutter run
```
---

## 📲 Download the App

You can download the latest version of **CooKit** for Android directly from the Releases page.

1.  **[Click here to go to the Latest Release](https://github.com/ChristinaTUNA/Final_Year_Project/releases/latest)**
2.  Scroll down to the **Assets** section.
3.  Click on **`app-release.apk`** to download.
4.  Open the file on your Android device to install.

> **Note:** Since this is a student project and not on the Play Store, you may need to allow "Install from Unknown Sources" in your phone settings.

---

## 🔧 Future Improvements

- **IoT Integration**  
  Connect smart fridges and Bluetooth scales for automatic inventory updates.

- **Community Recipe Sharing**  
  Enable users to upload, rate, and share family or cultural recipes.

- **Grocery Price Comparison**  
  Integrate local grocery store APIs to recommend the cheapest store for missing ingredients.

---
