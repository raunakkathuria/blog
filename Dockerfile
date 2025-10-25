# Use the official Ruby image from Docker Hub
FROM ruby:3.1

# Set a working directory inside the container
WORKDIR /usr/src/app

# Install required dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    nodejs \
    && rm -rf /var/lib/apt/lists/*

COPY --chown=jekyll:jekyll Gemfile .
COPY --chown=jekyll:jekyll Gemfile.lock .

RUN rm -f Gemfile.lock

# Install gems
RUN gem install bundler && bundle install

# Copy the Jekyll site files into the container
COPY . .

# Expose port 4000 for the Jekyll server
EXPOSE 4000

# Start the Jekyll server with live reload enabled
CMD ["bundle", "exec", "jekyll", "serve", "--host", "0.0.0.0", "--livereload"]
