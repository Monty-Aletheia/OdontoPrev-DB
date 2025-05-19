import express from 'express'
import cors from 'cors'
import connectToDatabase from './src/util/db'
import routes from './src/routes/routes'

const app = express()

app.use(cors())

app.use(express.json())

app.use(express.urlencoded({ extended: true }))
 
routes(app)

const PORT = process.env.PORT || 3000

const startServer = async () => {
  try {
    await connectToDatabase()
    app.listen(PORT, () => {
      console.log(`Server is running on port ${PORT}`)
    })
  } catch (error) {
    console.error('Error starting server:', error)
  }
}

startServer()