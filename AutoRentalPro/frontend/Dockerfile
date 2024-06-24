# Étape 1 : Construction de l'image
FROM node:18 AS build

WORKDIR /frontend

# Copie des fichiers nécessaires pour l'installation des dépendances
COPY package.json package-lock.json ./

# Installation des dépendances
RUN npm install

# Copie de tous les fichiers du projet
COPY . .

# Assurez-vous que les scripts ont les permissions d'exécution nécessaires
RUN chmod +x /frontend/node_modules/.bin/react-scripts

# Construire le projet
RUN npm run build

# Vérification du répertoire build après npm run build
RUN echo "Contenu du répertoire de travail après npm run build" && ls -la /frontend && ls -la /frontend/build

# Étape 2 : Image pour le serveur
FROM nginx:alpine

# Copie des fichiers de build de l'étape précédente
COPY --from=build /frontend/build /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
