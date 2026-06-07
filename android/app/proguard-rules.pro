# ============================================================
# StreamX ProGuard Rules - Production Grade
# ============================================================

# Flutter
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }
-dontwarn io.flutter.embedding.**

# Keep Flutter engine
-keep class io.flutter.embedding.engine.** { *; }
-keep class io.flutter.embedding.android.** { *; }

# ============================================================
# Firebase
# ============================================================
-keep class com.google.firebase.** { *; }
-keep class com.google.android.gms.** { *; }
-dontwarn com.google.firebase.**
-dontwarn com.google.android.gms.**

# Firebase Crashlytics
-keepattributes *Annotation*
-keepattributes SourceFile,LineNumberTable
-keep public class * extends java.lang.Exception

# ============================================================
# OkHttp / Retrofit (used by Dio under the hood on native side)
# ============================================================
-dontwarn okhttp3.**
-dontwarn okio.**
-keep class okhttp3.** { *; }
-keep interface okhttp3.** { *; }

# ============================================================
# Kotlin
# ============================================================
-keep class kotlin.** { *; }
-keep class kotlin.Metadata { *; }
-dontwarn kotlin.**
-keepclassmembers class **$WhenMappings {
    <fields>;
}

# ============================================================
# App-specific models
# ============================================================
-keep class com.streamx.app.** { *; }

# ============================================================
# Reflection
# ============================================================
-keepattributes Signature
-keepattributes *Annotation*
-keepattributes EnclosingMethod
-keepattributes InnerClasses

# ============================================================
# Remove logging in release builds
# ============================================================
-assumenosideeffects class android.util.Log {
    public static boolean isLoggable(java.lang.String, int);
    public static int v(...);
    public static int d(...);
    public static int i(...);
    public static int w(...);
    public static int e(...);
}

# ============================================================
# Keep Parcelable
# ============================================================
-keep class * implements android.os.Parcelable {
    public static final android.os.Parcelable$Creator *;
}

# ============================================================
# Keep Serializable
# ============================================================
-keepclassmembers class * implements java.io.Serializable {
    static final long serialVersionUID;
    private static final java.io.ObjectStreamField[] serialPersistentFields;
    private void writeObject(java.io.ObjectOutputStream);
    private void readObject(java.io.ObjectInputStream);
    java.lang.Object writeReplace();
    java.lang.Object readResolve();
}

# ============================================================
# Hive
# ============================================================
-keep class com.hive.** { *; }
-keep @com.hive.annotations.HiveType class * { *; }

# ============================================================
# Prevent R8 from stripping interface information
# ============================================================
-keep,allowobfuscation,allowshrinking interface retrofit2.Call
-keep,allowobfuscation,allowshrinking class retrofit2.Response

# ============================================================
# WorkManager
# ============================================================
-keep class * extends androidx.work.Worker
-keep class * extends androidx.work.InputMerger
-keep public class * extends androidx.work.ListenableWorker {
    public <init>(...);
}

# ============================================================
# Multidex
# ============================================================
-keep class androidx.multidex.** { *; }
