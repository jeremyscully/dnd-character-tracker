-- =============================================
-- 01_CreateDatabase.sql
-- Creates the DnD Character Tracker database
-- =============================================

USE master;
GO

-- Drop database if it exists
IF EXISTS (SELECT name FROM sys.databases WHERE name = N'DnDCharacterTracker')
BEGIN
    ALTER DATABASE DnDCharacterTracker SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE DnDCharacterTracker;
END
GO

-- Create database
CREATE DATABASE DnDCharacterTracker;
GO

-- Set database options
ALTER DATABASE DnDCharacterTracker SET RECOVERY SIMPLE;
ALTER DATABASE DnDCharacterTracker SET AUTO_SHRINK OFF;
ALTER DATABASE DnDCharacterTracker SET AUTO_CREATE_STATISTICS ON;
ALTER DATABASE DnDCharacterTracker SET AUTO_UPDATE_STATISTICS ON;
GO

-- Use the new database
USE DnDCharacterTracker;
GO

-- Create a comment about the database
EXEC sp_addextendedproperty 
    @name = N'MS_Description', 
    @value = N'Database for tracking D&D characters and their progression over time, including races, classes, spells, equipment, and more.',
    @level0type = N'SCHEMA', @level0name = N'dbo';
GO

PRINT 'DnDCharacterTracker database created successfully.';
GO