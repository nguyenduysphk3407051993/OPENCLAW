# ============================================
# OpenClaw Dockerfile - Full Support
# ============================================
FROM node:22-bookworm

LABEL maintainer="OpenClaw Community"
LABEL description="OpenClaw - Personal AI Assistant with Full PDF Support & Gemini CLI"
LABEL version="1.6"

# ============================================
# Environment Variables
# ============================================
ENV NODE_ENV=production
ENV PNPM_HOME="/pnpm"
ENV PATH="$PNPM_HOME:$PATH"
ENV TZ=Asia/Ho_Chi_Minh
ENV NO_UPDATE_NOTIFIER=true

# ============================================
# 1. Install System Dependencies
# ============================================
RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    curl \
    ca-certificates \
    gnupg \
    build-essential \
    python3 \
    python3-pip \
    python3-venv \
    python3-pygments \
    tzdata \
    texlive-full \
    pandoc \
    poppler-utils \
    ghostscript \
    fonts-noto \
    && rm -rf /var/lib/apt/lists/*

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# ============================================
# 2. Install Gemini CLI (Latest from npm)
# ============================================
RUN npm install -g @google/gemini-cli@latest \
    && ln -sf $(npm prefix -g)/bin/gemini /usr/bin/gemini \
    && chmod +x /usr/bin/gemini

# ============================================
# 3. Install Steipete Tools (goplaces + gog)
# ============================================
# Google Places CLI
RUN curl -L https://github.com/steipete/goplaces/releases/latest/download/goplaces_Linux_x86_64.tar.gz \
    | tar -xz -C /usr/local/bin && chmod +x /usr/local/bin/goplaces

# Google CLI (Gmail, Calendar, Drive, Contacts)
RUN curl -L https://github.com/steipete/gog/releases/latest/download/gog_Linux_x86_64.tar.gz \
    | tar -xz -C /usr/local/bin && chmod +x /usr/local/bin/gog

# ============================================
# 4. Install Bun
# ============================================
RUN curl -fsSL https://bun.sh/install | bash && \
    mv /root/.bun/bin/bun /usr/local/bin/bun && \
    rm -rf /root/.bun

# ============================================
# 5. Enable Corepack & PNPM
# ============================================
RUN corepack enable && corepack prepare pnpm@latest --activate

# ============================================
# 6. Create User & Directories
# ============================================
RUN groupadd -r openclaw && useradd -r -g openclaw -d /home/openclaw -m -s /bin/bash openclaw

RUN mkdir -p /app \
    && mkdir -p /pnpm \
    && mkdir -p /home/openclaw/.openclaw/workspace \
    && mkdir -p /home/openclaw/.config/google-gemini-cli \
    && mkdir -p /home/openclaw/.gemini \
    && mkdir -p /home/openclaw/.cache \
    && mkdir -p /home/openclaw/.local/share \
    && mkdir -p /home/openclaw/.npm \
    && mkdir -p /tmp/openclaw-tmp

RUN chown -R openclaw:openclaw /app \
    && chown -R openclaw:openclaw /pnpm \
    && chown -R openclaw:openclaw /home/openclaw \
    && chown -R openclaw:openclaw /tmp/openclaw-tmp

# ============================================
# 7. Clone & Build OpenClaw AS openclaw user
# ============================================
USER openclaw
WORKDIR /app

RUN git clone --depth 1 https://github.com/openclaw/openclaw.git .

RUN pnpm install --frozen-lockfile || pnpm install
RUN pnpm build

RUN pnpm ui:build || true

# ============================================
# 8. Set Working Directory
# ============================================
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