## **Flutter Notes App**

Bu proje, Connectinno Flutter Developer Case kapsamında geliştirilmiş bir not uygulamasıdır.
Uygulama, kullanıcıların notlarını oluşturmasına, düzenlemesine, silmesine, sabitlemesine ve favorilere eklemesine olanak tanır.
Ayrıca offline-first mimarisi sayesinde internet bağlantısı olmasa bile notlara erişim sağlar.

**Özellikler**

Kullanıcı girişi, kayıt ve çıkış işlemleri (Supabase Auth)

Not ekleme, güncelleme, silme (CRUD işlemleri)

Notları pinleme (sabitleme) ve favorilere ekleme

Arama ve filtreleme (başlığa veya içeriğe göre)

Bloc/Cubit ile global state yönetimi

Supabase senkronizasyonu

Material Theme Builder ile oluşturulmuş renk paleti

Kullanıcı dostu ve basit bir arayüz

**Tasarım Yaklaşımı**

Renk paleti ve genel görünüm Flutter Material Theme Builder aracılığıyla oluşturulmuştur.

Uygulama tasarımı hazırlanırken internetteki popüler note uygulamalarının arayüzleri incelenmiş, kullanıcı deneyimi (UX) açısından en pratik çözümler uyarlanmıştır.

Temiz, sade ve işlevsel bir arayüz hedeflenmiştir.

**Mimari Yapı**

Proje Clean Architecture prensiplerine göre katmanlı olarak yapılandırılmıştır.

lib/
├── data/
│   ├── datasources/      # Local ve remote veri kaynakları (Hive, Supabase)
│   ├── models/           # Model tanımları
│   └── repositories/     # Repository implementasyonları (Yapılmadı)
├── domain/
│   ├── entities/         # Entity tanımları
│   ├── repositories/     # Repositroy tanımları (Yapılmadı)
│   └── usecases/         # İş mantığı (Yapılmadı)
├── presentation/
│   ├── cubit/            # Bloc / Cubit state yönetimi
│   ├── pages/            # Ekranlar
│   └── widgets/          # UI bileşenleri
└── main.dart             # Uygulama girişi

## Kullanılan Teknolojiler ve Paketler

| Alan | Teknoloji |
|------|------------|
| UI | Flutter |
| State Management | Bloc / Cubit |
| Local Database | Hive |
| Remote Database | Supabase |
| HTTP İletişimi | supabase_flutter, Dio |
| Theme | Flutter Material Theme Builder |
| Routing | go_router |

## Kurulum
1. Depoyu klonlayın
git clone https://github.com/alperenmfol/Note-App.git
cd flutter-notes-app

2. Gerekli paketleri yükleyin
flutter pub get

3. Ortam değişkenlerini tanımlayın

.env dosyasını oluşturun ve Supabase bilgilerinizi girin:

SUPABASE_URL=
SUPABASE_ANON_KEY=


Projede .env.example dosyası örnek olarak mevcuttur.

##Çalıştırma

Uygulamayı başlatmak için:

flutter run



**Kullanım Özeti**

Uygulamayı açın ve kayıt olun / giriş yapın.

Yeni not ekleyin veya mevcut notları düzenleyin.

Notları sabitleyebilir veya favorilere ekleyebilirsiniz.

Arama çubuğu üzerinden başlığa veya içeriğe göre filtreleme yapabilirsiniz.
