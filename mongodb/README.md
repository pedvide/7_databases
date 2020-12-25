# mongodb

Create a database with docker:

```bash
docker network create mongo

docker run --name mongo-server -d -p 27017:27017 --net mongo -e MONGO_INITDB_ROOT_USERNAME=root -e MONGO_INITDB_ROOT_PASSWORD=1234 -e MONGO_INITDB_DATABASE=book -v $(pwd)/db_data:/data/db mongo
```

Then run commands:

```bash
docker run -it --rm --net mongo mongo mongo --host mongo-server book
```
