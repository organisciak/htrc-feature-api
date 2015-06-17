var mongoose = require('mongoose');

// Define Volume Schema
var volumeSchema = mongoose.Schema({
    _id: String,
    metadata: {
        dateCreated: Date,
        handleUrl: String,
        htBibUrl: String,
        imprint: String,
        language: String,
        oclc: Number,
        pubDate: Date,
        schemaVersion: Number,
        title: String
    },
    features: {
        schemaVersion: Number,
        dateCreated: Date,
        pageCount: Number,
        pages: [
        {
            seq: Number,
            languages:[{lang:String, prob:Number}],
            sections: [
            {
                section: String, // i.e. body/header/footer
                emptyLineCount: Number,
                lineCount: Number,
                sentenceCount: Number,
                tokenCount: Number,
                tokenPosCount:[
                { 
                    token: String,
                    counts: [{
                        pos: String,
                        count: Number
                    }]
                }],
            }]
        }]
    }
}); 

// Create Model and Export

var Volume = mongoose.model('volume', volumeSchema);

module.exports = Volume;

