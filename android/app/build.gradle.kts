import java.util.Properties
import java.io.FileInputStream
import java.text.SimpleDateFormat
import java.util.Date

plugins {
    id("com.android.application")
    // START: FlutterFire Configuration
    id("com.google.gms.google-services")
    // END: FlutterFire Configuration
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.rollflix.app"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
        isCoreLibraryDesugaringEnabled = true
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    // Suprimir avisos de compilação
    tasks.withType<JavaCompile> {
        options.compilerArgs.addAll(listOf("-Xlint:-options"))
    }

    // Carrega key.properties (crie android/key.properties)
    val keystorePropertiesFile = rootProject.file("key.properties")
    val keystoreProperties = Properties().apply {
        if (keystorePropertiesFile.exists()) {
            FileInputStream(keystorePropertiesFile).use { this.load(it) }
        }
    }

    // Configura signingConfigs usando android/key.properties quando presente
    signingConfigs {
        create("release") {
            if (keystorePropertiesFile.exists()) {
                storeFile = file(keystoreProperties["storeFile"] as String)
                storePassword = keystoreProperties["storePassword"] as String
                keyAlias = keystoreProperties["keyAlias"] as String
                keyPassword = keystoreProperties["keyPassword"] as String
            }
        }
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.rollflix.app"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        
        // VERSION_CODE dinâmico: usa flutter.versionCode (passado via --build-number), senão data (yyMMdd)
        val dateFallbackVersionCode = SimpleDateFormat("yyMMdd").format(Date()).toInt()
        val finalVersionCode = flutter.versionCode.takeIf { it > 0 } ?: dateFallbackVersionCode
        
        println("🔍 DEBUG VERSION_CODE:")
        println("   flutter.versionCode (from --build-number): ${flutter.versionCode}")
        println("   Date fallback: $dateFallbackVersionCode")
        println("   FINAL versionCode: $finalVersionCode")
        
        versionCode = finalVersionCode
        
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            // Use the configured release signing config (from android/key.properties)
            // If key.properties is missing, Gradle will fall back to the debug signing config.
            signingConfig = if (keystorePropertiesFile.exists()) signingConfigs.getByName("release") else signingConfigs.getByName("debug")
        }
    }
}

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.0.4")
}

flutter {
    source = "../.."
}
