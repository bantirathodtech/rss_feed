plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.rss_feed_example"
//    compileSdk = flutter.compileSdkVersion
//    ndkVersion = flutter.ndkVersion
    compileSdk = 35
    ndkVersion = "27.0.12077973"

//    compileOptions {
//        sourceCompatibility = JavaVersion.VERSION_11
//        targetCompatibility = JavaVersion.VERSION_11
//    }
//
//    kotlinOptions {
//        jvmTarget = JavaVersion.VERSION_11.toString()
//    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17 // Use assignment
        targetCompatibility = JavaVersion.VERSION_17 // Use assignment
//        coreLibraryDesugaringEnabled = true
        isCoreLibraryDesugaringEnabled = true // Fixed: Use isCoreLibraryDesugaringEnabled
    }

    kotlinOptions {
        jvmTarget = "17"
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.example.rss_feed_example"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
//        minSdk = flutter.minSdkVersion
//        targetSdk = flutter.targetSdkVersion
//        versionCode = flutter.versionCode
//        versionName = flutter.versionName
        minSdk = 23 // minSdk instead of minSdkVersion in KTS
        targetSdk = 35 // targetSdk instead of targetSdkVersion in KTS
//        versionCode = flutter.versionCode.toInteger()
        versionCode = flutter.versionCode.toInt() // Fixed: Use toInt() instead of toInteger()
        versionName = flutter.versionName
        multiDexEnabled = true // Added for robustness
    }

//    buildTypes {
//        release {
//            // TODO: Add your own signing config for the release build.
//            // Signing with the debug keys for now, so `flutter run --release` works.
//            signingConfig = signingConfigs.getByName("debug")
//        }
//    }
//}
    buildTypes {
        debug {
            isMinifyEnabled = false
            isShrinkResources = false // Explicitly disable resource shrinking for debug
        }
        release {
            signingConfig = signingConfigs.getByName("debug")
            isMinifyEnabled = false
            isShrinkResources = false // Explicitly disable resource shrinking for release
            proguardFiles(getDefaultProguardFile("proguard-android-optimize.txt"), "proguard-rules.pro")
        }
    }
}

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.0.4")
}

flutter {
    source = "../.."
}
