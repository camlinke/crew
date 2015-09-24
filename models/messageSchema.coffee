mongoose = require 'mongoose'

messageSchema = mongoose.Schema {
    created: Date,
    content: String,
    username: String,
    group: String
}

module.exports = mongoose.model 'Message', messageSchema