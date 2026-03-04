# VPhone - Virtual Phone Sandbox 📱

تطبيق Android لتشغيل التطبيقات والألعاب في بيئة معزولة

## Architecture

```
┌─────────────────────────────────────┐
│         Flutter UI Layer            │
│  Home → Install → Settings          │
│         (Dart/Flutter)              │
├─────────────────────────────────────┤
│      Platform Channel Bridge        │
│    com.vphone/virtual_app           │
├─────────────────────────────────────┤
│      Native Android Layer           │
│   VirtualAppEngine (Kotlin)         │
├─────────────────────────────────────┤
│      VirtualApp Framework           │
│  github.com/asLody/VirtualApp       │
│  (App virtualization without root)  │
└─────────────────────────────────────┘
```

## Setup Steps

### 1. Clone VirtualApp
```bash
git clone https://github.com/asLody/VirtualApp.git
# or newer maintained fork:
git clone https://github.com/android-hacker/VirtualXposed.git
```

### 2. Setup Flutter Project
```bash
flutter pub get
```

### 3. Link VirtualApp in settings.gradle
```gradle
includeBuild('../VirtualApp') {
    dependencySubstitution {
        substitute module('com.virtualapp:lib') using project(':lib')
    }
}
```

### 4. Add to app/build.gradle
```gradle
dependencies {
    implementation project(':lib')
    implementation 'androidx.core:core-ktx:1.12.0'
}
```

### 5. AndroidManifest.xml Requirements
```xml
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"/>
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"/>
<uses-permission android:name="android.permission.INTERNET"/>
<uses-permission android:name="android.permission.INSTALL_PACKAGES"/>

<!-- VirtualApp stubs - copy from VirtualApp sample app -->
<application
    android:name=".VPhoneApplication"
    ...>
```

### 6. Create Application Class
```kotlin
class VPhoneApplication : Application() {
    override fun onCreate() {
        super.onCreate()
        VirtualCore.get().startup(this, object : VirtualCore.Callback {
            override fun onMainProcess() {}
            override fun onVirtualProcess() {}
            override fun onServerProcess() {}
        })
    }
}
```

### 7. Build & Run
```bash
flutter build apk --release
# or
flutter run
```

## Supported Features
- ✅ Install APKs without root
- ✅ Multiple virtual spaces (accounts)
- ✅ App isolation (network, storage, identity)
- ✅ Run multiple instances of same app
- ✅ Fake GPS / Device ID per space
- ✅ GPU acceleration for games

## Min Requirements
- Android 5.0 (API 21)+
- Recommended: Android 8+ (API 26)
- RAM: 3GB+ recommended

## Project Structure
```
lib/
├── main.dart                    # Entry point
├── theme/app_theme.dart         # Design system
├── models/virtual_app.dart      # Data models
├── services/
│   ├── vphone_provider.dart     # State management
│   └── virtual_app_channel.dart # Native bridge
├── screens/
│   ├── home_screen.dart         # Main dashboard
│   ├── install_screen.dart      # APK installer
│   └── settings_screen.dart     # Settings
└── widgets/
    ├── app_card.dart            # App grid card
    └── stats_bar.dart           # CPU/RAM monitor

android/
└── app/src/main/kotlin/com/vphone/app/
    ├── MainActivity.kt          # Flutter+Channel entry
    └── VirtualAppEngine.kt      # VirtualApp wrapper
```
