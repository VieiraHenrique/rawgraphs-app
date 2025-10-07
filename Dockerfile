# --- Étape 1 : Construction de l'application ---
# On utilise une image Node.js pour construire les fichiers statiques
FROM node:18-alpine AS builder

WORKDIR /app

# Copier les fichiers de dépendances et les installer
COPY package.json yarn.lock ./
RUN yarn install --frozen-lockfile

# Copier le reste du code source
COPY . .

# Construire l'application pour la production
RUN yarn build

# --- Étape 2 : Création de l'image finale ---
# On utilise une image Nginx très légère pour servir les fichiers
FROM nginx:stable-alpine

# Copier les fichiers construits depuis l'étape 1
COPY --from=builder /app/out /usr/share/nginx/html

# Indiquer que le serveur écoute sur le port 80
EXPOSE 80

# Commande pour démarrer Nginx
CMD ["nginx", "-g", "daemon off;"]