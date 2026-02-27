
name: Build Android arm64-v8a APK
on:
  workflow_dispatch:
  push:
    branches: [ main, master ]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - name: Check out
        uses: actions/checkout@v4

      - name: Set up JDK 17
        uses: actions/setup-java@v4
        with:
          distribution: 'temurin'
          java-version: '17'

      - name: Make gradlew executable
        run: chmod +x ./gradlew

      - name: Download Gradle Wrapper
        run: |
          curl -sL https://services.gradle.org/distributions/gradle-8.2.1-bin.zip -o gradle.zip
          unzip -q gradle.zip -d gradle_tmp
          mkdir -p gradle/wrapper
          cp gradle_tmp/gradle-8.2.1/lib/gradle-launcher-8.2.1.jar gradle/wrapper/gradle-wrapper.jar

      - name: Build debug APK (arm64-v8a)
        run: ./gradlew :app:assembleDebug

      - name: Upload APK artifact
        uses: actions/upload-artifact@v4
        with:
          name: PerceelMap-arm64-debug
          path: app/build/outputs/apk/debug/app-arm64-v8a-debug.apk
          if-no-files-found: warn
