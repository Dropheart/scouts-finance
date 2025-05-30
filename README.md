# Scouts Finance

Scouts Finance is a project designed to help leaders and treasurers manage 
their finances and keep track of income and expenses for scouting activities.

## Features

- Create and manage events
- View and categorise payments

## Getting Started

### Prerequisites

- Dart SDK
- Flutter SDK
- Serverpod SDK
- PostgreSQL
- Redis

It is recommended to install the Flutter SDK using the [Flutter installation guide](https://flutter.dev/docs/get-started/install).

### Running
1. Start the PostgreSQL and Redis services using Docker:

   ```bash
   docker compose up --build --detach
   ```
2. Start the Serverpod server:

   ```bash
   dart bin/main.dart
   ```
3. Run the Flutter application:

   ```bash
   flutter run
   ```
### Stopping the Services
To stop the Serverpod server, press `Ctrl-C` in the terminal where it is running. Then, stop the PostgreSQL and Redis services:

```bash
docker compose stop
```
### Documentation
For more information on how to use Serverpod, refer to the [Serverpod documentation](https://docs.serverpod.dev).