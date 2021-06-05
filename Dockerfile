FROM wordpress:latest

# Install xdebug
# This part is taken from https://github.com/andreccosta/wordpress-xdebug-dockerbuild
ENV XDEBUG_PORT 9000
ENV XDEBUG_IDEKEY docker

RUN pecl install "xdebug" \
    && docker-php-ext-enable xdebug

RUN echo "xdebug.mode=debug" >> /usr/local/etc/php/conf.d/xdebug.ini && \
    echo "xdebug.start_with_request=trigger" >> /usr/local/etc/php/conf.d/xdebug.ini && \
    echo "xdebug.client_port=${XDEBUG_PORT}" >> /usr/local/etc/php/conf.d/xdebug.ini && \
    echo "xdebug.idekey=${XDEBUG_IDEKEY}" >> /usr/local/etc/php/conf.d/xdebug.ini

# Install git & zip
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y git && \
    apt-get install -y hub && \
    apt-get install -y zsh && \
    apt-get install -y zip

SHELL ["/bin/bash", "--login", "-c"]

# Install nvm and node
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash
RUN nvm install --lts

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Install WP CLI
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
        chmod +x wp-cli.phar && \
        mv wp-cli.phar /usr/local/bin/wp
        
# Start the ssh-agent in the background.
RUN eval "$(ssh-agent -s)"

# Install ZIM for better zsh
RUN curl -fsSL https://raw.githubusercontent.com/zimfw/install/master/install.zsh | zsh

RUN chsh -s ~/.zshrc

CMD [ "zsh" ]
