# Chapter 1

## Basics

```mongodb
use book
```

```mongodb
db.towns.insert({
    name: "New York",
    population: 22200000,
    lastCensus: ISODate("2016-07-01"),
    famousFor: [ "the MOMA", "food", "Derek Jeter" ],
    mayor : {
    name : "Bill de Blasio",
    party : "D"
    }
})
```

```mongodb
function insertCity(
    name, population, lastCensus,
    famousFor, mayorInfo
) {
    db.towns.insert({
    name: name,
    population: population,
    lastCensus: ISODate(lastCensus),
    famousFor: famousFor,
    mayor : mayorInfo
    });
}
```

```mongdb
insertCity("Punxsutawney", 6200, '2016-01-31',
["Punxsutawney Phil"], { name : "Richard Alexander" }
)
insertCity("Portland", 582000, '2016-09-20',
["beer", "food", "Portlandia"], { name : "Ted Wheeler", party : "D" }
)
```

```mongodb
db.towns.find({ _id : ObjectId("5fe664f54329956b4004eba9") }, { name : 1 })
```

```mongodb
db.towns.find(
{ name : /^P/, population : { $lt : 10000 } },
{ _id: 0, name : 1, population : 1 }
)
```

```mongodb
var population_range = {
$lt: 1000000,
$gt: 10000
}
db.towns.find(
{ name : /^P/, population : population_range },
{ name: 1 }
)
```

```mongodb
db.towns.find(
{ famousFor : { $nin : ['food', 'beer'] } },
{ _id : 0, name : 1, famousFor : 1 }
)
```

```mongodb
 db.towns.find(
{ 'mayor.party' : 'D' },
{ _id : 0, name : 1, mayor : 1 }
)
```

```mongodb
db.countries.insert({
_id : "us",
name : "United States",
exports : {
foods : [
{ name : "bacon", tasty : true },
{ name : "burgers" }
]
}
})
db.countries.insert({
_id : "ca",
name : "Canada",
exports : {
foods : [
{ name : "bacon", tasty : false },
{ name : "syrup", tasty : true }
]
}
})
db.countries.insert({
_id : "mx",
name : "Mexico",
exports : {
foods : [{
name : "salsa",
tasty : true,
condiment : true
}]
}
})
```

```mongodb
db.countries.find(
{
'exports.foods' : {
$elemMatch : {
name : 'bacon',
tasty : true
}
}
},
{ _id : 0, name : 1 }
)
```

```mongodb
db.countries.find(
{
$or : [
{ _id : "mx" },
{ name : "United States" }
]
},
{ _id:1 }
)
```

### Update

```mongodb
db.towns.update(
{ _id : ObjectId("5fe664fd4329956b4004ebaa") },
{ $set : { "state" : "OR" } }
);
db.towns.update(
{ _id : ObjectId("5fe664fd4329956b4004ebaa") },
{ $inc : { population : 1000} }
)
```

### References

```mongodb
db.towns.update(
{ _id : ObjectId("59094292afbc9350ada6b808") },
{ $set : { country: { $ref: "countries", $id: "us" } } }
)
```
