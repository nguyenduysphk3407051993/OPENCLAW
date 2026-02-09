# ============================================
# OpenClaw (Moltbot) Dockerfile
# ============================================
FROM node:22-bookworm
LABEL maintainer="OpenClaw Community"
LABEL description="OpenClaw - Personal AI Assistant"
LABEL version="1.0"

# ============================================
# Environment Variables
# ============================================
ENV NODE_ENV=production
ENV PNPM_HOME="/pnpm"
ENV PATH="$PNPM_HOME:$PATH"
ENV TZ=Asia/Ho_Chi_Minh

# ============================================
# Install System Dependencies
# ============================================
RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    curl \
    ca-certificates \
    gnupg \
    build-essential \
    python3 \
    tzdata \
    && rm -rf /var/lib/apt/lists/*

# Set timezone
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# ============================================
# Install Bun (required for build scripts)
# ============================================
RUN curl -fsSL https://bun.sh/install | bash
ENV PATH="/root/.bun/bin:${PATH}"

# ============================================
# Enable Corepack & PNPM
# ============================================
RUN corepack enable && corepack prepare pnpm@latest --activate

# ============================================
# Create App Directory
# ============================================
WORKDIR /app

# ============================================
# Clone OpenClaw Repository
# ============================================
RUN git clone --depth 1 https://github.com/moltbot/moltbot.git .

# ============================================
# Install Dependencies
# ============================================
RUN pnpm install --frozen-lockfile

# ============================================
# Build Application
# ============================================
RUN pnpm build

# ============================================
# Build UI (if exists)
# ============================================
RUN pnpm ui:install || true
RUN pnpm ui:build || true

# ============================================
# Create Non-Root User
# ============================================
RUN groupadd -r openclaw && useradd -r -g openclaw -d /home/openclaw -m openclaw

# Create necessary directories
RUN mkdir -p /home/openclaw/.openclaw/workspace \
    && chown -R openclaw:openclaw /home/openclaw \
    && chown -R openclaw:openclaw /app

# ============================================
# Switch to Non-Root User
# ============================================
USER openclaw
WORKDIR /home/openclaw

# ============================================
# Expose Port
# ============================================
EXPOSE 18789

# ============================================
# Health Check
# ============================================
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
    CMD curl -f http://localhost:18789/health || exit 1

# ============================================
# Default Command
# ============================================
CMD ["node", "/app/dist/index.js", "gateway", "--bind", "lan", "--allow-unconfigured"]