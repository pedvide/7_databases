# Chapter 3: Replica Sets, Sharding, GeoSpatial, and GridFS

```bash
docker run --name mongo-server-1 -d -p 27011:27017 --net mongo mongo --replSet book
docker run --name mongo-server-2 -d -p 27012:27017 --net mongo mongo --replSet book
docker run --name mongo-server-2 -d -p 27013:27017 --net mongo mongo --replSet book
```

```bash
docker run -it --net mongo --rm mongo mongo --host mongo-server-1
```

```js
rs.initiate({
  _id: "book",
  members: [
    { _id: 1, host: "mongo-server-1:27017" },
    { _id: 2, host: "mongo-server-2:27017" },
    { _id: 3, host: "mongo-server-3:27017" },
  ],
});
rs.status().ok;
```

```bash
docker run --name mongo-server-shard-1 -d -p 27014:27017 --net mongo mongo mongod --shardsvr
docker run --name mongo-server-shard-2 -d -p 27015:27017 --net mongo mongo mongod --shardsvr
docker run --name mongo-server-shard-config -d -p 27016:27017 --net mongo mongo  \
  mongod --configsvr --replSet configSet
```
