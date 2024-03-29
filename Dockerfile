FROM php:8.2-fpm

RUN apt-get update && apt-get install -y \
    git \
    libzip-dev \
    zip \
    unzip \ 
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev 

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
RUN docker-php-ext-install pdo_mysql exif pcntl bcmath gd zip

RUN apt-get update && apt-get install -y nginx wget

RUN mkdir -p /run/nginx

COPY docker/nginx.conf /etc/nginx/nginx.conf

RUN mkdir -p /app
COPY . /app
COPY ./src /app

RUN sh -c "wget http://getcomposer.org/composer.phar && chmod a+x composer.phar && mv composer.phar /usr/local/bin/composer"
RUN cd /app && \
    /usr/local/bin/composer install --no-dev

RUN chown -R www-data: /app

CMD sh /app/docker/startup.sh
