services:
  ollama:
    container_name: ollama
    build: 
      context: .
      dockerfile: Dockerfile
    volumes:
      - ollama:/root/.ollama
    ports:
      - "11434:11434"
    networks:
      - app_network
    restart: unless-stopped
    deploy:
      resources:
        limits:
          memory: 24G
        reservations:
          memory: 12G
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:11434/api/version"]
      interval: 30s
      timeout: 10s
      retries: 3

  open-webui:
    container_name: open-webui
    image: ghcr.io/open-webui/open-webui:main
    volumes:
      - open-webui:/app/backend/data
    ports:
      - "8080:8080"
    environment:
      - OLLAMA_API_BASE_URL=http://ollama:11434
      - OLLAMA_API_HOST=ollama
      - OLLAMA_HOST=ollama
      - HOST=0.0.0.0
      - PORT=8080
      - WEBUI_HOST=http://localhost:8080
    deploy:
      resources:
        limits:
          memory: 2G
        reservations:
          memory: 1G
    extra_hosts:
      - "host.docker.internal:host-gateway"
    networks:
      - app_network
    restart: unless-stopped
    depends_on:
      ollama:
        condition: service_healthy

volumes:
  ollama:
  open-webui:

networks:
  app_network:
    driver: bridge