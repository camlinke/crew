mongoose = require 'mongoose'

groupSchema = mongoose.Schema {
    created: Date,
    endDate: Date,
    groupName: String,
    password: String
}

module.exports = mongoose.model 'Group', groupSchema