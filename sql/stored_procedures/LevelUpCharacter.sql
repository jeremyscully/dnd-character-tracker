-- =============================================
-- LevelUpCharacter.sql
-- Creates a stored procedure to level up a character
-- =============================================

USE DnDCharacterTracker;
GO

-- Drop procedure if it exists
IF OBJECT_ID('dbo.LevelUpCharacter', 'P') IS NOT NULL
    DROP PROCEDURE dbo.LevelUpCharacter;
GO

CREATE PROCEDURE dbo.LevelUpCharacter
    @CharacterID INT,
    @ClassID INT,
    @SubclassID INT = NULL,
    @ExperiencePoints INT,
    @HitPointsGained INT,
    @Strength INT = NULL,
    @Dexterity INT = NULL,
    @Constitution INT = NULL,
    @Intelligence INT = NULL,
    @Wisdom INT = NULL,
    @Charisma INT = NULL,
    @NewFeatID INT = NULL,
    @NewCharacterLevelID INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRANSACTION;
    
    BEGIN TRY
        -- Get current character level information
        DECLARE @CurrentLevel INT;
        DECLARE @CurrentMaxHP INT;
        DECLARE @CurrentStr INT, @CurrentDex INT, @CurrentCon INT, @CurrentInt INT, @CurrentWis INT, @CurrentCha INT;
        DECLARE @CurrentSpeed INT, @CurrentGold INT, @CurrentSilver INT, @CurrentCopper INT, @CurrentElectrum INT, @CurrentPlatinum INT;
        DECLARE @CurrentArmorClass INT, @CurrentInitiative INT;
        
        SELECT TOP 1
            @CurrentLevel = cl.Level,
            @CurrentMaxHP = cl.MaxHitPoints,
            @CurrentStr = cl.Strength,
            @CurrentDex = cl.Dexterity,
            @CurrentCon = cl.Constitution,
            @CurrentInt = cl.Intelligence,
            @CurrentWis = cl.Wisdom,
            @CurrentCha = cl.Charisma,
            @CurrentSpeed = cl.Speed,
            @CurrentGold = cl.Gold,
            @CurrentSilver = cl.Silver,
            @CurrentCopper = cl.Copper,
            @CurrentElectrum = cl.Electrum,
            @CurrentPlatinum = cl.Platinum,
            @CurrentArmorClass = cl.ArmorClass,
            @CurrentInitiative = cl.Initiative
        FROM dbo.CharacterLevels cl
        WHERE cl.CharacterID = @CharacterID
        ORDER BY cl.Level DESC;
        
        -- Calculate new level
        DECLARE @NewLevel INT = @CurrentLevel + 1;
        
        -- Calculate new proficiency bonus based on level
        DECLARE @NewProficiencyBonus INT = 2 + FLOOR((@NewLevel - 1) / 4);
        
        -- Use provided ability scores or keep current ones
        DECLARE @NewStr INT = ISNULL(@Strength, @CurrentStr);
        DECLARE @NewDex INT = ISNULL(@Dexterity, @CurrentDex);
        DECLARE @NewCon INT = ISNULL(@Constitution, @CurrentCon);
        DECLARE @NewInt INT = ISNULL(@Intelligence, @CurrentInt);
        DECLARE @NewWis INT = ISNULL(@Wisdom, @CurrentWis);
        DECLARE @NewCha INT = ISNULL(@Charisma, @CurrentCha);
        
        -- Calculate modifiers
        DECLARE @DexMod INT = FLOOR((@NewDex - 10) / 2);
        
        -- Calculate new armor class (base 10 + Dex modifier)
        DECLARE @NewArmorClass INT = 10 + @DexMod;
        
        -- Calculate new max hit points
        DECLARE @NewMaxHP INT = @CurrentMaxHP + @HitPointsGained;
        
        -- Insert new character level
        INSERT INTO dbo.CharacterLevels (
            CharacterID, Level, ExperiencePoints, HitPoints, MaxHitPoints,
            Strength, Dexterity, Constitution, Intelligence, Wisdom, Charisma,
            ProficiencyBonus, ArmorClass, Initiative, Speed, 
            CurrentHitDice, MaxHitDice, Gold, Silver, Copper, Electrum, Platinum
        )
        VALUES (
            @CharacterID, @NewLevel, @ExperiencePoints, @NewMaxHP, @NewMaxHP,
            @NewStr, @NewDex, @NewCon, @NewInt, @NewWis, @NewCha,
            @NewProficiencyBonus, @NewArmorClass, @DexMod, @CurrentSpeed,
            @NewLevel, @NewLevel, @CurrentGold, @CurrentSilver, @CurrentCopper, @CurrentElectrum, @CurrentPlatinum
        );
        
        -- Get the new character level ID
        SET @NewCharacterLevelID = SCOPE_IDENTITY();
        
        -- Check if this is a new class or an existing one
        DECLARE @IsNewClass BIT = 0;
        DECLARE @CurrentClassLevel INT = 0;
        
        -- Get the most recent character level ID
        DECLARE @PreviousCharacterLevelID INT;
        
        SELECT TOP 1 @PreviousCharacterLevelID = cl.CharacterLevelID
        FROM dbo.CharacterLevels cl
        WHERE cl.CharacterID = @CharacterID AND cl.Level = @CurrentLevel;
        
        -- Check if the character already has this class
        SELECT @CurrentClassLevel = cc.ClassLevel
        FROM dbo.CharacterClasses cc
        WHERE cc.CharacterLevelID = @PreviousCharacterLevelID AND cc.ClassID = @ClassID;
        
        IF @CurrentClassLevel = 0
        BEGIN
            SET @IsNewClass = 1;
            SET @CurrentClassLevel = 0;
        END
        
        -- Copy all existing classes from previous level
        INSERT INTO dbo.CharacterClasses (
            CharacterLevelID, ClassID, SubclassID, ClassLevel
        )
        SELECT 
            @NewCharacterLevelID, cc.ClassID, cc.SubclassID, cc.ClassLevel
        FROM dbo.CharacterClasses cc
        WHERE cc.CharacterLevelID = @PreviousCharacterLevelID
        AND cc.ClassID <> @ClassID; -- Don't copy the class being leveled up
        
        -- Add or update the class being leveled up
        INSERT INTO dbo.CharacterClasses (
            CharacterLevelID, ClassID, SubclassID, ClassLevel
        )
        VALUES (
            @NewCharacterLevelID, @ClassID, @SubclassID, @CurrentClassLevel + 1
        );
        
        -- Copy all existing feats from previous level
        INSERT INTO dbo.CharacterFeats (
            CharacterLevelID, FeatID, Notes
        )
        SELECT 
            @NewCharacterLevelID, cf.FeatID, cf.Notes
        FROM dbo.CharacterFeats cf
        WHERE cf.CharacterLevelID = @PreviousCharacterLevelID;
        
        -- Add new feat if provided
        IF @NewFeatID IS NOT NULL
        BEGIN
            INSERT INTO dbo.CharacterFeats (
                CharacterLevelID, FeatID
            )
            VALUES (
                @NewCharacterLevelID, @NewFeatID
            );
        END
        
        -- Copy all existing skills from previous level
        INSERT INTO dbo.CharacterSkills (
            CharacterLevelID, SkillID, IsProficient, HasExpertise, HasJackOfAllTrades, Bonus
        )
        SELECT 
            @NewCharacterLevelID, cs.SkillID, cs.IsProficient, cs.HasExpertise, cs.HasJackOfAllTrades, cs.Bonus
        FROM dbo.CharacterSkills cs
        WHERE cs.CharacterLevelID = @PreviousCharacterLevelID;
        
        -- Copy all existing spells from previous level
        INSERT INTO dbo.CharacterSpells (
            CharacterLevelID, SpellID, IsKnown, IsPrepared, InSpellbook, Notes
        )
        SELECT 
            @NewCharacterLevelID, cs.SpellID, cs.IsKnown, cs.IsPrepared, cs.InSpellbook, cs.Notes
        FROM dbo.CharacterSpells cs
        WHERE cs.CharacterLevelID = @PreviousCharacterLevelID;
        
        -- Copy all existing equipment from previous level
        INSERT INTO dbo.CharacterEquipment (
            CharacterLevelID, EquipmentID, Quantity, IsEquipped, IsAttuned, Location, Notes
        )
        SELECT 
            @NewCharacterLevelID, ce.EquipmentID, ce.Quantity, ce.IsEquipped, ce.IsAttuned, ce.Location, ce.Notes
        FROM dbo.CharacterEquipment ce
        WHERE ce.CharacterLevelID = @PreviousCharacterLevelID;
        
        COMMIT TRANSACTION;
        
        RETURN 0;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
        DECLARE @ErrorState INT = ERROR_STATE();
        
        RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState);
        
        RETURN -1;
    END CATCH
END
GO

-- Add procedure description
EXEC sp_addextendedproperty 
    @name = N'MS_Description', 
    @value = N'Levels up a character, creating a new character level record with updated stats and carrying over existing data.',
    @level0type = N'SCHEMA', @level0name = N'dbo',
    @level1type = N'PROCEDURE', @level1name = N'LevelUpCharacter';
GO

PRINT 'LevelUpCharacter stored procedure created successfully.';
GO