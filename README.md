# deepseek-open-webui

# Create a network for the containers to communicate
docker network create ollama-network

# Build the Ollama image
docker build -t ollama-image .

# Run the Ollama container
docker run -d `
  --name ollama `
  --network ollama-network `
  -v ollama:/root/.ollama `
  -p 11434:11434 `
  ollama-image

# Run the Open WebUI container
docker run -d `
  --name open-webui `
  --network ollama-network `
  -v open-webui:/app/backend/data `
  -p 8080:8080 `
  -e OLLAMA_API_BASE_URL=http://ollama:11434/api `
  ghcr.io/open-webui/open-webui:main