# API WEB для TTS рендера WAV-файлов через модель silero

Для запуска запустите run_webapi.py.

Доки и тестовый запуск доступен по адресу: `http://127.0.0.1:5010/docs`

О модели silero здесь: https://github.com/snakers4/silero-models (используется v3_1_ru, но вы можете подложить любую через указание файла silero_model.pt)

## Установка через Докер

Относительно свежая версия доступна в виде Docker-образа (для linux/amd64) и может быть запущена
следующей командой:

```shell
docker run -it --publish 5010:5010 \
  janvarev/silero_rest_service:latest
```

Доки и тестовый запуск доступен по адресу: `http://127.0.0.1:5010/docs`
