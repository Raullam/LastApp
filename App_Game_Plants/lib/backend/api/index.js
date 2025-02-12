const express = require('express')
const mysql = require('mysql2')
const bodyParser = require('body-parser')
const cors = require('cors')
require('dotenv').config()

const app = express()
const PORT = process.env.PORT || 3000

// Configuració de middleware
app.use(cors())
app.use(bodyParser.json())

// Servir arxius estatics desde la carpeta d'imatges
app.use('/imagenes', express.static('ruta_a_la_carpeta_de_imagenes'))

// Configuració de la base de dadess
const db = mysql.createConnection({
  host: 'localhost',
  user: 'test',
  password: 'test',
  database: 'appplantes2',
})

// Conexió a la base de dades
db.connect((err) => {
  if (err) {
    console.error('Error al conectar amb la base de dades:', err.message)
  } else {
    console.log('Conectat a la base de dades')
  }
})
// Obtenim totes les plantes
app.get('/plantas', (req, res) => {
  const query = 'SELECT * FROM plantas'
  db.query(query, (err, results) => {
    if (err) {
      return res.status(500).json({ error: err.message })
    }
    res.json(results)
  })
})

// Obtenim totes les plantes d'un usuari específic
app.get('/usuaris/:id/plantas', (req, res) => {
  const { id } = req.params
  const query = 'SELECT * FROM plantas WHERE usuari_id = ?'
  db.query(query, [id], (err, results) => {
    if (err) {
      return res.status(500).json({ error: err.message })
    }
    res.json(results)
  })
})

// Obtenim una planta per ID
app.get('/plantas/:id', (req, res) => {
  const { id } = req.params
  const query = 'SELECT * FROM plantas WHERE id = ?'
  db.query(query, [id], (err, result) => {
    if (err) {
      return res.status(500).json({ error: err.message })
    }
    if (result.length === 0) {
      return res.status(404).json({ error: 'Planta no trobada' })
    }
    res.json(result[0])
  })
})

// Crea una nova planta
app.post('/plantas', (req, res) => {
  const {
    usuari_id,
    nom,
    tipus,
    nivell,
    atac,
    defensa,
    velocitat,
    habilitat_especial,
    energia,
    estat,
    raritat,
    imatge,
  } = req.body

  const query = `
            INSERT INTO plantas 
            (usuari_id, nom, tipus, nivell, atac, defensa, velocitat, habilitat_especial, energia, estat, raritat, imatge) 
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`

  db.query(
    query,
    [
      usuari_id,
      nom,
      tipus,
      nivell || 0,
      atac || 0,
      defensa || 0,
      velocitat || 0,
      habilitat_especial,
      energia || 100,
      estat || 'actiu',
      raritat || 'comú',
      imatge,
    ],
    (err, result) => {
      if (err) {
        return res.status(500).json({ error: err.message })
      }
      res.status(201).json({
        id: result.insertId,
        usuari_id,
        nom,
        tipus,
        nivell: nivell || 1,
        atac: atac || 10,
        defensa: defensa || 10,
        velocitat: velocitat || 5,
        habilitat_especial,
        energia: energia || 100,
        estat: estat || 'actiu',
        raritat: raritat || 'comú',
        imatge,
      })
    },
  )
})

// Actualizar una planta
app.put('/plantas/:id', (req, res) => {
  const { id } = req.params
  const {
    nom,
    tipus,
    nivell,
    atac,
    defensa,
    velocitat,
    habilitat_especial,
    energia,
    estat,
    raritat,
    imatge,
  } = req.body

  const query = `
            UPDATE plantas 
            SET 
              nom = ?, 
              tipus = ?, 
              nivell = ?, 
              atac = ?, 
              defensa = ?, 
              velocitat = ?, 
              habilitat_especial = ?, 
              energia = ?, 
              estat = ?, 
              raritat = ?, 
              imatge = ?, 
              ultima_actualitzacio = CURRENT_TIMESTAMP 
            WHERE id = ?`

  db.query(
    query,
    [
      nom,
      tipus,
      nivell,
      atac,
      defensa,
      velocitat,
      habilitat_especial,
      energia,
      estat,
      raritat,
      imatge,
      id,
    ],
    (err, result) => {
      if (err) {
        return res.status(500).json({ error: err.message })
      }
      res.json({ message: 'Planta actualitzada correctament' })
    },
  )
})

// Eliminar una planta
app.delete('/plantas/:id', (req, res) => {
  const { id } = req.params
  const query = 'DELETE FROM plantas WHERE id = ?'
  db.query(query, [id], (err, result) => {
    if (err) {
      return res.status(500).json({ error: err.message })
    }
    res.json({ message: 'Planta eliminada correctament' })
  })
})

/////////////////////////////////////////////////////////////  USUARIS  //////////////////////////////////////////////////////////////////

// Obtenim tots els usuaris
app.get('/usuaris', (req, res) => {
  const query = 'SELECT * FROM usuaris'
  db.query(query, (err, results) => {
    if (err) {
      return res.status(500).json({ error: err.message })
    }
    res.json(results)
  })
})

// Obtenim un usuari per ID
app.get('/usuaris/:id', (req, res) => {
  const { id } = req.params
  const query = 'SELECT * FROM usuaris WHERE id = ?'
  db.query(query, [id], (err, result) => {
    if (err) {
      return res.status(500).json({ error: err.message })
    }
    if (result.length === 0) {
      return res.status(404).json({ error: 'Usuari no trobat' })
    }
    res.json(result[0])
  })
})

// Crea un nou usuari
app.post('/usuaris', (req, res) => {
  const {
    nom,
    correu,
    contrasenya,
    edat,
    nacionalitat,
    codiPostal,
    imatgePerfil,
  } = req.body
  const query =
    'INSERT INTO usuaris (nom, correu, contrasenya, edat, nacionalitat, codiPostal, imatgePerfil) VALUES (?, ?, ?, ?, ?, ?, ?)'
  db.query(
    query,
    [nom, correu, contrasenya, edat, nacionalitat, codiPostal, imatgePerfil],
    (err, result) => {
      if (err) {
        return res.status(500).json({ error: err.message })
      }
      res.status(201).json({
        id: result.insertId,
        nom,
        correu,
        contrasenya,
        edat,
        nacionalitat,
        codiPostal,
        imatgePerfil,
      })
    },
  )
})

// Actualizar un usuario
app.put('/usuaris/:id', (req, res) => {
  const { id } = req.params
  const {
    nom,
    correu,
    contrasenya,
    edat,
    nacionalitat,
    codiPostal,
    imatgePerfil,
  } = req.body
  const query =
    'UPDATE usuaris SET nom = ?, correu = ?, contrasenya = ?, edat = ?, nacionalitat = ?, codiPostal = ?, imatgePerfil = ? WHERE id = ?'
  db.query(
    query,
    [
      nom,
      correu,
      contrasenya,
      edat,
      nacionalitat,
      codiPostal,
      imatgePerfil,
      id,
    ],
    (err, result) => {
      if (err) {
        return res.status(500).json({ error: err.message })
      }
      res.json({ message: 'Usuari actualizat correctament' })
    },
  )
})

// Eliminar un usuario
app.delete('/usuaris/:id', (req, res) => {
  const { id } = req.params
  const query = 'DELETE FROM usuaris WHERE id = ?'
  db.query(query, [id], (err, result) => {
    if (err) {
      return res.status(500).json({ error: err.message })
    }
    res.json({ message: 'Usuari eliminat correctament' })
  })
})

// Buscar un usuari per correo
app.get('/usuaris/correu/:correu', (req, res) => {
  const { correu } = req.params // Obtenemos el correo de los parámetros de la URL
  const query = 'SELECT * FROM usuaris WHERE correu = ?'

  db.query(query, [correu], (err, result) => {
    if (err) {
      return res.status(500).json({ error: err.message })
    }
    if (result.length === 0) {
      return res.status(404).json({ error: 'Usuari no trobat' })
    }
    res.json(result[0]) // Devolvemos el usuario encontrado
  })
})

app.get('/items', (req, res) => {
  const query = 'SELECT * FROM items' // O modifica segons la consulta que desitgis
  db.query(query, (err, results) => {
    if (err) {
      return res.status(500).json({ error: err.message })
    }
    res.json(results)
  })
})

// Inicia el servidor
app.listen(3000, '0.0.0.0', () => {
  console.log('Servidor escoltant a totes les interfícies')
})
