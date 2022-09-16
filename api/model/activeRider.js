const mongoose = require('mongoose')

const activeRider = new mongoose.Schema({
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

module.exports = mongoose.model('ActiveRider')