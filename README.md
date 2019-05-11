# TestGenjvmAndroid

Testing an android app built with the genjvm target of haxe.

You need a dev build of haxe with genjvm and android 9 (or the emulator).

## Android sdk

Download and extract https://developer.android.com/studio#command-tools

If java 11 follow https://stackoverflow.com/a/55982976

Get the sdk: `tools/bin/sdkmanager "platform-tools" "platforms;android-28" "build-tools;28.0.3"`

## Build project

You'll need to sign the apk.

Create the keystore: `keytool -genkeypair -validity 365 -keystore testgenjvmandroid.keystore -keyalg RSA -keysize 2048`.

You'll have to supply a password of at least 6 characters, which will be required when signing the apk.

### Using shell script

Run: `sh build.sh`, this will required the keystore password.

### Manually

This does the same thing as the shell script, but with some explanations:

Create the build dir: `mkdir -p build/bin`

Generate R.java: `build-tools/28.0.3/aapt package -f -m -J build -M AndroidManifest.xml -S res -I platforms/android-28/android.jar`

Build R.class: `javac build/testgenjvmandroid/R.java -source 8 -target 8`

Make R.jar: `jar cf build/R.jar -C build testgenjvmandroid`

Build the haxe project: `haxe build.hxml`

Create dex files: `build-tools/28.0.3/d8 build/jar.jar build/R.jar --lib platforms/android-28/android.jar --min-api 28 --output build/bin`

Create the apk: `build-tools/28.0.3/aapt package -f -m -F build/bin/testgenjvmandroid.unaligned.apk -M AndroidManifest.xml -S res -I platforms/android-28/android.jar`

Include classes.dex into the apk: `cd build/bin && ../../build-tools/28.0.3/aapt add testgenjvmandroid.unaligned.apk classes.dex; cd ../..`

Sign the package: `build-tools/28.0.3/apksigner sign --ks testgenjvmandroid.keystore build/bin/testgenjvmandroid.unaligned.apk`, this will required the keystore password.

Align the apk: `build-tools/28.0.3/zipalign -f 4 build/bin/testgenjvmandroid.unaligned.apk build/bin/testgenjvmandroid.apk`

## Output

You have the apk in `build/bin/testgenjvmandroid.apk`.

## Emulator

If you don't have an android 9 but want to test the apk you can use the emulator.

Note: /!\ this takes ~4GB, be aware /!\

Get the emulator: `tools/bin/sdkmanager "emulator" "system-images;android-28;google_apis;x86_64"`

Create the emulation image: `tools/bin/avdmanager create avd -n test -k "system-images;android-28;google_apis;x86_64" -p avds`

Run the emulator: `tools/emulator -avd test`

In another terminal, upload the apk: `platform-tools/adb install build/bin/testgenjvmandroid.apk`

Launch the apk: `platform-tools/adb shell am start -m com.testgenjvmandroid/.TestGenjvmAndroid`
