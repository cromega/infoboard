# infoboard_backend

## Requirements

* crystal 0.33 (no need if using Docker compose)

## Build

```sh
crystal build src/infoboard_backend.cr
```

## Run

You will need an [Openweathermap api key](https://home.openweathermap.org/api_keys).

* Docker compose

```sh
# edit api key in docker-compose.yml
docker-compose up
```

* Locally

```sh
export OPENWEATHERMAP_API_TOKEN=<api key>
./infoboard_backend
```

## Tests

```sh
crystal spec
```