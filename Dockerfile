# --- Étape 1 : Construction de l'application ---
FROM node:18-alpine AS builder

WORKDIR /app

COPY package.json yarn.lock ./
RUN yarn install --frozen-lockfile

COPY . .

# Construire l'application pour la production
RUN NODE_OPTIONS=--openssl-legacy-provider yarn build

# --- Étape 2 : Création de l'image finale ---
FROM nginx:stable-alpine

# CORRECTION APPLIQUÉE ICI ⬇️
# Copier le dossier "build" (et non "out") qui contient les fichiers finaux
COPY --from=builder /app/build /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]