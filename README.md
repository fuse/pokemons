# README

## Configuration

These env vars can be used to configure the application :

- `DEFAULT_PER_PAGE` : number of item for pagination, default value is 10
- `POKEMONS_DATASOURCE_PATH` : use to set the CSV path, default value is `data/pokemons.csv` (relative to rails root)

## Installation

Application use ruby `3.1.0` and rails `7.0.1`.

~~~ruby
bundle install
~~~

## Run

~~~shell
rails s
~~~

## Tests

~~~shell
RAILS_ENV=test rspec
~~~

## Documentation

API documentation can be found under `doc`. There is an OpenAPI file (`api.json`) and a documentation generated with Redoc (`redoc-static.html`).

API has been exposed under `/api/v1`.

## Data

You can reset data this way :

~~~shell
cp data/pokemons.{original.csv,csv}
~~~
