const express = require('express')
const app = express()
const port = process.argv[2] || 8000
app.use(express.static('public'))
app.listen(port, () => {
  console.log(`Expressjs app listening on port ${port}`)
})
