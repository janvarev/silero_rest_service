# syntax=docker/dockerfile:1
FROM --platform=$BUILDPLATFORM curlimages/curl:7.85.0 as silero-downloader

WORKDIR /home/downloader/models

RUN curl https://models.silero.ai/models/tts/ru/v3_1_ru.pt -o ./silero_model.pt

FROM python:3.9-slim-bullseye

# Я в душе не чаю, зачем нужна следующая команда, но без неё вызов pip install на архитектуре linux/arm64 падает.
# Связаные ссылки:
# https://webcache.googleusercontent.com/search?q=cache:R6EG8IVigbMJ:https://pythontechworld.com/issue/pypa/pip/11435&cd=1&hl=ru&ct=clnk&gl=ru
# О да! Решение, найденное в удалённой ветке какого-то форума!
# https://github.com/hofstadter-io/hof/commit/838e8bbe2171ba8b9929b0ffa812c0f1ed61e975#diff-185fff912be701240e6e971b5548217a2027904efe9e365728169da65eb4983b

#RUN ln -s /bin/uname /usr/local/bin/uname

# https://github.com/docker/buildx/issues/495#issuecomment-995503425

# RUN ln -s /usr/bin/dpkg-split /usr/sbin/dpkg-split
# RUN ln -s /usr/bin/dpkg-deb /usr/sbin/dpkg-deb
# RUN ln -s /bin/rm /usr/sbin/rm
# RUN ln -s /bin/tar /usr/sbin/tar

# RUN --mount=type=cache,target=/var/cache,sharing=locked apt update && apt install -y libportaudio2

RUN groupadd --gid 1001 python && useradd --create-home python --uid 1001 --gid python
USER python:python
WORKDIR /home/python

COPY ./requirements.txt ./requirements.txt
RUN --mount=type=cache,target=/home/python/.cache,uid=1001,gid=1001 pip install -r ./requirements.txt

COPY run_webapi.py ./run_webapi.py

COPY --link --from=silero-downloader /home/downloader/models/silero_model.pt ./silero_model.pt

EXPOSE 5010

ENTRYPOINT ["python", "run_webapi.py"]
