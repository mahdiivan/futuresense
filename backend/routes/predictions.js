const express = require('express');
const router  = express.Router();
const { exec } = require('child_process');
const path    = require('path');

router.get('/', (req, res) => {
  const ticker = req.query.ticker;
  if (!ticker) {
    return res.status(400).json({ error: "Missing ?ticker=" });
  }

  // point this at your api.py
  const scriptPath = path.resolve(__dirname, '../../ml-models/stock_prediction/api.py');
  // Railway’s Python is on `python`, not python3
  const pythonCmd = process.env.PYTHON || 'python';
  const cmd       = `"${pythonCmd}" "${scriptPath}" --ticker ${ticker}`;

  exec(cmd, { cwd: path.dirname(scriptPath) }, (err, stdout, stderr) => {
    if (err) {
      console.error("Prediction script failed:", stderr || err.message);
      return res.status(500).json({ error: "Prediction service error" });
    }
    try {
      const data = JSON.parse(stdout);
      return res.json(data);
    } catch (parseErr) {
      console.error("Invalid JSON from prediction script:", stdout);
      return res.status(500).json({ error: "Bad prediction output" });
    }
  });
});

module.exports = router;
