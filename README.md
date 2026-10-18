# KrakovDragon

**A video game developed with Godot as my final project for the Multiplatform Application Development (DAM) degree.**

## About the project

KrakovDragon is a personal video game development project created as part of my final degree project (TFG).

The project combines game development with backend integration and database management to support player data, saved games and gameplay progression.

## Features

- Player data management.
- Game session and save management.
- Gameplay progression tracking.
- Level and checkpoint tracking.
- Collection tracking through in-game coins.
- Enemy and boss defeat progression.
- Database integration for persistent game data.

## Technologies

- **Godot Engine** — Game development.
- **GDScript** — Game logic.
- **MariaDB** — Relational database.
- **SQL** — Database schema and relationships.
- **API integration** — Communication between the game and its backend.

## Project structure

- `krakovdragon/` — Main game project.
- `API_Godot.zip` — API project associated with the game.
- `godot_game.sql` — Database schema.
- `Documentacion_KrakovDragon_RSG.pdf` — Original project documentation.
- `EXE.txt` — Link to the downloadable game executable.

## Getting started

### Play the game

Download the executable from the following link:

[Download KrakovDragon](https://drive.google.com/drive/folders/1Tydl3blEpHf9IgNgUM-1MXKgAiw-ZKnu?usp=sharing)

### Open the project in Godot

1. Clone or download this repository.
2. Open Godot Engine.
3. Import the project by selecting the `project.godot` file inside the game directory.
4. Run the project from the Godot editor.

Additional configuration may be required to run the API and database components.

## Database

The project includes an SQL schema for MariaDB with tables for:

- `Jugador` — Player information.
- `Partida` — Game sessions and timestamps.
- `Progreso_partida` — Current level, checkpoint, coins and defeated enemies and bosses.

The schema uses foreign keys to associate game sessions with players and progression data with individual sessions.

## Documentation

The original technical documentation is available in the repository:

[Read the project documentation](./Documentacion_KrakovDragon_RSG.pdf)


