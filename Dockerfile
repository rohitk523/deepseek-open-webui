# Use the official Ollama image as base
FROM ollama/ollama:latest

# Install any dependencies (if needed)
RUN apt-get update && apt-get install -y curl

# Create a startup script
COPY <<EOF /start.sh
#!/bin/bash
ollama serve &
sleep 10
ollama pull deepseek-r1:1.5b
wait
EOF

# Make the startup script executable
RUN chmod +x /start.sh

# Set the entrypoint to use the startup script
ENTRYPOINT ["/start.sh"]