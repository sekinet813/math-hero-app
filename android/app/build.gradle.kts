import java.io.FileInputStream
import java.util.Properties

plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

// Explicit opt-in for the manual CI device-check APK. Never infer this from CI
// or a missing keystore: regular Release builds must keep their release signing.
val ciDeviceApk = providers.gradleProperty("ciDeviceApk")
    .map { it.toBooleanStrict() }
    .orElse(false)
    .get()
val requestedTasks = gradle.startParameter.taskNames.map { it.substringAfterLast(':') }
check(!ciDeviceApk || (requestedTasks.isNotEmpty() && requestedTasks.all { it == "assembleRelease" })) {
    "ciDeviceApk is only allowed with assembleRelease for device-check APKs; " +
        "do not use it for app bundles or other build tasks."
}

android {
    namespace = "com.mathhero.app"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
        isCoreLibraryDesugaringEnabled = true
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    signingConfigs {
        create("release") {
            val keystoreProperties = Properties()
            val keystorePropertiesFile = rootProject.file("key.properties")
            if (!ciDeviceApk && keystorePropertiesFile.exists()) {
                keystoreProperties.load(FileInputStream(keystorePropertiesFile))
                keyAlias = keystoreProperties["keyAlias"] as String?
                keyPassword = keystoreProperties["keyPassword"] as String?
                storeFile = file(keystoreProperties["storeFile"] as String?)
                storePassword = keystoreProperties["storePassword"] as String?
            } else if (!ciDeviceApk) {
                // CIなどkey.propertiesが無い場合は署名情報を設定しない
                println("key.properties not found. Skipping release signing config.")
            }
        }
    }

    defaultConfig {
        applicationId = "com.mathhero.app"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            // Development signing is limited to the explicitly selected APK
            // task. The default/store path continues using the release config.
            signingConfig = signingConfigs.getByName(if (ciDeviceApk) "debug" else "release")
            isMinifyEnabled = true
            proguardFiles(getDefaultProguardFile("proguard-android-optimize.txt"), "proguard-rules.pro")
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.0.4")
}
