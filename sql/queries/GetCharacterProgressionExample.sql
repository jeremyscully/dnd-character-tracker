-- =============================================
-- GetCharacterProgressionExample.sql
-- Example query to view a character's progression over time
-- =============================================

USE DnDCharacterTracker;
GO

-- This query shows a character's progression across all levels
-- Replace @CharacterID with the actual character ID you want to view

DECLARE @CharacterID INT = 1; -- Replace with your character ID

-- Get basic character information
SELECT 
    c.CharacterID,
    c.Name AS CharacterName,
    c.PlayerName,
    r.Name AS Race,
    ISNULL(sr.Name, 'None') AS Subrace,
    b.Name AS Background,
    c.Alignment
FROM 
    dbo.Characters c
    JOIN dbo.Races r ON c.RaceID = r.RaceID
    LEFT JOIN dbo.Subraces sr ON c.SubraceID = sr.SubraceID
    JOIN dbo.Backgrounds b ON c.BackgroundID = b.BackgroundID
WHERE 
    c.CharacterID = @CharacterID;

-- Get character progression by level
SELECT 
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
    (
        SELECT STRING_AGG(CONCAT(cls.Name, ' ', cc.ClassLevel), ', ') 
        FROM dbo.CharacterClasses cc
        JOIN dbo.Classes cls ON cc.ClassID = cls.ClassID
        WHERE cc.CharacterLevelID = cl.CharacterLevelID
    ) AS Classes,
    (
        SELECT STRING_AGG(sc.Name, ', ') 
        FROM dbo.CharacterClasses cc
        JOIN dbo.Subclasses sc ON cc.SubclassID = sc.SubclassID
        WHERE cc.CharacterLevelID = cl.CharacterLevelID AND cc.SubclassID IS NOT NULL
    ) AS Subclasses,
    (
        SELECT STRING_AGG(f.Name, ', ') 
        FROM dbo.CharacterFeats cf
        JOIN dbo.Feats f ON cf.FeatID = f.FeatID
        WHERE cf.CharacterLevelID = cl.CharacterLevelID
    ) AS Feats,
    (
        SELECT COUNT(*)
        FROM dbo.CharacterSpells cs
        WHERE cs.CharacterLevelID = cl.CharacterLevelID AND cs.IsKnown = 1
    ) AS SpellsKnown,
    cl.CreatedDate AS LevelDate
FROM 
    dbo.CharacterLevels cl
WHERE 
    cl.CharacterID = @CharacterID
ORDER BY 
    cl.Level;

-- Get spells known at the most recent level
DECLARE @LatestLevelID INT;

SELECT TOP 1 @LatestLevelID = cl.CharacterLevelID
FROM dbo.CharacterLevels cl
WHERE cl.CharacterID = @CharacterID
ORDER BY cl.Level DESC;

SELECT 
    s.Name AS SpellName,
    s.Level AS SpellLevel,
    s.School,
    CASE WHEN cs.IsPrepared = 1 THEN 'Yes' ELSE 'No' END AS IsPrepared,
    CASE WHEN cs.InSpellbook = 1 THEN 'Yes' ELSE 'No' END AS InSpellbook
FROM 
    dbo.CharacterSpells cs
    JOIN dbo.Spells s ON cs.SpellID = s.SpellID
WHERE 
    cs.CharacterLevelID = @LatestLevelID AND cs.IsKnown = 1
ORDER BY 
    s.Level, s.Name;

-- Get equipment at the most recent level
SELECT 
    e.Name AS EquipmentName,
    e.Type AS EquipmentType,
    ce.Quantity,
    CASE WHEN ce.IsEquipped = 1 THEN 'Yes' ELSE 'No' END AS IsEquipped,
    CASE WHEN ce.IsAttuned = 1 THEN 'Yes' ELSE 'No' END AS IsAttuned,
    ce.Location
FROM 
    dbo.CharacterEquipment ce
    JOIN dbo.Equipment e ON ce.EquipmentID = e.EquipmentID
WHERE 
    ce.CharacterLevelID = @LatestLevelID
ORDER BY 
    e.Type, e.Name;
GO