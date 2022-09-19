Flutter TODO List Uygulaması. 


Projeye başlamak için github masaüstü uygulaması üzerinden bu repository'i klonlayarak başlayabilirsin. 
Ayrıca ben geliştirme için intellij idea kullanıyorum. öğrenci kimliğin ile ücretsiz edinebiliyorsun.

- genelde çalışmalarını günlük veya günde iki kez commitlemen güzel olur. çok fazla dosya ve değişim içeren tek büyük commitler çok tercih edeceğimiz yapılar değil. 
- uygulma genel tasarımı olarak bir temel tasarım paylaşıyor olacağım. 

Uygulamada olması gerekenler özellikler:

1. Aşama:

Bu aşamada temel işlevsellik üzerine odaklanıyor olacağız. 
Verilerin herhangi bir disk veya veritabanında tutulmasına gerek yok, in memory bir listede tutabilirsin.
-------------------------------------


- Listeye yeni satır eklenmesi
- Eklenen satırların "tamamlandı" şeklinde checkmark ile işaretlenmesi
- Satırların silinebilmesi
- Satırlarda yazılan yazıların güncellenmesi
- Listeyi oluşturmak için ListView.builder widget'ını kullanmanı, Eklenen liste elemanları için de ListTile widgetını kullanmanı tavsiye ederim. 

2. Aşama: 

Bu aşamada oluşturlan verilerin lokal ve harici olarak saklanması konularına odaklanıyor oalcağız.
--------------------------------------

- eklenen verilerin 'shared_prefs' kütüphanesi kullanılarak cihazda saklanması 
- eklenen satırlara kamera ve resim kütüphanesinden resim eklentisi eklenmesi (camera ve photo_library kütüphaneleri)
- eklenen verilerin uygulama her açıldığında cihaz üzerinden yüklenmesi 

3. Aşama

Bu aşamada network api'lerini kullanma konularına odaklanıyor olacağız. 
Bu aşamada kullanacağın rest api endpointlerini ve dökümantasyonlarını ben sana sağlıyor olacağım.
--------------------------------------

- 'dio'  kütüphanesi kullanarak verilerin api üzerinden alınması ve gönderilmesi
- uygulamaya kullanıcı girişi ekranının ve authentication mekanizmalarının eklenmesi

4. Aşama

Bu aşamada uygulama mimarisi ve state management üzerine odaklanıyor olacağız. 
Öncelikle flutter'da önemli bir state management yöntemlerindne birisi olan 'bloc pattern' üzerine yoğunlaşacağız. 
--------------------------------------

- mevcut uygulamanın bloc pattern üzerinden geliştirilmesi
- mevcut api iletişim katmanının 'repoistory pattern' ve 'dependency injection' yöntemleri ile abstrack classlarının ve imeplementasyonlarını oluşturulması

