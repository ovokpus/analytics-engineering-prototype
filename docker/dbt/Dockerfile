FROM python:3.11-slim-bookworm

ENV PYTHONDONTWRITEBYTECODE=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1 \
    DBT_PROFILES_DIR=/root/.dbt \
    DBT_SEND_ANONYMOUS_USAGE_STATS=false \
    DO_NOT_TRACK=1

RUN apt-get update \
    && apt-get install -y --no-install-recommends git libpq5 \
    && rm -rf /var/lib/apt/lists/* \
    && pip install --no-cache-dir "dbt-core==1.9.1" "dbt-postgres==1.9.1"

WORKDIR /usr/app
COPY ae_prototype /usr/app/ae_prototype
COPY docker/dbt/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
