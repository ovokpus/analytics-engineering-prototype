# ae_prototype

This is the dbt project. The warehouse, the seed, and the trading desk are wired from the repository root.

Run the whole thing from there:

```bash
docker compose up --build
```

The desk is at [http://localhost:8501](http://localhost:8501) after `dbt run` and `dbt test` succeed.

How the models fit together, and how to rebuild after a SQL change, is in the [root README](../README.md). What has to happen before this is a real environment is in [PRODUCTIONIZING.md](../PRODUCTIONIZING.md).

Targets:

- `local` is Postgres, used by Docker Compose.
- `dev` is BigQuery. It stays the default if you run dbt by hand with GCP credentials and no `DBT_TARGET`.
