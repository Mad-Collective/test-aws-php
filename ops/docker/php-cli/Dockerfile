FROM php:8.1.0-cli

# Install extras
RUN apt-get update && apt-get install -y vim git zip unzip curl zlib1g-dev

# Install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer

# Install AWS cli
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" \
  && unzip -q awscliv2.zip \
  && ./aws/install \
  && rm -R aws awscliv2.zip

