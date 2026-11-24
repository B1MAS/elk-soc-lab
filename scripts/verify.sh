#!/bin/sh
set -eu
cd "$(dirname "$0")/.."

query() {
  docker compose exec -T elasticsearch curl -fsS "$@"
}

base=http://localhost:9200/soc-lab-events
attempt=0
while :; do
  total=$(query "$base/_count?filter_path=count" 2>/dev/null || true)
  [ "$total" = '{"count":3}' ] && break
  attempt=$((attempt + 1))
  if [ "$attempt" -ge 60 ]; then
    printf 'Ожидалось 3 события. Последний ответ: %s\n' "$total" >&2
    docker compose logs --tail=30 logstash >&2
    exit 1
  fi
  sleep 3
done

failed=$(query --get --data-urlencode 'q=event.outcome:failure' "$base/_count?filter_path=count")
[ "$failed" = '{"count":2}' ] || { printf 'Неожиданный результат фильтра: %s\n' "$failed" >&2; exit 1; }
printf 'Всего событий: 3. Неудачных входов: 2.\n'
