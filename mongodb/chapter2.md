# Chapter 2

## Indices

```js
populatePhones = function (area, start, stop) {
  for (var i = start; i < stop; i++) {
    var country = 1 + ((Math.random() * 8) << 0);
    var num = country * 1e10 + area * 1e7 + i;
    var fullNumber = "+" + country + " " + area + "-" + i;
    db.phones.insert({
      _id: num,
      components: {
        country: country,
        area: area,
        prefix: (i * 1e-4) << 0,
        number: i,
      },
      display: fullNumber,
    });
    print("Inserted number " + fullNumber);
  }
  print("Done!");
};
populatePhones(800, 5550000, 5650000);
```

Check executionTimeMillisEstimate

```js
db.phones.find({ display: "+1 800-5650001" }).explain("executionStats")
  .executionStats;
```

```js
db.phones.ensureIndex({ display: 1 }, { unique: true, dropDups: true });
db.getCollectionNames().forEach(function (collection) {
  print("Indexes for the " + collection + " collection:");
  printjson(db[collection].getIndexes());
});
```

Check executionTimeMillisEstimate (and totalDocsExamined), it's lower now.

```js
db.phones.find({ display: "+1 800-5650001" }).explain("executionStats")
  .executionStats;
```

```js
db.phones.ensureIndex({ "components.area": 1 }, { background: 1 });
db.phones.getIndexes();
```

## Aggregated Queries

```js
db.phones.count({ "components.number": { $gt: 5599999 } });
db.phones.distinct("components.number", {
  "components.number": { $lt: 5550005 },
});
```

Load data

```bash
docker run -it --rm --net mongo -v $(pwd)/mongoCities100000.js:/mongoCities100000.js mongo mongo -u root -p 1234 --host mongo-server book mongoCities100000.js
```

```js
db.cities.aggregate([
  {
    $match: {
      timezone: {
        $eq: "Europe/London",
      },
    },
  },
  {
    $group: {
      _id: "averagePopulation",
      avgPop: {
        $avg: "$population",
      },
    },
  },
  {
    $sort: {
      population: -1,
    },
  },
  {
    $project: {
      _id: 0,
      name: 1,
      population: 1,
    },
  },
]);
```

```js
db.cities.aggregate([
  {
    $match: {
      timezone: {
        $eq: "Europe/London",
      },
    },
  },
  {
    $sort: {
      population: -1,
    },
  },
  {
    $project: {
      _id: 0,
      name: 1,
      population: 1,
    },
  },
]);
```

## MapReduce

```js
distinctDigits = function (phone) {
  var number = phone.components.number + "",
    seen = [],
    result = [],
    i = number.length;
  while (i--) {
    seen[+number[i]] = 1;
  }
  for (var i = 0; i < 10; i++) {
    if (seen[i]) {
      result[result.length] = i;
    }
  }
  return result;
};
db.system.js.save({ _id: "distinctDigits", value: distinctDigits });
```

```js
map = function () {
  var digits = distinctDigits(this);
  emit(
    {
      digits: digits,
      country: this.components.country,
    },
    {
      count: 1,
    }
  );
};
reduce = function (key, values) {
  var total = 0;
  for (var i = 0; i < values.length; i++) {
    total += values[i].count;
  }
  return { count: total };
};
results = db.runCommand({
  mapReduce: "phones",
  map: map,
  reduce: reduce,
  out: "phones.report",
});
```
