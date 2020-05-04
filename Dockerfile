FROM php:7.2-fpm

# Copy the dev php.ini
COPY config/php.ini /usr/local/etc/php/

# Copy custom scripts in
COPY bin/docker-php-pecl-install /usr/local/bin/

# Enable Reporting
RUN echo ";\n">>/usr/local/etc/php-fpm.conf
RUN echo ";Enabling Error Logging\n">>/usr/local/etc/php-fpm.conf
RUN echo "php_flag[display_errors] = On">>/usr/local/etc/php-fpm.conf
RUN echo "php_admin_flag[log_errors] = On">>/usr/local/etc/php-fpm.conf
RUN echo "php_admin_value[display_errors] = 'stderr'">>/usr/local/etc/php-fpm.conf
RUN echo "php_value[session.save_handler] = redis">>/usr/local/etc/php-fpm.conf
RUN echo "php_value[session.save_path] = 'tcp://redis:6379/'">>/usr/local/etc/php-fpm.conf

# Setting SAST Time
RUN rm /etc/localtime
RUN ln -s /usr/share/zoneinfo/Africa/Johannesburg /etc/localtime
RUN "date"

# Install modules TODO
RUN apt-get update && apt-get install -y \
libfreetype6-dev \
libjpeg62-turbo-dev \
libmcrypt-dev \
libpng-dev \
imagemagick

RUN docker-php-ext-install mysqli iconv exif pdo pdo_mysql opcache bcmath mbstring zip
RUN docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/
RUN docker-php-ext-install gd

# Use composer to install dependencies
RUN mkdir -p /usr/share/nginx/html/tvt2
RUN mkdir -p /usr/share/nginx/html/art
RUN mkdir -p /usr/share/nginx/html/heroesofthestorm
RUN mkdir -p /usr/share/nginx/html/tvtracker
RUN mkdir -p /usr/share/nginx/droids
RUN mkdir -p /usr/src/php/ext/

# Install Git for Composer
RUN apt-get install -y git

# Expose ports
EXPOSE 9000

# Install Redis
RUN git clone -b master https://github.com/phpredis/phpredis.git
RUN mv phpredis /usr/src/php/ext/
RUN ls /usr/src/php/ext | grep -i redis
RUN cd /usr/src/php/ext && docker-php-ext-install phpredis

# Install mcrypt
RUN docker-php-pecl-install mcrypt-1.0.1

CMD ["php-fpm"]
