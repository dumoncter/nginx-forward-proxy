# 🚀 NGINX Forward Proxy для обхода блокировок

Безопасный и производительный прокси-сервер на базе NGINX с поддержкой HTTP CONNECT туннелей для обхода блокировок и доступа к заблокированному контенту, включая YouTube.

## ✨ Особенности

- 🔒 **Безопасность**: Rate limiting, connection limits, блокировка опасных путей
- ⚡ **Производительность**: Оптимизированная конфигурация NGINX с лучшими практиками
- 🌐 **Совместимость**: Поддержка HTTP и HTTPS через CONNECT туннели
- 🛡️ **Защита**: Блокировка доступа к внутренним сервисам и потенциально опасным ресурсам
- 📊 **Мониторинг**: Подробное логирование и health check endpoint

## 🚢 Быстрый запуск на Railway

1. **Деплой проекта**:
   ```bash
   git add .
   git commit -m "Add NGINX forward proxy for bypassing blocks"
   git push railway main
   ```

2. **Настройка переменных окружения в Railway**:
   - `PORT`: `8080` (порт Railway)
   - `PROXY_AUTH_ENABLED`: `false` (для публичного доступа)
   - `ALLOWED_IPS`: `0.0.0.0/0` (разрешить все IP)
   - `RATE_LIMIT`: `1000` (запросов в секунду)
   - `TIMEOUT`: `30s`

## 📱 Использование прокси

### Получение URL сервиса
После деплоя в Railway получите ваш домен (например: `your-proxy.railway.app`)

### Настройка в браузере

#### Firefox
1. Откройте `about:config`
2. Найдите `network.proxy.http` и установите значение вашего прокси сервера
3. Установите `network.proxy.http_port` в `8080`
4. Установите `network.proxy.ssl` и `network.proxy.ssl_port` аналогично
5. Установите `network.proxy.type` в `1`

#### Chrome/Chromium
Расширение: [Proxy SwitchyOmega](https://chrome.google.com/webstore/detail/proxy-switchyomega/padekgcemlokbadohgkifijomclgjgif)

### Настройка в мобильных устройствах

#### Android
1. Настройки → Сеть и интернет → Wi-Fi
2. Выберите сеть → Изменить сеть → Расширенные настройки
3. Тип прокси: Ручной
4. Имя хоста прокси: ваш Railway домен
5. Порт прокси: 8080

#### iOS
1. Настройки → Wi-Fi
2. Выберите сеть → Настроить прокси
3. Ручной → Сервер: ваш Railway домен, Порт: 8080

### Примеры использования с curl

```bash
# HTTP запрос через прокси
curl -x http://your-proxy.railway.app:8080 http://httpbin.org/get

# HTTPS запрос через прокси
curl -x http://your-proxy.railway.app:8080 -k https://httpbin.org/get

# YouTube через прокси
curl -x http://your-proxy.railway.app:8080 -k https://www.youtube.com/watch?v=dQw4w9WgXcQ
```

## 🔧 Конфигурация

### Переменные окружения

| Переменная | Значение по умолчанию | Описание |
|------------|----------------------|----------|
| `PORT` | `8080` | Порт для прослушивания |
| `RATE_LIMIT` | `1000` | Максимум запросов в секунду |
| `TIMEOUT` | `30s` | Таймаут соединения |
| `ALLOWED_IPS` | `0.0.0.0/0` | Разрешенные IP адреса |

### Мониторинг

- **Health check**: `GET https://your-proxy.railway.app/health`
- **Логи**: Доступны в Railway dashboard

## 🔐 Безопасность

Проект включает множество мер безопасности:

- **Rate Limiting**: Ограничение количества запросов
- **Connection Limits**: Ограничение количества соединений на IP
- **Блокировка опасных путей**: Запрет доступа к localhost, внутренним сетям
- **Безопасные заголовки**: HSTS, CSP, X-Frame-Options и др.
- **Скрытие версии сервера**: Удаление информации о сервере из ответов

## 🌐 Поддерживаемые протоколы

- ✅ HTTP (порт 80)
- ✅ HTTPS (порт 443 через CONNECT туннель)
- ❌ SOCKS протоколы (требуют дополнительной настройки)

## 🚨 Важные предупреждения

⚠️ **Используйте только для легальных целей**
⚠️ **Не используйте для нарушения законов вашей страны**
⚠️ **Производительность зависит от вашего тарифного плана Railway**
⚠️ **Бесплатный тариф Railway имеет ограничения по трафику**

## 🛠 Технические детали

| Компонент | Версия |
|-----------|--------|
| Базовый образ | dominikbechstein/nginx-forward-proxy:latest |
| NGINX модуль | ngx_http_proxy_connect_module |
| Платформа | Alpine Linux |

## 📝 Лицензия

Проект основан на [dominikbechstein/nginx-forward-proxy](https://github.com/dominikbechstein/nginx-forward-proxy) с улучшениями для production использования на Railway.
