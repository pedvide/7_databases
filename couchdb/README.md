# couchdb

Create a database with docker:

```bash
docker run --name couchdb-server -d -p 5984:5984 -e COUCHDB_USER=admin -e COUCHDB_PASSWORD=1234 -v $(pwd)/db_data:/opt/couchdb/data couchdb
```
