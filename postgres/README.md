# pgloader

## postgres cli

```bash
docker-compose exec postgres bash
psql -U gitlab gitlabhq_production_backup
SELECT pg_size_pretty(pg_database_size(current_database())) AS database_size;
```

## Reference link
1. [How To Migrate a MySQL Database to PostgreSQL Using pgLoader](https://www.digitalocean.com/community/tutorials/how-to-migrate-mysql-database-to-postgres-using-pgloader)