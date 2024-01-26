# Create project directory and navigate into it
mkdir http-server
cd http-server

# Create Dockerfile
echo 'FROM node:14-alpine\n\
WORKDIR /app\n\
COPY package*.json ./\n\
RUN npm install\n\
COPY . .\n\
EXPOSE 8080\n\
CMD ["node", "server.js"]' > Dockerfile

# Create package.json
echo '{ "name": "http-server", "version": "1.0.0", "description": "Simple HTTP Server", "main": "server.js", "scripts": { "start": "node server.js" }, "dependencies": { "express": "^4.17.1" } }' > package.json

# Create server.js
echo 'const express = require("express");\n\
const fs = require("fs");\n\
const app = express();\n\
const port = 8080;\n\
app.get("/data", (req, res) => {\n\
  const fileName = req.query.n;\n\
  const lineNumber = req.query.m;\n\
  if (!fileName) {\n\
    res.status(400).send("File name is required.");\n\
    return;\n\
  }\n\
  const filePath = /tmp/data${fileName}.txt;\n\
  if (!fs.existsSync(filePath)) {\n\
    res.status(404).send("File not found.");\n\
    return;\n\
  }\n\
  if (lineNumber) {\n\
    const content = fs.readFileSync(filePath, "utf8").split("\\n")[lineNumber - 1];\n\
    res.send(content);\n\
  } else {\n\
    const content = fs.readFileSync(filePath, "utf8");\n\
    res.send(content);\n\
  }\n\
});\n\
app.listen(port, () => {\n\
  console.log(Server listening at http://localhost:${port});\n\
});' > server.js

# For development purposes, create sample data files
echo "File 1 Content" > /tmp/data1.txt
echo "File 2 Content" > /tmp/data2.txt

# Build Docker image
docker build -t http-server .

# Run Docker container
docker run -p 8080:8080 --memory=1500m --cpus=2 http-server