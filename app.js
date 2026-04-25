const http = require("http");

const PORT = process.env.PORT || 3000;

const server = http.createServer((req, res) => {
  res.end("Yaar adicha pori kalangi boomi adhurradhu odambula theridho, avan dhan Tamil.. Naan dhan.. Enna? 🚀");
});

server.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});
