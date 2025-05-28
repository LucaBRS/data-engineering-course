const express = require('express');
const { BigQuery } = require('@google-cloud/bigquery');

const app = express();
const bigquery = new BigQuery();

app.get('/', async (req, res) => {
  try {
    const query = 'SELECT * FROM `test-cloud-run-firebase.test_bigquery.test_table` LIMIT 10';
    const [rows] = await bigquery.query({ query, location: 'EU' });
    res.json(rows);
  } catch (err) {
    console.error(err);
    res.status(500).send(`BigQuery error: ${err.message}`);
  }
});

const PORT = process.env.PORT || 8080;
app.listen(PORT, () => console.log(`Listening on port ${PORT}`));
