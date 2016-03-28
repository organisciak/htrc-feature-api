HTRC Feature API
=================

A demonstration of a MongoDB based api for FE.


## Importing volumes into Mongo

coffee scripts/loadVolumeToMongo.coffee --volume

## Querying

In mongo shell:

```
use features;
db.volumes.find({}, { 'metadata.title':1}).limit(5)
```

Try some of the queries in `searches.md`.
