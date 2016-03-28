## Average Page Count

db.volumes.aggregate([{$project:{'features.pageCount':1}}, {$group:{_id:null, 'average': {$avg: '$features.pageCount'}}}])

## Sum all term frequencies

db.volumes.aggregate([{$match:{'features.pages.sections.section':'body', _id:/umn/}},{$project:{'features.pages.sections.tokenPosCount':1}},{$unwind:'$features.pages'},{$unwind:'$features.pages.sections'}, {$unwind:'$features.pages.sections.tokenPosCount'}, {$unwind:'$features.pages.sections.tokenPosCount.counts'}, {$group:{_id:'$features.pages.sections.tokenPosCount.token', count:{$sum:'$features.pages.sections.tokenPosCount.counts.count'}}}, {$match:{count:{$gte:2}}}, {$sort: {count:-1}}])
