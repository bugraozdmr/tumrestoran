# Tüm Restoran - Baştan Sona iOS Test, Dağıtım ve App Store Yayın Süreci

Bu doküman, projenin ilk test aşamasından başlayarak Mac'te Xcode olmadan GitHub Actions üzerinden App Store'a yüklenmesine kadar uygulanan tüm adımları, kullanılan araçları ve mantıklarını eksiksiz açıklar.

---

## 1. İlk Problem ve Çözümü

### Sorun:
İlk GitHub Actions derlemesinde şu hata alındı:
```text
Target file "lib/main_prod.dart" not found.
Error: Process completed with exit code 1.
```

### Nedeni:
* `.github/workflows/ios-simulator.yml` dosyasında derleme komutuna `-t lib/main_prod.dart` ve `--flavor ios-production` parametreleri eklenmişti.
* Ancak projede ne `main_prod.dart` adında bir dosya ne de `ios-production` adında bir Xcode Flavor/Scheme vardı. Uygulamanın tek giriş noktası `lib/main.dart` idi.
* Android build'i ise standart `flutter build apk` komutuyla doğrudan `lib/main.dart` üzerinden alındığı için sorunsuz geçmişti.

### Çözüm:
Workflow dosyasındaki build adımı standartlaştırıldı:
```bash
flutter build ios --simulator --debug
```

---

## 2. Appetize.io ile Tarayıcı Üzerinde iOS Testi

* **Kullanılan Araç:** [Appetize.io](https://appetize.io) (Web tabanlı sanal cihaz emülatörü).
* **Neden Kullanıldı?:** Yerel bilgisayarda iPhone emülatörü veya fiziksel test cihazı olmadan, üretilen iOS uygulamasını doğrudan tarayıcı üzerinden açıp çalıştırmak ve test etmek için.
* **Teknik Detay:**
  * Appetize gerçek cihaz imzalı (`.ipa`) dosya değil, **iOS Simulator derlemesi (`.app`)** ister.
  * Bu derleme Apple geliştirici sertifikası veya hesap girişi gerektirmez.
  * GitHub Actions `ditto -c -k --sequesterRsrc --keepParent` komutuyla `Runner.app` dosyasını standart zip formatına dönüştürdü ve artifact olarak sundu.
  * Dosya Appetize'a yüklenerek test başarıyla tamamlandı.

---

## 3. Donanım Kısıtı: Yerel Mac'te Xcode Olmaması

* **Kısıt:** Kullanıcının Mac bilgisayarında yeterli disk alanı bulunmadığı için Xcode (15-30 GB) kurulamıyordu.
* **Geliştirilen Strateji:**
  * Mac'e Xcode kurmak yerine, **GitHub Actions'ın bulut macOS sunucularını** kullandık.
  * Kod derleme, sertifika kurulumu, imzalama ve Apple sunucularına dosya gönderme işlemlerinin tamamı GitHub bulutu üzerinde otomatikleştirildi.

---

## 4. Kimlik ve Paket Adı Değişimi (Bundle Identifier)

* **Önceki Değer:** `com.inilabs.foodnanny.customer` (Şablon projenin varsayılan paketi).
* **İstenen Yeni Değer:** `com.tumrestoran` (Tüm Restoran kurumsal kimliği).

### Yapılanlar:
1. **Apple Developer Portal:**
   * `developer.apple.com` üzerinde yeni bir **App ID** açıldı:
     * **Description:** `Tum Restoran`
     * **Bundle ID:** `com.tumrestoran`
     * **Capabilities:** Bildirimler için **Push Notifications** yetkisi eklendi.
2. **App Store Connect:**
   * `appstoreconnect.apple.com` üzerindeki "Tüm Restoran" uygulamasının Bundle ID'si `Tum Restoran - com.tumrestoran` olarak seçildi.
3. **Flutter Projesi Güncellemesi:**
   * `ios/Runner.xcodeproj/project.pbxproj` (iOS paket kimliği)
   * `ios/Runner/GoogleService-Info.plist` (Firebase iOS kimliği)
   * `lib/firebase_options.dart` (FlutterFire iOS yapılandırması)
   dosyalarında paket adı `com.tumrestoran` olarak eşitlendi.

---

## 5. Sertifikalar ve İmzalama (Code Signing)

App Store'a yüklenecek her uygulamanın Apple tarafından doğrulanmış bir dağıtım sertifikasıyla imzalanması zorunludur. Kullanıcının Mac'inde Keychain ile uğraşmaması için süreç terminal üzerinden yürütüldü:

1. **CSR ve Private Key Üretimi:**
   * `openssl` ile imza talep dosyası oluşturuldu:
     * `distribution.key` (Özel anahtar)
     * `distribution.certSigningRequest` (İmza talebi)
2. **Dağıtım Sertifikası (`distribution.cer`):**
   * Apple Developer portalına CSR yüklenerek Apple onaylı sertifika indirildi.
3. **PKCS#12 (.p12) Üretimi:**
   * `distribution.cer` ve `distribution.key` birleştirilerek GitHub Actions'ın okuyabileceği şifreli `distribution.p12` sertifikası üretildi (Şifre: `TumRestoran2026!`).
4. **Provisioning Profile (`Tum_Restoran.mobileprovision`):**
   * Apple Developer portalında `com.tumrestoran` kimliği ve dağıtım sertifikası eşleştirilerek "App Store" profili üretildi ve indirildi.
5. **Güvenlik (`.gitignore`):**
   * `.key`, `.cer`, `.p12`, `.mobileprovision`, `.p8` ve `ignore` uzantılı tüm dosyalar `.gitignore`'a eklenerek GitHub deposuna açık metin olarak gitmesi engellendi.

---

## 6. App Store Connect API Anahtarı

* **Neden Gereklidir?:** GitHub Actions bulut sunucusunun Apple ID şifresi ve 2 faktörlü SMS doğrulamasına takılmadan doğrudan App Store Connect'e `.ipa` yükleyebilmesi için.
* **Oluşturulan Yer:** `appstoreconnect.apple.com` -> **Users and Access -> Integrations -> App Store Connect API**.
* **Alınan Veriler:**
  * **Key ID:** `6XW2RCNM2A`
  * **Issuer ID:** API sayfasının üstünde yer alan UUID kodu.
  * **Özel Anahtar:** `AuthKey_6XW2RCNM2A.p8` dosyası.

---

## 7. Dağıtım Otomasyonu (Deploy to App Store)

### Oluşturulan Dosyalar:
1. **`ios/ExportOptions.plist`:**
   * Flutter'a uygulamanın manuel imzalama yöntemiyle, `M4736HR2A4` Team ID'si ve `Tum Restoran` profiliyle `app-store` formatında paketlenmesini söyleyen Apple yapılandırma dosyası.
2. **`.github/workflows/deploy-appstore.yml`:**
   * macOS bulut makinesini ayağa kaldırır.
   * Gizli Base64 değişkenlerinden sertifikayı geçici Keychain'e, profili `Provisioning Profiles` dizinine yükler.
   * `flutter build ipa --release --export-options-plist=ios/ExportOptions.plist` komutuyla imzalı `.ipa` üretir.
   * Apple'ın resmi `xcrun altool --upload-app` aracı ile paketi doğrudan App Store Connect'e gönderir.
   * **Neden Manuel?:** Yanlışlıkla veya her kod commit'inde App Store'a gereksiz sürüm gitmesin diye sadece "Run workflow" butonuyla çalışır.

### GitHub Repository Secrets (Settings -> Secrets and variables -> Actions):
Tüm hassas veriler GitHub Secrets üzerinde şifrelenmiştir:
* `APPSTORE_KEY_ID`: `6XW2RCNM2A`
* `APPSTORE_ISSUER_ID`: App Store Connect API sayfasındaki UUID.
* `APPSTORE_PRIVATE_KEY`: `AuthKey_6XW2RCNM2A.p8` dosyasının metni.
* `BUILD_CERTIFICATE_BASE64`: `distribution.p12` dosyasının Base64 hali.
* `P12_PASSWORD`: `TumRestoran2026!`
* `BUILD_PROVISION_PROFILE_BASE64`: `Tum_Restoran.mobileprovision` dosyasının Base64 hali.

---

## 8. App Store Connect'te Yayına Alma (Son Adım)

GitHub Actions workflow'u tamamlandığında:
1. **App Store Connect** -> **Tüm Restoran** -> **TestFlight** sekmesinde yüklenen build görünür (Apple'ın 5-10 dakikalık otomatik güvenlik taraması sonrası kullanılabilir olur).
2. **Distribution -> 1.0 Prepare for Submission** sekmesine gidilir:
   * **Build:** `+` butonuna tıklanıp yüklenen build seçilir.
   * **Ekran Görüntüleri:** 6.7" ve 6.5" iPhone cihaz boyutlarında uygulama içi görseller yüklenir.
   * **Promotional & Description:** Uygulama tanıtım metinleri girilir.
   * **Gizlilik Politikası (Privacy Policy URL):** Web sitenizdeki sözleşme linki eklenir.
   * **App Review Information:** Apple test uzmanlarının giriş yapabilmesi için bir demo kullanıcı adı ve şifresi belirtilir.
3. Sağ üstteki **"Add for Review"** butonuna basılarak uygulama Apple onayına gönderilir.
