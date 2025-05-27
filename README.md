# Lotus Black Money Print

This script adds a **black money printing and material stealing** mission system for FiveM servers compatible with the QBCore framework and OX Inventory. Missions are started via an NPC on the map, and players can steal materials from a randomly selected location and print their money at the black money printing spot. All interactions are handled with `qb-target`.

## Features

- Interaction with a mission-starting NPC
- Material stealing mission at a randomly selected location
- Blip and redzone added to the material stealing area
- Interaction with both the black money printing spot and NPC
- Menu and animation for the money printing process
- Full compatibility with the QBCore inventory system
- Blip support for notifications and mission steps

## Installation

1. Place the script files in your `resources` folder.
2. Add `ensure lotus_blackmoneyprint` to your `server.cfg`.
3. Add the item definitions from `items.lua` to your inventory system.
4. Make sure the dependencies in `fxmanifest.lua` (`qb-core`, `qb-target`, `qb-menu`) are installed.
5. Start the script.

## Usage

1. The player goes to the mission NPC on the map and starts the mission by selecting "Start Mission".
2. The player goes to the randomly selected material stealing location and performs the "Steal Materials" action.
3. After collecting the materials, the player can access the "Print Money" menu via the black money printing NPC or zone.
4. The player can print the desired amount of black money from the menu.

## Configuration

- NPC models, locations, mission points, and durations can be adjusted via `config.lua`.
- Notification messages and blip settings can also be edited in `config.lua`.
- The randomness of material amounts is also determined via the config.

## Requirements

- [qb-core](https://github.com/qbcore-framework/qb-core)
- [qb-target](https://github.com/qbcore-framework/qb-target)
- [qb-menu](https://github.com/qbcore-framework/qb-menu)

## Supported Inventories

- QB Inventory
- OX Inventory

## Notes

- All locations and models in the script are provided as examples and should be adjusted for your server.
- The names of material and money items must be defined in your inventory system.

