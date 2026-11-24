# Запуск в Kali Linux под VirtualBox

На ПК с Windows папка проекта добавлена в запущенную VM как общая папка для чтения с именем `elk-soc-lab`. Она действует до выключения VM. Если машина уже перезапущена, добавь папку снова через настройки VirtualBox либо передай проект другим способом.

В терминале Kali установи Docker и Compose из репозитория Kali, если их ещё нет:

```sh
sudo apt update
sudo apt install docker.io docker-compose
sudo systemctl start docker
sudo docker compose version
```

Подключи общую папку и скопируй проект на диск VM:

```sh
sudo mkdir -p /mnt/elk-soc-lab
sudo mount -t vboxsf -o ro,uid="$(id -u)",gid="$(id -g)" elk-soc-lab /mnt/elk-soc-lab
mkdir -p ~/elk-soc-lab
cp -R /mnt/elk-soc-lab/compose.yaml /mnt/elk-soc-lab/pipeline /mnt/elk-soc-lab/samples /mnt/elk-soc-lab/scripts ~/elk-soc-lab/
cd ~/elk-soc-lab
sudo docker compose up -d
sudo sh scripts/verify.sh
```

Открой `http://127.0.0.1:5601` в браузере внутри Kali. Учётные данные для Kibana в данной конфигурации не предусмотрены. Сохрани NAT виртуальной машины без переадресации портов и используй только учебные данные.

Справка: [установка Docker в Kali](https://www.kali.org/docs/containers/installing-docker-on-kali/).
