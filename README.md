# MoneySleuth

A simple tool for managing income, expenses & balances. Includes customizable support for importing statements institutions and categorise transactions to generate reports.

### Prerequisites

- Docker
- Docker compose

### Installation

1. Check out the repository
   `git clone git@github.com/dawner/money_sleuth.git`

2. Create and setup the database
   `docker-compose build`

3. Start the application
   `docker-compose up`

You can now visit the site with the URL http://localhost:3000

4. To run migrations or rake commands
   ```
   docker exec -it money_sleuth-web-1 /bin/bash
   rake db:migrate
   ```

### Testing

Run test suite with
```
   docker exec -it money_sleuth-web-1 /bin/bash
   rspec
```