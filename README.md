# Elixir Koroibos

A recreation of the Koroibos challenge, used to emulate a two day long take home challenge. Originally completed as a part of the Turing School of Software & Design curriculum, this recreation is being used primarily to refine skills of testing, documentation, and general competency when using Elixir and the Phoenix Framework.

The application provides an API for tracking information on olympians, events, and statistics from the Olympic games. Documentation for available endpoints can be found [here](#endpoints).

## Getting Started

#### Dependencies
The application requires the follwing dependencies to be installed:
- Elixir 1.8.2 / OTP 21
- Phoenix 1.4.8
- PostgreSQL 11.1

#### Setup

To perform of the initial setup of the application, run the following:
``` bash
mix deps.get
mix ecto.create
mix ecto.migrate
```

This will fetch the required dependencies for the application and prepare the database.

#### Starting the Application

To start the application locally, use the command `mix phx.server`. The application will be started and listen on port 4000 by default.

Shut down the application by pressing `ctrl+c`.

## Testing

The application comes with a test suite for the provided endpoints and models. To execute the test suite, use the command `mix test`.

## Schema Design

![Schema Design](schema.png)

## Endpoints

### GET /api/v1/olympians

Provides a list of all olympians in the system with the following information:

- The name of the Olympian
- The age of the Olympian
- The name of the team the Olympian represents
- The name of the sport the Olympian is participating in
- The total medals won by the olympian

Sample response:
``` JSON
[
  {
    "name": "Olympian 1",
    "age": 20,
    "sport": "Swimming",
    "team": "USA",
    "total_medals_won": 2
  },
  {
    "name": "Olympian 2",
    "age": 18,
    "sport": "Taekwondo",
    "team": "South Korea",
    "total_medals_won": 4
  }
]
```

Additionally, the endpoint accepts an optional parameter, `age`, with the values of either `youngest` or `oldest`. When passed, the endpoint will only return the youngest or oldest olympian in the system in the array of olympians.

