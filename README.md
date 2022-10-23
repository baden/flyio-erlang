## How to start

    flyctl deploy

Yeah so easy!

## How to use

    nc weathered-fog-9977.fly.dev 5555

## Local testing

1. Setup Docker and Docker desktop
2. Build image
    docker build -t erl_fenix_auto .
3. Run image
    docker run -it --rm -p 8080:8080 -t erl_fenix_auto
4. Open web browser on http://localhost:8080


# Ще спробуємо Google Cloud
    
    https://www.youtube.com/watch?v=LRfraoVZDDg

В двох словах. Я зробив:

    gcloud projects create erl-fenix-auto
    gcloud config set project erl-fenix-auto
    gcloud config set builds/use_kaniko True
    gcloud builds submit --tag gcr.io/erl_fenix_auto/erl_fenix_auto

Образ собрался сюда:
https://console.cloud.google.com/gcr/images/erl-fenix-auto?referrer=search&project=erl-fenix-auto

Що круто, якшо в налаштуваннях переключити з Private на Public, то образ можна визивати звідки завгодно просто ввевши:

    docker run -it --rm -p 8080:8080 gcr.io/erl_fenix_auto/erl_fenix_auto


Далі запускаємо його тут: https://console.cloud.google.com/run/

Йохуу! Працює: https://erl-fenix-auto-y7sbzbwqwq-ez.a.run.app/

Потестував швидкість. Ну таке. Для отримання гарних показників, треба дозволяти запускати багато інстансів, а це буде дуууже дорого

    wrk -t8 -c256 -d60s https://erl-fenix-auto-y7sbzbwqwq-ez.a.run.app/
