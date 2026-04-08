---
name: psql
description: Use when needing to connect to, inspect, or query a PostgreSQL database using the psql CLI. Invoke for database exploration, schema inspection, data sampling, running ad-hoc queries, or troubleshooting connection issues.
---

# psql — PostgreSQL CLI

## Overview

Guide for using `psql` to connect to and inspect PostgreSQL databases. **Always start by reading `psql --help`** to ground yourself in available flags and connection options.

## When to Use

- Inspecting database schema, tables, indexes, or data
- Running ad-hoc queries against a Postgres database
- Debugging connection issues
- Exploring an unfamiliar database

## Startup Sequence

```dot
digraph psql_flow {
    "Task requires DB access" [shape=doublecircle];
    "Read psql --help" [shape=box];
    "Have credentials?" [shape=diamond];
    "Ask user for credentials" [shape=box];
    "Connect with masked creds" [shape=box];
    "Inspect & query" [shape=doublecircle];

    "Task requires DB access" -> "Read psql --help";
    "Read psql --help" -> "Have credentials?";
    "Have credentials?" -> "Ask user for credentials" [label="no"];
    "Have credentials?" -> "Connect with masked creds" [label="yes"];
    "Ask user for credentials" -> "Connect with masked creds";
    "Connect with masked creds" -> "Inspect & query";
}
```

### Step 1: Read the Cheatsheet

Before doing anything else, run:

```bash
psql --help
```

This gives you the current version's exact flags, connection options, and environment variables. Do not rely on memory — read the output.

### Step 2: Get Credentials from the User

**CRITICAL: Never hardcode, echo, or log credentials.**

Use `AskUserQuestion` to collect connection details from the user:

- **Host** (e.g., `localhost`, `db.example.com`)
- **Port** (default: `5432`)
- **Database name**
- **Username**

For the **password**, do NOT collect it through AskUserQuestion (it would appear in conversation). Instead, use one of these secure methods:

**Option A — Prompt in shell (preferred):**

```bash
# read -s suppresses terminal echo — password is never visible
read -s PGPASSWORD_VAL && export PGPASSWORD="$PGPASSWORD_VAL" && unset PGPASSWORD_VAL
```

Then run psql commands in the same shell session. PGPASSWORD is consumed by psql automatically.

**Option B — Existing .pgpass file:**

```bash
# Check if user already has credentials configured
cat ~/.pgpass 2>/dev/null | sed 's/:[^:]*$/:*****/' # mask password column
```

**Option C — Connection string from user:**
Ask user to provide a connection string. When logging or displaying it, always mask the password portion:

```
postgresql://user:*****@host:5432/dbname
```

### Step 3: Connect and Verify

```bash
# Use PGPASSWORD env var — never pass password as CLI argument
PGPASSWORD="$PGPASSWORD" psql -h HOST -p PORT -U USER -d DBNAME -c "SELECT version();"
```

If connection fails, check `psql --help` output for correct flag syntax and suggest the user verify credentials.

## Credential Safety Rules

| Rule                                        | Why                                                  |
| ------------------------------------------- | ---------------------------------------------------- |
| Never echo/print passwords                  | Appears in terminal scrollback and logs              |
| Never pass password as CLI arg              | Visible in `ps aux` process list                     |
| Use `PGPASSWORD` env var or `.pgpass`       | Standard secure methods supported by psql            |
| Mask passwords in all output                | Replace with `*****` when displaying connection info |
| Never store credentials in files you create | Leaks into git, logs, conversation context           |
| Use `read -s` for password input            | Suppresses terminal echo                             |

**When logging commands for the user**, always replace actual credentials:

```
# ✅ Show this
psql -h db.example.com -p 5432 -U admin -d myapp

# ❌ Never show this
PGPASSWORD=actual_secret psql -h db.example.com ...
```

## Quick Reference — Common Inspection Commands

Once connected (`psql -h ... -d ...`), use these meta-commands:

| Command     | What it does                                   |
| ----------- | ---------------------------------------------- |
| `\l`        | List all databases                             |
| `\dt`       | List tables in current schema                  |
| `\dt+`      | List tables with sizes                         |
| `\d TABLE`  | Describe table (columns, types, constraints)   |
| `\di`       | List indexes                                   |
| `\dn`       | List schemas                                   |
| `\du`       | List roles/users                               |
| `\df`       | List functions                                 |
| `\dv`       | List views                                     |
| `\conninfo` | Show current connection info                   |
| `\x`        | Toggle expanded display (useful for wide rows) |
| `\timing`   | Toggle query timing                            |

### Non-Interactive Inspection (single commands)

For quick lookups without entering the psql shell:

```bash
# List databases
psql -h HOST -U USER -c "\l"

# Describe a table
psql -h HOST -U USER -d DBNAME -c "\d tablename"

# Sample data
psql -h HOST -U USER -d DBNAME -c "SELECT * FROM tablename LIMIT 10;"

# Count rows
psql -h HOST -U USER -d DBNAME -c "SELECT COUNT(*) FROM tablename;"

# Run a SQL file
psql -h HOST -U USER -d DBNAME -f script.sql
```

### Output Formatting

```bash
# CSV output
psql -h HOST -U USER -d DBNAME -c "COPY (SELECT * FROM t LIMIT 10) TO STDOUT WITH CSV HEADER"

# Unaligned output with custom separator
psql -h HOST -U USER -d DBNAME -A -F',' -c "SELECT * FROM t LIMIT 10"

# HTML output
psql -h HOST -U USER -d DBNAME -H -c "SELECT * FROM t LIMIT 10"
```

## Common Mistakes

| Mistake                                          | Fix                                                      |
| ------------------------------------------------ | -------------------------------------------------------- |
| Passing password via `-W` flag and logging it    | Use `PGPASSWORD` env var with `read -s`                  |
| Running destructive queries without confirmation | Always `BEGIN;` ... inspect ... `ROLLBACK;` or `COMMIT;` |
| Forgetting to specify database with `-d`         | Defaults to username as database — usually wrong         |
| Not using `\x` for wide tables                   | Toggle with `\x` or use `\x auto`                        |
| Using `SELECT *` on huge tables                  | Always add `LIMIT` for exploration                       |
