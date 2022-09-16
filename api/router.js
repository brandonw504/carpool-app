const express = require('express')
const router = express.Router()
const ActiveDriver = require('/models/activeDriver')
const ActiveRider = require('/models/activeRider')

async function getActiveDriver(req, res, next) {
    let activeDriver
    try {
        activeDriver = await ActiveDriver.findById(req.params.id)
        if (activeDriver == null) {
            return res.status(404).json({ message: 'Cannot find active driver' })
        }
    } catch (err) {
        return res.status(500).json({ message: err.message })
    }

    res.activeDriver = activeDriver
    next()
}

async function getActiveRider(req, res, next) {
    let activeRider
    try {
        activeRider = await ActiveRider.findById(req.params.id)
        if (activeRider == null) {
            return res.status(404).json({ message: 'Cannot find active rider' })
        }
    } catch (err) {
        return res.status(500).json({ message: err.message })
    }

    res.activeRider = activeRider
    next()
}

// get all active drivers
router.get('/activeDrivers', async (req, res) => {
    try {
        const activeDrivers = await ActiveDriver.find()
        res.json(activeDrivers) // automatically set status code to 200
    } catch (err) {
        res.status(500).json({ message: err.message })
    }
})

// get all active riders
router.get('/activeRiders', async (req, res) => {
    try {
        const activeRiders = await ActiveRider.find()
        res.json(activeRiders) // automatically set status code to 200
    } catch (err) {
        res.status(500).json({ message: err.message })
    }
})

// get one active driver
router.get('/activeDriver/:id', getActiveDriver, (req, res) => {
    res.json(res.activeDriver)
})

// get one active rider
router.get('/activeRider/:id', getActiveRider, (req, res) => {
    res.json(res.activeRider)
})

// create active driver
router.post('/createActiveDriver', async (req, res) => {
    const activeDriver = new ActiveDriver({
        id: req.body.id,
        source: [parseFloat(req.body.source[0]), parseFloat(req.body.source[1])],
        destination: [parseFloat(req.body.destination[0]), parseFloat(req.body.destination[1])]
    })

    try {
        const newActiveDriver = await activeDriver.save()
        res.status(201).json(newActiveDriver)
    } catch (err) {
        res.status(400).json({ message: err.message })
    }
})

// create active rider
router.post('/createActiveRider', async (req, res) => {
    const activeRider = new ActiveRider({
        id: req.body.id,
        source: [parseFloat(req.body.source[0]), parseFloat(req.body.source[1])],
        destination: [parseFloat(req.body.destination[0]), parseFloat(req.body.destination[1])]
    })

    try {
        const newActiveRider = await activeRider.save()
        res.status(201).json(newActiveRider)
    } catch (err) {
        res.status(400).json({ message: err.message })
    }
})

// update active driver
router.patch('/updateActiveDriver/:id', getActiveDriver, async (req, res) => {
    if (req.body.id != null) {
        res.activeDriver.id = req.body.id
    }
    if (req.body.source != null) {
        res.activeDriver.source = req.body.source
    }
    if (req.body.destination != null) {
        res.activeDriver.destination = req.body.destination
    }

    try {
        const updatedActiveDriver = await res.activeDriver.save()
        res.json(updatedActiveDriver)
    } catch (err) {
        res.status(400).json({ message: err.message })
    }
})

// update active rider
router.patch('/updateActiveRider/:id', getActiveRider, async (req, res) => {
    if (req.body.id != null) {
        res.activeRider.id = req.body.id
    }
    if (req.body.source != null) {
        res.activeRider.source = req.body.source
    }
    if (req.body.destination != null) {
        res.activeRider.destination = req.body.destination
    }

    try {
        const updatedActiveRider = await res.activeRider.save()
        res.json(updatedActiveRider)
    } catch (err) {
        res.status(400).json({ message: err.message })
    }
})

// delete active driver
router.delete('/deleteActiveDriver/:id', getActiveDriver, async (req, res) => {
    try {
        await res.activeDriver.remove()
        res.json({ message: 'Deleted active driver' })
    } catch (err) {
        res.status(500).json({ message: err.message })
    }
})

// delete active rider
router.delete('/deleteActiveRider/:id', getActiveRider, async (req, res) => {
    try {
        await res.activeRider.remove()
        res.json({ message: 'Deleted active rider' })
    } catch (err) {
        res.status(500).json({ message: err.message })
    }
})

module.exports = router