# Flutter
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.plugins.** { *; }
-keep class io.flutter.embedding.** { *; }

# Firebase / Google Play services (common)
-keep class com.google.firebase.** { *; }
-keep class com.google.android.gms.** { *; }

# Gson / reflection-based libs
-keepclassmembers class * {
  @com.google.gson.annotations.SerializedName <fields>;
}
-keepclassmembers class * {
  @com.fasterxml.jackson.annotation.* <fields>;
}

# OkHttp/Retrofit (if used)
-dontwarn okhttp3.**
-dontwarn okio.**

# WorkManager (if used)
-keep class androidx.work.** { *; }

# Keep model classes if you use serialization by reflection (adjust as needed)
# -keep class com.yourpackage.model.** { *; }

# Keep annotations used by libraries
-keepattributes *Annotation*

# Prevent obfuscation of generated plugin registrant (safe default)
-keep class **.GeneratedPluginRegistrant { *; }# Please add these rules to your existing keep rules in order to suppress warnings.
# This is generated automatically by the Android Gradle plugin.
-dontwarn com.google.android.play.core.splitcompat.SplitCompatApplication
-dontwarn com.google.android.play.core.splitinstall.SplitInstallException
-dontwarn com.google.android.play.core.splitinstall.SplitInstallManager
-dontwarn com.google.android.play.core.splitinstall.SplitInstallManagerFactory
-dontwarn com.google.android.play.core.splitinstall.SplitInstallRequest$Builder
-dontwarn com.google.android.play.core.splitinstall.SplitInstallRequest
-dontwarn com.google.android.play.core.splitinstall.SplitInstallSessionState
-dontwarn com.google.android.play.core.splitinstall.SplitInstallStateUpdatedListener
-dontwarn com.google.android.play.core.tasks.OnFailureListener
-dontwarn com.google.android.play.core.tasks.OnSuccessListener
-dontwarn com.google.android.play.core.tasks.Task
