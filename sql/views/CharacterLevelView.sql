-- =============================================
-- CharacterLevelView.sql
-- Creates a view to easily query character information at each level
-- =============================================

USE DnDCharacterTracker;
GO

-- Drop view if it exists
IF OBJECT_ID('dbo.CharacterLevelView', 'V') IS NOT NULL
    DROP VIEW dbo.CharacterLevelView;
GO

CREATE VIEW dbo.CharacterLevelView
AS
SELECT 
    cl.CharacterLevelID,
    c.CharacterID,
    c.Name AS CharacterName,
    c.PlayerName,
    r.Name AS Race,
    sr.Name AS Subrace,
    b.Name AS Background,
    cl.Level,
    cl.ExperiencePoints,
    cl.HitPoints,
    cl.MaxHitPoints,
    cl.Strength,
    cl.Dexterity,
    cl.Constitution,
    cl.Intelligence,
    cl.Wisdom,
    cl.Charisma,
    cl.ProficiencyBonus,
    cl.ArmorClass,
    cl.Initiative,
    cl.Speed,
    cl.Gold,
    cl.Silver,
    cl.Copper,
    cl.Electrum,
    cl.Platinum,
    STRING_AGG(CONCAT(cls.Name, ' ', cc.ClassLevel), ', ') WITHIN GROUP (ORDER BY cls.Name) AS Classes,
    STRING_AGG(sc.Name, ', ') WITHIN GROUP (ORDER BY sc.Name) AS Subclasses,
    (SELECT STRING_AGG(f.Name, ', ') WITHIN GROUP (ORDER BY f.Name)
     FROM dbo.CharacterFeats cf
     JOIN dbo.Feats f ON cf.FeatID = f.FeatID
     WHERE cf.CharacterLevelID = cl.CharacterLevelID) AS Feats,
    (SELECT COUNT(*)
     FROM dbo.CharacterSpells cs
     JOIN dbo.Spells s ON cs.SpellID = s.SpellID
     WHERE cs.CharacterLevelID = cl.CharacterLevelID AND cs.IsKnown = 1) AS SpellsKnown,
    (SELECT COUNT(*)
     FROM dbo.CharacterSpells cs
     JOIN dbo.Spells s ON cs.SpellID = s.SpellID
     WHERE cs.CharacterLevelID = cl.CharacterLevelID AND cs.IsPrepared = 1) AS SpellsPrepared
FROM 
    dbo.CharacterLevels cl
    JOIN dbo.Characters c ON cl.CharacterID = c.CharacterID
    JOIN dbo.Races r ON c.RaceID = r.RaceID
    LEFT JOIN dbo.Subraces sr ON c.SubraceID = sr.SubraceID
    JOIN dbo.Backgrounds b ON c.BackgroundID = b.BackgroundID
    LEFT JOIN dbo.CharacterClasses cc ON cl.CharacterLevelID = cc.CharacterLevelID
    LEFT JOIN dbo.Classes cls ON cc.ClassID = cls.ClassID
    LEFT JOIN dbo.Subclasses sc ON cc.SubclassID = sc.SubclassID
GROUP BY
    cl.CharacterLevelID,
    c.CharacterID,
    c.Name,
    c.PlayerName,
    r.Name,
    sr.Name,
    b.Name,
    cl.Level,
    cl.ExperiencePoints,
    cl.HitPoints,
    cl.MaxHitPoints,
    cl.Strength,
    cl.Dexterity,
    cl.Constitution,
    cl.Intelligence,
    cl.Wisdom,
    cl.Charisma,
    cl.ProficiencyBonus,
    cl.ArmorClass,
    cl.Initiative,
    cl.Speed,
    cl.Gold,
    cl.Silver,
    cl.Copper,
    cl.Electrum,
    cl.Platinum;
GO

-- Add view description
EXEC sp_addextendedproperty 
    @name = N'MS_Description', 
    @value = N'Provides a consolidated view of character information at each level, including classes, subclasses, feats, and spell counts.',
    @level0type = N'SCHEMA', @level0name = N'dbo',
    @level1type = N'VIEW', @level1name = N'CharacterLevelView';
GO

PRINT 'CharacterLevelView created successfully.';
GO