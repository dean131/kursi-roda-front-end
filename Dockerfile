# Stage 1: Build Stage
FROM node:22.14.0-alpine AS builder
WORKDIR /app

# Copy package files and install dependencies
COPY package*.json ./
RUN npm install

# Copy the rest of the application code
COPY . .

# Build the Nuxt application (ensure your package.json has a build script)
RUN npm run build

# Stage 2: Production Stage
FROM node:22.14.0-alpine
WORKDIR /app

# Copy necessary files from the builder stage
COPY --from=builder /app/package.json ./
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/.nuxt ./.nuxt
# COPY --from=builder /app/static ./static

# Expose the port on which Nuxt will run
EXPOSE 3000

# Set environment variables for Nuxt (ensure Nuxt listens on all interfaces)
ENV NUXT_HOST=0.0.0.0
ENV NUXT_PORT=3000

# Start the Nuxt application
CMD ["npm", "run", "dev"]
