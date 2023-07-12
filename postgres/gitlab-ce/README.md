# GitLab Postgresql
## export database

```bash
docker-compose exec gitlab bash 

su - gitlab-psql
pg_dump -U gitlab-psql -h /var/opt/gitlab/postgresql -d gitlabhq_production -f gitlab_backup.sql

```

# import database

```bash
psql -U gitlab -d gitlabhq_production -f gitlab_backup.sql
```