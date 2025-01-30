# Use the official Ollama image as base
FROM ollama/ollama:latest

# Install required dependencies
RUN apt-get update && apt-get install -y \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Create a startup script
COPY <<EOF /start.sh
#!/bin/bash
set -e

# Start Ollama server in background
echo "Starting Ollama server..."
ollama serve &
SERVER_PID=$!

# Wait for Ollama to be ready
echo "Waiting for Ollama server to be ready..."
until curl -s http://localhost:11434/api/version > /dev/null; do
    sleep 1
done
echo "Ollama server is ready"

# Pull the model
echo "Pulling deepseek-r1:1.5b model..."
if ollama pull deepseek-r1:1.5b; then
    echo "Model pulled successfully"
else
    echo "Failed to pull model"
    exit 1
fi

# Wait for the server process
wait $SERVER_PID
EOF

# Make the startup script executable
RUN chmod +x /start.sh

# Set the entrypoint
ENTRYPOINT ["/start.sh"]