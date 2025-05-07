# Flutter BMI APP
# 📱 BMI Tracker — Flutter App

**BMI Tracker** (Body Mass Index Tracker) is a lightweight Flutter application that lets users calculate their BMI, store a personal history of results on-device, and receive tailored health tips based on World Health Organization (WHO) guidelines.

<img src="docs/screenshot_main.png" width="260"> <img src="docs/screenshot_history.png" width="260">

---

## ✨ Features

| Feature | Description |
|---------|-------------|
| **Instant BMI Calculator** | Supports metric (kg / cm) and imperial (lb / inch) units.|
| **Result Categories** | Seven categories (Severely Underweight → Obese Class III) with emoji feedback.|
| **Personal Profile** | Gender & age stored per result for age-aware tips.|
| **Health Tips** | Auto-generated, evidence-based suggestions that adapt to BMI category and age.|
| **History Log** | Unlimited local history persisted with `SharedPreferences`; entries are timestamped and can be deleted individually or in bulk.|
| **State Management** | Powered by **Provider** for clear separation between UI and logic.|
| **100 % Offline** | No network permission required; all data stays on the device. |

---

## 🏗️  Project Structure

```text
lib/
 ├─ application/               # Providers & state
 │   └─ imc_form_provider.dart
 ├─ infrastructure/
 │   └─ models/                # Plain-Dart data classes
 │       ├─ imc_result.dart
 │       └─ user_profile.dart
 ├─ presentation/              # UI widgets & pages
 └─ main.dart                  # App entry point
