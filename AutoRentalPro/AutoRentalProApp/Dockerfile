# Étape 1 : Utiliser une image de base officielle Node.js
FROM node:18

# Créer et définir le répertoire de travail
WORKDIR /usr/src/app

# Copier package.json et package-lock.json
COPY package*.json ./

# Installer les dépendances de l'application
RUN npm install

# Copier le reste des fichiers de l'application
COPY . .

# Exposer le port de l'application
EXPOSE 8081

# Démarrer l'application
CMD ["npm", "start"]
