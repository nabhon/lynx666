# Build APK Guide

คู่มือสำหรับการ build ไฟล์ APK ของโปรเจกต์ Lynx Lottery ทีละขั้นตอน

---

## สิ่งที่ต้องมีก่อนเริ่ม (Prerequisites)

- **Flutter SDK** >= 3.11.1
- **Java JDK** 17
- **Android SDK** (ติดตั้งผ่าน Android Studio หรือ command line tools)
- ไฟล์ `.env` ที่มีค่า Supabase credentials

ตรวจสอบว่า Flutter พร้อมใช้งาน:

```bash
flutter doctor
```

---

## ขั้นตอนที่ 1: ตั้งค่า Environment

สร้างไฟล์ `.env` ที่ root ของโปรเจกต์ (ถ้ายังไม่มี):

```env
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_ANON_KEY=your-anon-key-here
```

> **หมายเหตุ:** ไฟล์ `.env` ถูก bundle เป็น asset ใน `pubspec.yaml` แล้ว ไม่ต้องตั้งค่าเพิ่ม

---

## ขั้นตอนที่ 2: ติดตั้ง Dependencies

```bash
flutter pub get
```

---

## ขั้นตอนที่ 3: Generate Code (Riverpod)

โปรเจกต์ใช้ `riverpod_generator` สำหรับ code generation ต้อง run build_runner ก่อน build APK:

```bash
dart run build_runner build --delete-conflicting-outputs
```

ตรวจสอบว่าไม่มี error และไฟล์ `.g.dart` ถูกสร้างเรียบร้อย

---

## ขั้นตอนที่ 4: Build APK

### Debug APK (สำหรับทดสอบ)

```bash
flutter build apk --debug
```

ไฟล์ output: `build/app/outputs/flutter-apk/app-debug.apk`

### Release APK (สำหรับแจกจ่าย)

```bash
flutter build apk --release
```

ไฟล์ output: `build/app/outputs/flutter-apk/app-release.apk`

### Split APK ตาม ABI (ขนาดเล็กลง)

```bash
flutter build apk --split-per-abi --release
```

ไฟล์ output จะแยกเป็น:
- `app-armeabi-v7a-release.apk` — สำหรับอุปกรณ์ ARM 32-bit
- `app-arm64-v8a-release.apk` — สำหรับอุปกรณ์ ARM 64-bit (แนะนำ)
- `app-x86_64-release.apk` — สำหรับ emulator / อุปกรณ์ x86

---

## ขั้นตอนที่ 5: ติดตั้งบนอุปกรณ์

### ผ่าน ADB

```bash
adb install build/app/outputs/flutter-apk/app-release.apk
```

### ผ่าน Flutter

```bash
flutter install
```

---

## สรุปคำสั่งทั้งหมด (Quick Reference)

```bash
# 1. ติดตั้ง dependencies
flutter pub get

# 2. Generate code
dart run build_runner build --delete-conflicting-outputs

# 3. Build release APK
flutter build apk --release
```

---

## การแก้ปัญหาที่พบบ่อย

| ปัญหา | วิธีแก้ |
|--------|---------|
| `JAVA_HOME` ไม่ถูกต้อง | ตั้งค่า `JAVA_HOME` ให้ชี้ไป JDK 17 |
| build_runner error | ลอง `dart run build_runner clean` แล้ว run build ใหม่ |
| Gradle build failed | ลอง `cd android && ./gradlew clean && cd ..` แล้ว build ใหม่ |
| `.env` not found | ตรวจสอบว่าไฟล์ `.env` อยู่ที่ root ของโปรเจกต์ |

---

## หมายเหตุเรื่อง Signing

ปัจจุบัน release build ใช้ **debug signing key** (ดูใน `android/app/build.gradle.kts`):

```kotlin
release {
    signingConfig = signingConfigs.getByName("debug")
}
```

หากต้องการ publish ขึ้น Google Play Store ต้องสร้าง keystore และตั้งค่า signing config ตาม [เอกสาร Flutter](https://docs.flutter.dev/deployment/android)
