# Reciclando

Reciclando :recycle: is an app that allows organizations to manage recycled flow in their cities.

## Getting Started
### Prerequisites

* Ruby  2.5
* Bundler
* PostgreSQL

### Installing
#### Dependencies

After downloading the repository, run this command:
```bash
$ bundle install
```

#### Database

Once installed the gems, run this command to set up the database:
```
rails db:setup
```
Note: Fake data is also loaded for testing purposes.

### Running Locally

```
rails server
```
This would start the server in `http://localhost:3000`.

This command starts both apps, all API services under root path (`/`) and the CMS (`/admin`).

### Running Tests
#### Tests

An RSpec test suite is available to ensure proper API functionality.
To run this test, run:
```
bundle exec rspec
```

#### Coding Style

A linter is used to ensure proper code format.

To run this test, run:
```
bundle exec rubocop
```

## Deployment

The apps are deployed in [AWS](https://aws.amazon.com), where two EC2 instances are currently running:
* [Staging](http://34.213.11.120)
* [Production](http://34.216.31.97)

To setup EC2 instances for deployment, follow [this guide](https://www.digitalocean.com/community/tutorials/deploying-a-rails-app-on-ubuntu-14-04-with-capistrano-nginx-and-puma) step by step.

Some variables must be defined before deployment:
```
* REPO_URL
* APP_NAME
* EC2_USER
* EC2_IP_STAGING
* EC2_PORT_STAGING
* EC2_IP_PRODUCTION
* EC2_PORT_PRODUCTION
```

To automate the deployment, [Capistrano](https://github.com/capistrano/capistrano) is used. This gem gives you a `cap` tool to perform deployments. After setting up the neccessary rules in this files:
* deploy.rb
* staging.rb
* production.rb

the deployment can be perform in the command line, with the tool mentioned above.

[CircleCi](https://circleci.com/) simplifies this process, by running the deployment commands after app build success. Take into account that the deployments belongs to a certain enviorment.

## More information
## #API Documentation

The main API is documented with swagger, and can be reached [here](http://34.216.31.97/api_docs).

Note: credentials for access are `(reciclando, reciclando)`.

###CMS

The CMS is use by admin users to manage the content of the app, and it is implemented using [Active Admin](https://activeadmin.info)

## License

This project is licensed under the MIT license.
