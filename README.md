# D&D Character Tracker Database

A comprehensive SQL Server database for tracking Dungeons & Dragons characters and their progression over time.

## Overview

This database is designed to store and track:
- Character information and stats
- Character progression at each level
- Races, subraces, and racial traits
- Classes, subclasses, and class features
- Spells and spell slots
- Equipment and items
- Feats
- Backgrounds
- Skills and proficiencies

## Database Schema

The database follows a normalized design with relationships between entities to minimize redundancy while maintaining data integrity. Key features include:

- Character snapshots at each level
- Complete tracking of abilities, skills, and proficiencies
- Comprehensive spell management
- Equipment and inventory tracking
- Support for multiclassing

## Setup Instructions

1. Clone this repository
2. Run the SQL scripts in the following order:
   - `01_CreateDatabase.sql` - Creates the database
   - `02_CreateTables.sql` - Creates all tables with relationships
   - `03_SeedData.sql` - Populates reference tables with D&D 5e data
   - `04_CreateViews.sql` - Creates helpful views for common queries
   - `05_CreateStoredProcedures.sql` - Creates stored procedures for common operations

## Usage Examples

The repository includes example queries for common operations:
- Creating a new character
- Leveling up a character
- Adding spells to a character's spellbook
- Viewing a character's stats at a specific level
- Managing inventory and equipment

## License

This project is licensed under the MIT License - see the LICENSE file for details.