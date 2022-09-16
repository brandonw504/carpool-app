const config = require('/config')
const express = require('express')
const mongoose = require ('mongoose')
const Pusher = require('pusher')
const app = express()

mongoose.connect(config["mongoose"], { useNewUrlParser: true })
const db = mongoose.connection
db.on('error', (error) => console.error(error))
db.once('error', (error) => console.error(error))

app.use(express.json())

const router = require('/router')
app.use('/router', router)

const pusher = new Pusher(config["pusher"]);

// pusher.trigger("my-channel", "my-event", {
//     message: "hello world"
// });

app.listen(3000, function() {
    console.log('App listening on port 3000!')
});