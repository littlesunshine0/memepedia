#!/bin/bash

echo "🔥 Setting up Memepedia..."

# Create the project structure
mkdir -p memepedia/.devcontainer
cd memepedia

# Create index.html
cat <<EOL > index.html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Memepedia - The Ultimate Meme Encyclopedia</title>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/marked/4.0.12/marked.min.js"></script>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; background-color: #121212; color: white; max-width: 800px; margin: auto; padding: 10px; }
        h1, h2, h3 { color: #FFD700; text-align: center; }
        .meme-container { border: 1px solid #FFD700; padding: 15px; margin-bottom: 20px; border-radius: 10px; background-color: #1E1E1E; text-align: center; }
        img { max-width: 100%; border-radius: 5px; margin-top: 10px; }
        ul { padding-left: 20px; text-align: left; }
    </style>
</head>
<body>
    <h1>🔥 Memepedia - The Ultimate Meme Encyclopedia 🔥</h1>
    <p>Welcome to Memepedia, the most **based** archive of internet meme culture. Every meme, explained.</p>
    <div id="meme-list">Loading memes...</div>
    <script>
        async function loadMemes() {
            try {
                const response = await fetch('/memes.json');
                const data = await response.json();
                const memeList = document.getElementById("meme-list");
                memeList.innerHTML = "";
                data.memes.forEach(meme => {
                    let memeHTML = \`
                        <div class="meme-container">
                            <h2>\${meme.name}</h2>
                            <img src="\${meme.image_url}" alt="\${meme.name}">
                            <h3>📌 Origin:</h3>
                            <p>\${meme.template_origin.source} by \${meme.template_origin.creator} (\${meme.template_origin.year})</p>
                            <h3>🕰 First Appearance:</h3>
                            <p>\${meme.first_appearance.platform} (\${meme.first_appearance.year})</p>
                            <h3>📖 Meaning:</h3>
                            <p>\${meme.context_and_meaning.implied_meaning}</p>
                        </div>
                    \`;
                    memeList.innerHTML += memeHTML;
                });
            } catch (error) {
                console.error("Error loading memes:", error);
                document.getElementById("meme-list").innerHTML = "⚠️ Failed to load memes.";
            }
        }
        loadMemes();
    </script>
</body>
</html>
EOL

# Create memes.json
cat <<EOL > memes.json
{
  "memes": [
    {
      "name": "This Is Fine",
      "image_url": "https://i.kym-cdn.com/photos/images/newsfeed/000/974/766/69e.jpg",
      "template_origin": { "source": "Gunshow webcomic", "creator": "KC Green", "year": 2013, "original_url": "https://gunshowcomic.com/648" },
      "first_appearance": { "platform": "Tumblr, Reddit", "year": 2014 },
      "context_and_meaning": { "literal_meaning": "A dog sits in a burning room, casually saying 'this is fine.'", "implied_meaning": "Symbolizes ignoring problems while everything is falling apart." }
    }
  ]
}
EOL

# Create server.py
cat <<EOL > server.py
from flask import Flask, send_from_directory
app = Flask(__name__)
@app.route('/')
def serve_index():
    return send_from_directory('.', 'index.html')
@app.route('/memes.json')
def serve_json():
    return send_from_directory('.', 'memes.json')
if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8000)
EOL

# Create devcontainer.json for GitHub Codespaces
cat <<EOL > .devcontainer/devcontainer.json
{
    "name": "Memepedia Dev Container",
    "image": "mcr.microsoft.com/devcontainers/python:3.9",
    "features": { "ghcr.io/devcontainers/features/node:1": {} },
    "postCreateCommand": "pip install flask",
    "forwardPorts": [8000],
    "customizations": {
        "vscode": { "settings": { "editor.formatOnSave": true } }
    }
}
EOL

# Start the Flask server
echo "🚀 Memepedia setup complete! Starting the server..."
python3 -m venv venv && source venv/bin/activate && pip install flask && python3 server.py
