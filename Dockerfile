# --- Étape 1 : Construction de l'application ---
FROM node:18-alpine AS builder

WORKDIR /app

COPY package.json yarn.lock ./
RUN yarn install --frozen-lockfile

COPY . .

# CORRECTION APPLIQUÉE ICI ⬇️
# Construire l'application pour la production en activant le support legacy d'OpenSSL
RUN NODE_OPTIONS=--openssl-legacy-provider yarn build

# --- Étape 2 : Création de l'image finale ---
FROM nginx:stable-alpine

COPY --from=builder /app/out /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]