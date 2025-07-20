# =========== BUILDER =============
FROM node:22-alpine AS builder

WORKDIR /app
RUN npm install -g pnpm@latest-10
COPY package.json pnpm-lock.yaml ./
RUN pnpm install
COPY . .
RUN pnpm run build
RUN pnpm install --prod

# =========== RUNTIME =============
FROM node:22-alpine

WORKDIR /app
ENV NODE_ENV=production
COPY --from=builder /app/build ./build
COPY --from=builder /app/node_modules ./node_modules
CMD [ "node", "build" ]
