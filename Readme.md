# Docker development desktop image

This Docker image extends the
[development image](https://github.com/mbT-Infrastructure/docker-development)
by some applications with graphical user interface.

To use them, it allows X11Forwarding over ssh.

## Development

To build and run for development run:
```bash
docker compose --file docker-compose-dev.yaml up --build
```

To build the image locally run:
```bash
./docker-build.sh
```
