# Add project specific ProGuard rules here.

## Google Maps
-keep class com.google.android.gms.maps.** { *; }
-keep interface com.google.android.gms.maps.** { *; }
-keep class com.google.maps.android.** { *; }

## Google Play Services
-keep class com.google.android.gms.** { *; }
-dontwarn com.google.android.gms.**

## Keep native methods
-keepclassmembers class * {
    native <methods>;
}

## Keep Google Maps classes
-keep public class com.google.android.gms.maps.** { *; }
-keep public class com.google.android.gms.common.** { *; }
-keep public class com.google.android.gms.location.** { *; }

## Geolocator
-keep class com.baseflow.geolocator.** { *; }
-keep interface com.baseflow.geolocator.** { *; }
