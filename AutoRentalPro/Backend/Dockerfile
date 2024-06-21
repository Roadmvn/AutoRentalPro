FROM php:8.1-apache

# Installation des dépendances nécessaires
RUN apt-get update \
    && apt-get install -y \
        unzip \
        libzip-dev \
        git \
    && docker-php-ext-install pdo_mysql zip \
    && a2enmod rewrite

# Copier le code de l'application
COPY . /var/www/html

# Installer Composer et les dépendances PHP
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
    && composer install --no-scripts --no-autoloader \
    && composer dump-autoload --optimize --no-dev --classmap-authoritative

# Exposer le port 80 d'Apache
EXPOSE 80

# Commande pour démarrer Apache une fois le conteneur lancé
CMD ["apache2-foreground"]
