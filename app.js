const http = require("http");

const PORT = process.env.PORT || 3000;

const server = http.createServer((req, res) => {

  // ================= GET (Form Page) =================
  if (req.method === "GET") {

    res.writeHead(200, { "Content-Type": "text/html; charset=utf-8" });

    res.end(`
<html>
<head>
  <title>BMI Calculator</title>
  <style>
    body {
      margin: 0;
      font-family: Arial, sans-serif;
      background: linear-gradient(to right, #667eea, #764ba2);
      display: flex;
      justify-content: center;
      align-items: center;
      height: 100vh;
    }

    .card {
      background: white;
      padding: 30px;
      border-radius: 12px;
      box-shadow: 0 10px 25px rgba(0,0,0,0.2);
      text-align: center;
      width: 300px;
    }

    h1 {
      margin-bottom: 20px;
    }

    input {
      width: 100%;
      padding: 10px;
      margin: 10px 0;
      border-radius: 6px;
      border: 1px solid #ccc;
      font-size: 14px;
    }

    button {
      width: 100%;
      padding: 10px;
      background: #667eea;
      color: white;
      border: none;
      border-radius: 6px;
      font-size: 16px;
      cursor: pointer;
    }

    button:hover {
      background: #5a67d8;
    }
  </style>
</head>

<body>
  <div class="card">
    <h1>💪 BMI Calculator</h1>

    <form method="POST">
      <input type="number" step="0.01" name="weight" placeholder="Weight (kg)" required />
      <input type="number" step="0.01" name="height" placeholder="Height (meters)" required />
      <button type="submit">Calculate BMI</button>
    </form>
  </div>
</body>
</html>
`);
  }

  // ================= POST (Result Page) =================
  else if (req.method === "POST") {

    let body = "";

    req.on("data", chunk => {
      body += chunk.toString();
    });

    req.on("end", () => {

      const params = new URLSearchParams(body);

      const weight = parseFloat(params.get("weight"));
      const height = parseFloat(params.get("height"));

      const bmi = (weight / (height * height)).toFixed(2);

      let category = "";

      if (bmi < 18.5) category = "Underweight";
      else if (bmi < 25) category = "Normal";
      else if (bmi < 30) category = "Overweight";
      else category = "Obese";

      res.writeHead(200, { "Content-Type": "text/html; charset=utf-8" });

      res.end(`
<html>
<head>
  <style>
    body {
      margin: 0;
      font-family: Arial;
      background: linear-gradient(to right, #667eea, #764ba2);
      display: flex;
      justify-content: center;
      align-items: center;
      height: 100vh;
    }

    .card {
      background: white;
      padding: 30px;
      border-radius: 12px;
      box-shadow: 0 10px 25px rgba(0,0,0,0.2);
      text-align: center;
      width: 300px;
    }

    h1 {
      margin-bottom: 10px;
    }

    a {
      display: inline-block;
      margin-top: 15px;
      text-decoration: none;
      color: white;
      background: #667eea;
      padding: 8px 15px;
      border-radius: 6px;
    }
  </style>
</head>

<body>
  <div class="card">
    <h1>Your BMI: ${bmi}</h1>
    <h2>${category}</h2>
    <a href="/">🔄 Try Again</a>
  </div>
</body>
</html>
`);
    });
  }

});

server.listen(PORT, () => {
  console.log("Server running on port " + PORT);
});
