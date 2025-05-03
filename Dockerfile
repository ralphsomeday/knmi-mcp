FROM python:3.12

ENV PYTHONUNBUFFERED=1

WORKDIR /app/

# Install uv
COPY --from=ghcr.io/astral-sh/uv:0.6.4 /uv /uvx /bin/

# Add uv to PATH
ENV PATH="/app/.venv/bin:$PATH"
ENV UV_COMPILE_BYTECODE=1
ENV UV_LINK_MODE=copy
ENV PYTHONPATH=/app

# Copy project files
COPY ./pyproject.toml ./uv.lock /app/

# Install dependencies
RUN uv venv && uv pip install --upgrade pip && uv sync --frozen --no-install-project

# Copy source code
COPY ./src /app/src

# Final sync (if needed)
RUN uv sync

CMD ["fastmcp", "run", "src/knmi_weather_mcp/server.py", "-t", "sse"]
