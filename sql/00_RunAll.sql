-- =============================================
-- 00_RunAll.sql
-- Master script to run all SQL files in the correct order
-- =============================================

PRINT 'Starting DnD Character Tracker database setup...';
GO

-- Create the database
:r .\01_CreateDatabase.sql
GO

-- Create tables in the correct order (dependencies first)
PRINT 'Creating tables...';
GO

:r .\tables\Races.sql
GO

:r .\tables\Subraces.sql
GO

:r .\tables\Classes.sql
GO

:r .\tables\Subclasses.sql
GO

:r .\tables\Backgrounds.sql
GO

:r .\tables\Feats.sql
GO

:r .\tables\Spells.sql
GO

:r .\tables\ClassSpells.sql
GO

:r .\tables\Equipment.sql
GO

:r .\tables\Characters.sql
GO

:r .\tables\CharacterLevels.sql
GO

:r .\tables\CharacterClasses.sql
GO

:r .\tables\CharacterFeats.sql
GO

:r .\tables\CharacterSpells.sql
GO

:r .\tables\CharacterEquipment.sql
GO

:r .\tables\CharacterSkills.sql
GO

-- Create views
PRINT 'Creating views...';
GO

:r .\views\CharacterLevelView.sql
GO

-- Create stored procedures
PRINT 'Creating stored procedures...';
GO

:r .\stored_procedures\CreateCharacter.sql
GO

:r .\stored_procedures\LevelUpCharacter.sql
GO

PRINT 'DnD Character Tracker database setup completed successfully!';
GO