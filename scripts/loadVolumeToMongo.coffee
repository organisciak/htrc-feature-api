argv = require('yargs')
      .usage('Usage: $0 --volume [filepath]')
      .demand(['volume'])
      .argv
mongoose = require 'mongoose'
path = require 'path'
async = require 'async'
_ = require 'underscore'

Volume = require '../models/volume'

# Load Volume JSON data
filepath = path.resolve(process.cwd(), argv.volume)
volumejson = require filepath

mongoose.connect('mongodb://localhost/features')
db = mongoose.connection
db.on('error', console.error.bind(console, 'connection error:'))

db.once('open', (callback) ->
  fixedVol = formatVolume(volumejson)
  volume = new Volume(volumejson)
  volume.save((err, res) ->
    if err then return console.error err
    console.log res
    mongoose.disconnect()
  )
)

formatVolume = (volume) ->
  # TODO make into async.parallel
  volume._id = volume.id
  delete volume.id
  volume.features.pages = _.map(volume.features.pages, formatPage)
  volume


formatTokenPosCount = (tokenList) ->
    _.map(tokenList, (poscounts, token) ->
      {
          token: token
          counts: _.map(poscounts, (count, pos) -> {pos:pos, count:count})
      }
    )

formatPage = (page) ->
  for val in ['emptyLineCount', 'tokenCount', 'lineCount', 'sentenceCount']
    delete page[val]
  # TODO convert to async.each flow
  page.languages = _.map(page.languages, (val) ->
    _.map(val, (prob,lang) ->
      {lang:lang, prob:prob}
    )
  )
  page.sections = []
  # TODO convert to async.each flow
  for section in ['header', 'body', 'footer']
    sec = page[section]
    sec.section = section
    sec.tokenPosCount = formatTokenPosCount(sec.tokenPosCount)
    page.sections.push sec
    delete page[section]
  page
