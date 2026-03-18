plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
    // id("com.google.gms.google-services")
}

android {
    namespace = "{{android_package}}"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17

        // isCoreLibraryDesugaringEnabled = true
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    buildFeatures {
        buildConfig = true
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "{{android_package}}"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    flavorDimensions += "default"
    productFlavors {
        /* @REPEAT_FLAVOR_START */
        create("{{flavor}}") {
            dimension = "default"
            applicationIdSuffix = if ("{{flavor}}" == "prod") "" else ".{{flavor}}"
            resValue("string", "app_name", if ("{{flavor}}" == "prod") "{{app_display_name}}" else "{{app_display_name}} ({{flavor}})")
            manifestPlaceholders["appName"] = if ("{{flavor}}" == "prod") "{{app_display_name}}" else "{{app_display_name}} ({{flavor}})"
        }
        /* @REPEAT_FLAVOR_END */
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    // coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.5")
}

