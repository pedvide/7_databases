# Postgres

Create a database with docker:

```bash
 docker run -d -p 5432:5432 -v $(pwd)/db_data:/var/lib/postgresql/data --name postgres -e POSTGRES_PASSWORD=1234 postgres
```

Create a database called 7dbs:

```bash
docker exec -it postgres createdb -U postgres 7dbs
```

Then run commands using the vscode extension SQLTools or via the command promp:

```bash
docker exec -it postgres psql -U postgres 7dbs
```
