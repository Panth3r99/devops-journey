const http = require("http");

const PORT = process.env.PORT || 3000;

const server = http.createServer((req, res) => {
  if (req.method === "GET") {
    res.writeHead(200, { "Content-Type": "text/html; charset=utf-8" });

    res.end(`
      <html>
        <head>
          <title>BMI Calculator</title>
          <style>
            body {
              font-family: Arial;
              text-align: center;
              margin-top: 50px;
            }
            input {
              padding: 10px;
              margin: 5px;
              width: 200px;
            }
            button {
              padding: 10px 20px;
              margin-top: 10px;
              cursor: pointer;
            }
          </style>
        </head>
        <body>
          <h1>💪 BMI Calculator</h1>

          <form method="POST">
            <input type="number" step="0.01" name="weight" placeholder="Weight (kg)" required /><br/>
            <input type="number" step="0.01" name="height" placeholder="Height (meters)" required /><br/>
            <button type="submit">Calculate BMI</button>
          </form>
        </body>
      </html>
    `);
  }

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
          <body style="text-align:center; font-family: Arial;">
            <h1>Your BMI: ${bmi}</h1>
            <h2>Category: ${category}</h2>
            <a href="/">🔄 Calculate Again</a>
          </body>
        </html>
      `);
    });
  }
});

server.listen(PORT, () => {
  console.log("Server running on port " + PORT);
});
