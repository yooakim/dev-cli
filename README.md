# Yooakim's development CLI container
This repo contains my Dockerfile that I use when I work with development.

As I work with different customers it makes sense for me to have a general Dockerfile which I then can instatiate for each customer I work with.

So when I need to I star a new container with a Docker volume for keeping my work. I use the Docker volume to gain
performance and for safety the files are version controlled i a remote Git repository.

## HOWTO

    docker volume create x5music-workspace
    docker run -it --name x5music-dev -v x5music-workspace:/workspace yooakim-dev:latest

This will launch you into the development container console.
