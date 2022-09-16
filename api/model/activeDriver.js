const mongoose = require('mongoose')

const activeDriver = new mongoose.Schema({
    id: {
        type: String,
        required: true
    },
    source: {
        type: Array,
        required: true
    },
    destination: {
        type: Array,
        required: true
    }
})

module.exports = mongoose.model('ActiveDriver')