# Weather Forecast App

## Install and Run

```bash
# checkout the code
git clone git@github.com:gdonald/forecast.git

# change to the project directory
cd forecast

# install dependencies
bundle install

# create the database
rails db:migrate

# start the server
rails server
```

## Usage

Visit [http://localhost:3000](http://localhost:3000) in your browser.

Enter your zip code and click 'Submit'.

The weather forecast for the zip code will be displayed.

## Testing

```bash
# create the test database
rails db:migrate RAILS_ENV=test

# run the specs
rspec
```

A test coverage report is available in the `coverage` directory after running the specs.

