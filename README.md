# effectus-api
[![Maintainability](https://api.codeclimate.com/v1/badges/dd23e640b2ae8403e4a3/maintainability)](https://codeclimate.com/github/effectussoftware/pis-effectus-api/maintainability)

## Installation guide.

1 - Set up the environment.
The variables you need are:
```
DATABASE_USERNAME # username for the database
DATABASE_PASSWORD # password for the database
GOOGLE_CLIENT_ID  # google app id you can create this on google dev console
#AWS
AWS_ACCESS_KEY    # Amazon access Key
AWS_ACCESS_KEY_ID # Amazon acces key id
AWS_BUCKET        # Amazon S3 Bucket name
AWS_REGION        # Amazon S3 Bucket region 

DEFAULT_URL       # Site base url eg. http://localhost:5000 or https://example.com
```

2 - Install dependencies
in the project root run `bundle install`

3 - Create and migrate the database
in the project root run:
`rake db:create && rake db:migrate`

## Running the test suite
you can run all the existing locally tests with `$ rspec`
you can run the linters locally with `$ rubocop`

## Querying the api.
To register an user that user needs to have an effectus software account.
The user needs to log in first into the app and then if that user is admin it will be allowed to log in to the dashboard.
You can check the full api spec [here](https://app.swaggerhub.com/apis/effectus-software/pis-effectus_development/1.0)
