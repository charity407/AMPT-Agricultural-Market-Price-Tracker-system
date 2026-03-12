# AMPT Project Structure

This repository contains the **AMPT (Agricultural Market Price Tracker)**
vanilla Java application with a PostgreSQL backend. The project is kept
simple with no build tools (Maven/Gradle) by design.

## Directory layout

- `src/` – Java source code packages and classes.
- `lib/` – External libraries; currently intended for the PostgreSQL JDBC
  driver `.jar` file.
- `db/` – Database scripts such as `schema.sql` (the schema dump) and any
  future migration or seed files.

## Git Ignore

Compiled artifacts, IDE settings, and third‑party jars are ignored to keep
the Git history clean. See the customized `.gitignore`.

## VS Code Configuration

A snippet is provided in `.vscode/settings.json` (below) to make sure VS
Code adds everything in `lib/` to the Java classpath so classes such as
`DatabaseConfig.java` can locate the PostgreSQL driver.

```json
{
    "java.project.referencedLibraries": [
        "lib/**/*.jar"
    ]
}
```

## Database Setup

To get the PostgreSQL database running on a teammate’s machine there’s no
magic needed – just two simple steps:

1. **Create an empty database** called `ampt_db` using your PostgreSQL
   instance (e.g. `psql -U postgres` then `CREATE DATABASE ampt_db;`).
2. **Run the SQL dump** that accompanies the repo:

   ```bash
   psql -U postgres -d ampt_db -f full_database_backup.sql
   ```

   This command will build all of the tables and populate them with the
   Kenyan market data that’s already been prepared.

Once done, your teammates can connect with the same JDBC URL you use in
`DatabaseConfig.java` (e.g. `jdbc:postgresql://localhost:5432/ampt_db`).

That’s it – no extra configuration or migrations are required.

Alternatively you can adapt `.vscode/launch.json` if you prefer explicit
launch configurations (see repository documentation).
