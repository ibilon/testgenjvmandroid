mkdir -p build/bin

build-tools/28.0.3/aapt package -f -m -J build -M AndroidManifest.xml -S res -I platforms/android-28/android.jar

javac build/com/testgenjvmandroid/R.java -source 8 -target 8

jar cf build/R.jar -C build com

haxe build.hxml

build-tools/28.0.3/d8 build/jar.jar build/R.jar --lib platforms/android-28/android.jar --min-api 28 --output build/bin

build-tools/28.0.3/aapt package -f -m -F build/bin/testgenjvmandroid.unaligned.apk -M AndroidManifest.xml -S res -I platforms/android-28/android.jar

cd build/bin && ../../build-tools/28.0.3/aapt add testgenjvmandroid.unaligned.apk classes.dex; cd ../..

build-tools/28.0.3/zipalign -f 4 build/bin/testgenjvmandroid.unaligned.apk build/bin/testgenjvmandroid.apk

build-tools/28.0.3/apksigner sign --ks testgenjvmandroid.keystore build/bin/testgenjvmandroid.apk

echo "success"
