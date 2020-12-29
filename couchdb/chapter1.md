# Chapter 1

```bash
export COUCH_ROOT_URL=http://localhost:5984
curl ${COUCH_ROOT_URL} | jq

curl -s -u admin:1234 "${COUCH_ROOT_URL}/music" | jq

curl -s -u admin:1234 "${COUCH_ROOT_URL}/music/8e515defc3da1bc5b4503973ab0000e6" | jq


curl -s -u admin:1234 -i -XPOST "${COUCH_ROOT_URL}/music/" \
-H "Content-Type: application/json" \
-d '{ "name": "Wings" }'

curl -s -u admin:1234 -i -XPUT \
"${COUCH_ROOT_URL}/music/8e515defc3da1bc5b4503973ab00537d" \
-H "Content-Type: application/json" \
-d '{
    "_id": "8e515defc3da1bc5b4503973ab00537d",
    "_rev": "1-2fe1dd1911153eb9df8460747dfe75a0",
    "name": "Wings",
    "albums": ["Wild Life", "Band on the Run", "London Town"]
}'

curl -s -u admin:1234 -i -XDELETE \
"${COUCH_ROOT_URL}/music/8e515defc3da1bc5b4503973ab00537d" \
-H "If-Match: 2-17e4ce41cd33d6a38f04a8452d5a860b"

```

## Homework

### 1

```bash
curl -s -u admin:1234 -i -XPUT \
"${COUCH_ROOT_URL}/music/123456" \
-H "Content-Type: application/json" \
-d '{
    name": "new doc",
    "albums": ["asd"]
}'
```

### 2

```bash
curl -s -u admin:1234 -XPUT "${COUCH_ROOT_URL}/newdb"

curl -s -u admin:1234 -XDELETE "${COUCH_ROOT_URL}/newdb"
```

### 3

```bash
curl -s -u admin:1234 -i -XPUT \
"${COUCH_ROOT_URL}/music/234567" \
-H "Content-Type: application/json" \
-d '{}'

echo "Test file to be an attachment in CouchDB" > file.txt

curl -s -u admin:1234 -i -XPUT \
"${COUCH_ROOT_URL}/music/234567/file.txt?rev=1-967a00dff5e02add41819138abb3284d" \
-H "Content-Type: text/plain;charset=UTF-8" \
--data-binary @file.txt

curl -s -u admin:1234 -XGET "${COUCH_ROOT_URL}/music/234567/file.txt?rev=2-cbfdc29ce7b75337ee71977a0ce264b0"
```
