#!/bin/sh
set -eu

src=$(CDPATH= cd -- "$(dirname "$0")/.." && pwd)
dst="$HOME/elk-soc-lab"

if ! docker compose version >/dev/null 2>&1; then
  sudo apt-get update
  sudo apt-get install -y docker.io docker-compose
fi
sudo systemctl start docker
mkdir -p "$dst"
cp -R "$src/compose.yaml" "$src/pipeline" "$src/samples" "$src/scripts" "$dst/"
cd "$dst"
sudo docker compose config --quiet
sudo docker compose up -d
sudo sh scripts/verify.sh
printf 'Kibana в браузере Kali: http://127.0.0.1:5601\n'
