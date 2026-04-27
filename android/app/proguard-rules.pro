# ProGuard / R8 rules for Rahma release builds.
# Activated by android/app/build.gradle.kts release buildType.

# Keep Kotlin metadata
-keep class kotlin.Metadata { *; }

# Keep Flutter framework classes
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# Firebase (kept for when Firebase SDK is wired in Slice 7)
-keep class com.google.firebase.** { *; }
-keep class com.google.android.gms.** { *; }

# Keep generic signature info for reflection-based libs (e.g. JSON parsers)
-keepattributes Signature
-keepattributes *Annotation*
-keepattributes EnclosingMethod
-keepattributes InnerClasses

# Strip all log calls in release
-assumenosideeffects class android.util.Log {
    public static *** v(...);
    public static *** d(...);
    public static *** i(...);
    public static *** w(...);
    public static *** e(...);
}
