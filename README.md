# Sternburg Bingo 2

A Flutter application for Sternburg Bingo built with Riverpod, AutoRoute, and Firebase.

## Architecture & Development Notes

- **State Management & Persistence**:
    - `HydratedBloc` is **not** used for state persistence due to scalability reasons. Instead,
      persistence and state synchronization are planned to connect to a backend via a Firebase
      setup.
- **Icons & Assets**:
    - Custom icons are implemented using precompiled SVGs.
- **Push Notifications**:
    - Push Notification (PN) setup is pending iOS configuration on the Firebase Dashboard side.

---

## Firebase Analytics Debugging (DebugView)

To test and verify Firebase Analytics events in real-time in the **Firebase DebugView**:

### iOS (Verbose Analytics Logging)

#### Option A: Flutter CLI (Terminal)

Run the app with the verbose logging argument:

```bash
flutter run --args="-FIRAnalyticsVerboseLoggingEnabled"
```

To disable verbose logging:

```bash
flutter run --args="-noFIRAnalyticsDebugEnabled"
```

#### Option B: Android Studio / IntelliJ (Run Configurations)

1. Go to **Run > Edit Configurations...**
2. In the **Additional run args** field, add:
   ```text
   --args="-FIRAnalyticsVerboseLoggingEnabled"
   ```

