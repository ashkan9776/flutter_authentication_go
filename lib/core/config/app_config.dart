/// آدرس پیش‌فرض Go backend
/// روی شبیه‌ساز اندروید: 10.0.2.2
/// روی دستگاه واقعی (مثلاً تو شبکه لوکال) می‌تونی IP سیستم رو بذاری.
const String kDefaultApiBaseUrl =
    String.fromEnvironment('API_BASE_URL', defaultValue: 'http://10.0.2.2:8080');
