db = new Mongo("mongo-server").getDB("blogger");
// db.auth("root", "1234")
printjson(db.articles.find())
