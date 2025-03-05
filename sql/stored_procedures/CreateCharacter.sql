-- =============================================
-- CreateCharacter.sql
-- Creates a stored procedure to add a new character
-- =============================================

USE DnDCharacterTracker;
GO

-- Drop procedure if it exists
IF OBJECT_ID('dbo.CreateCharacter', 'P') IS NOT NULL
    DROP PROCEDURE dbo.CreateCharacter;
GO

CREATE PROCEDURE dbo.CreateCharacter
    @Name NVARCHAR(100),
    @PlayerName NVARCHAR(100),
    @RaceID INT,
    @SubraceID INT = NULL,
    @BackgroundID INT,
    @Alignment NVARCHAR(20),
    @Gender NVARCHAR(20) = NULL,
    @Age INT = NULL,
    @Height NVARCHAR(20) = NULL,
    @Weight NVARCHAR(20) = NULL,
    @EyeColor NVARCHAR(20) = NULL,
    @HairColor NVARCHAR(20) = NULL,
    @SkinColor NVARCHAR(20) = NULL,
    @Appearance NVARCHAR(MAX) = NULL,
    @Personality NVARCHAR(MAX) = NULL,
    @Ideals NVARCHAR(MAX) = NULL,
    @Bonds NVARCHAR(MAX) = NULL,
    @Flaws NVARCHAR(MAX) = NULL,
    @Backstory NVARCHAR(MAX) = NULL,
    @ClassID INT,
    @Strength INT,
    @Dexterity INT,
    @Constitution INT,
    @Intelligence INT,
    @Wisdom INT,
    @Charisma INT,
    @HitPoints INT,
    @Gold INT = 0,
    @Silver INT = 0,
    @Copper INT = 0,
    @CharacterID INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRANSACTION;
    
    BEGIN TRY
        -- Insert character
        INSERT INTO dbo.Characters (
            Name, PlayerName, RaceID, SubraceID, BackgroundID, Alignment, 
            Gender, Age, Height, Weight, EyeColor, HairColor, SkinColor,
            Appearance, Personality, Ideals, Bonds, Flaws, Backstory
        )
        VALUES (
            @Name, @PlayerName, @RaceID, @SubraceID, @BackgroundID, @Alignment,
            @Gender, @Age, @Height, @Weight, @EyeColor, @HairColor, @SkinColor,
            @Appearance, @Personality, @Ideals, @Bonds, @Flaws, @Backstory
        );
        
        -- Get the new character ID
        SET @CharacterID = SCOPE_IDENTITY();
        
        -- Get race information for ability score bonuses
        DECLARE @StrBonus INT, @DexBonus INT, @ConBonus INT, @IntBonus INT, @WisBonus INT, @ChaBonus INT;
        DECLARE @Speed INT;
        
        SELECT 
            @StrBonus = r.StrengthBonus,
            @DexBonus = r.DexterityBonus,
            @ConBonus = r.ConstitutionBonus,
            @IntBonus = r.IntelligenceBonus,
            @WisBonus = r.WisdomBonus,
            @ChaBonus = r.CharismaBonus,
            @Speed = r.Speed
        FROM dbo.Races r
        WHERE r.RaceID = @RaceID;
        
        -- Add subrace bonuses if applicable
        IF @SubraceID IS NOT NULL
        BEGIN
            SELECT 
                @StrBonus = @StrBonus + sr.StrengthBonus,
                @DexBonus = @DexBonus + sr.DexterityBonus,
                @ConBonus = @ConBonus + sr.ConstitutionBonus,
                @IntBonus = @IntBonus + sr.IntelligenceBonus,
                @WisBonus = @WisBonus + sr.WisdomBonus,
                @ChaBonus = @ChaBonus + sr.CharismaBonus
            FROM dbo.Subraces sr
            WHERE sr.SubraceID = @SubraceID;
        END
        
        -- Calculate final ability scores with racial bonuses
        SET @Strength = @Strength + @StrBonus;
        SET @Dexterity = @Dexterity + @DexBonus;
        SET @Constitution = @Constitution + @ConBonus;
        SET @Intelligence = @Intelligence + @IntBonus;
        SET @Wisdom = @Wisdom + @WisBonus;
        SET @Charisma = @Charisma + @ChaBonus;
        
        -- Calculate modifiers
        DECLARE @StrMod INT = FLOOR((@Strength - 10) / 2);
        DECLARE @DexMod INT = FLOOR((@Dexterity - 10) / 2);
        DECLARE @ConMod INT = FLOOR((@Constitution - 10) / 2);
        
        -- Calculate armor class (base 10 + Dex modifier)
        DECLARE @ArmorClass INT = 10 + @DexMod;
        
        -- Insert character level (starting at level 1)
        INSERT INTO dbo.CharacterLevels (
            CharacterID, Level, ExperiencePoints, HitPoints, MaxHitPoints,
            Strength, Dexterity, Constitution, Intelligence, Wisdom, Charisma,
            ProficiencyBonus, ArmorClass, Initiative, Speed, 
            CurrentHitDice, MaxHitDice, Gold, Silver, Copper
        )
        VALUES (
            @CharacterID, 1, 0, @HitPoints, @HitPoints,
            @Strength, @Dexterity, @Constitution, @Intelligence, @Wisdom, @Charisma,
            2, @ArmorClass, @DexMod, @Speed,
            1, 1, @Gold, @Silver, @Copper
        );
        
        -- Get the character level ID
        DECLARE @CharacterLevelID INT = SCOPE_IDENTITY();
        
        -- Insert character class
        INSERT INTO dbo.CharacterClasses (
            CharacterLevelID, ClassID, ClassLevel
        )
        VALUES (
            @CharacterLevelID, @ClassID, 1
        );
        
        -- Add background skill proficiencies
        DECLARE @Skill1 NVARCHAR(50), @Skill2 NVARCHAR(50);
        
        SELECT 
            @Skill1 = b.SkillProficiency1,
            @Skill2 = b.SkillProficiency2
        FROM dbo.Backgrounds b
        WHERE b.BackgroundID = @BackgroundID;
        
        -- Insert skill proficiencies
        INSERT INTO dbo.CharacterSkills (
            CharacterLevelID, SkillID, IsProficient
        )
        SELECT 
            @CharacterLevelID, s.SkillID, 1
        FROM dbo.Skills s
        WHERE s.Name IN (@Skill1, @Skill2);
        
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
    @value = N'Creates a new character with level 1 information, including ability scores, class, and background.',
    @level0type = N'SCHEMA', @level0name = N'dbo',
    @level1type = N'PROCEDURE', @level1name = N'CreateCharacter';
GO

PRINT 'CreateCharacter stored procedure created successfully.';
GO