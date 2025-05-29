-- # Citation for the following function:
-- # Date: 5/21/2025
-- # Copied from /OR/ Adapted from /OR/ Based on:
-- # Source URL: https://canvas.oregonstate.edu/courses/1999601/pages/exploration-implementing-cud-operations-in-your-app?module_item_id=25352968


-- #############################
-- CREATE Users
-- #############################
DROP PROCEDURE IF EXISTS sp_CreateUser;

DELIMITER //

CREATE PROCEDURE sp_CreateUser(
    IN p_firstName VARCHAR(50), 
    IN p_lastName VARCHAR(35), 
    IN p_email VARCHAR(35), 
    OUT p_userID INT)
BEGIN
    INSERT INTO Users (email, firstName, lastName) 
    VALUES (p_email, p_firstName, p_lastName);

    -- Store the ID of the last inserted row
    SELECT LAST_INSERT_ID() into p_userID;
    -- Display the ID of the last inserted person.
    SELECT LAST_INSERT_ID() AS 'new_user_id';

    -- Example of how to get the ID of the newly created person:
        -- CALL sp_CreatePerson('Theresa', 'Evans', 2, 48, @new_id);
        -- SELECT @new_id AS 'New Person ID';
END //

DELIMITER ;

-- # Citation for the following function:
-- # Date: 5/24/2025
-- # Copied from /OR/ Adapted from /OR/ Based on:
-- # Source URL: https://canvas.oregonstate.edu/courses/1999601/pages/exploration-implementing-cud-operations-in-your-app?module_item_id=25352968


-- #############################
-- CREATE Recipe
-- #############################
DROP PROCEDURE IF EXISTS sp_CreateRecipe;

DELIMITER //

CREATE PROCEDURE sp_CreateRecipe(
    IN p_userID INT, 
    IN p_title VARCHAR(200), 
    IN p_description VARCHAR(1000), 
    OUT p_recipeID INT)
BEGIN
    INSERT INTO Recipes (userID, title, description, createdOn) 
    VALUES (p_userID, p_title, p_description, (NOW()));

    -- Store the ID of the last inserted row
    SELECT LAST_INSERT_ID() into p_recipeID;
    -- Display the ID of the last inserted person.
    SELECT LAST_INSERT_ID() AS 'new_recipe_id';

END //

DELIMITER ;

-- # Citation for the following function:
-- # Date: 5/24/2025
-- # Copied from /OR/ Adapted from /OR/ Based on:
-- # Source URL: https://canvas.oregonstate.edu/courses/1999601/pages/exploration-implementing-cud-operations-in-your-app?module_item_id=25352968

-- #############################
-- CREATE Ingredients
-- #############################

DROP PROCEDURE IF EXISTS sp_CreateIngredient;

DELIMITER //

CREATE PROCEDURE sp_CreateIngredient(
    IN p_name VARCHAR(50), 
    OUT p_ingredientID INT)
BEGIN
    INSERT INTO Ingredients (name) 
    VALUES (p_name);

    -- Store the ID of the last inserted row
    SELECT LAST_INSERT_ID() into p_ingredientID;
    -- Display the ID of the last inserted ingredient.
    SELECT LAST_INSERT_ID() AS 'new_ingredient_id';

END //

DELIMITER ;

-- # Citation for the following function:
-- # Date: 5/27/2025
-- # Copied from /OR/ Adapted from /OR/ Based on:
-- # Source URL: https://canvas.oregonstate.edu/courses/1999601/pages/exploration-implementing-cud-operations-in-your-app?module_item_id=25352968


-- #############################
-- CREATE RecipeIngredient
-- #############################
DROP PROCEDURE IF EXISTS sp_CreateRI;

DELIMITER //

CREATE PROCEDURE sp_CreateRI(
    IN p_recipe_title VARCHAR(200), 
    IN p_ingredient_name VARCHAR(50), 
    IN p_quantity VARCHAR(50), 
    IN p_description VARCHAR(150),  
    OUT p_riID INT)
BEGIN
    INSERT INTO RecipeIngredients (recipeID, ingredientID, quantity, description) 
    VALUES ((SELECT Recipes.recipeID FROM Recipes WHERE Recipes.title = p_recipe_title), (SELECT Ingredients.ingredientID FROM Ingredients WHERE Ingredients.name = p_ingredient_name), p_quantity, p_description);

 -- Store the ID of the last inserted row
    SELECT LAST_INSERT_ID() into p_riID;
    -- Display the ID of the last inserted ingredient
    SELECT LAST_INSERT_ID() AS 'new_ri_id';

END //

DELIMITER ;

-- # Citation for the following function:
-- # Date: 5/27/2025
-- # Copied from /OR/ Adapted from /OR/ Based on:
-- # Source URL: https://canvas.oregonstate.edu/courses/1999601/pages/exploration-implementing-cud-operations-in-your-app?module_item_id=25352968


-- #############################
-- CREATE Instruction
-- #############################
DROP PROCEDURE IF EXISTS sp_CreateInstruction;

DELIMITER //

CREATE PROCEDURE sp_CreateInstruction(
    IN p_recipe_title VARCHAR(200),
    IN p_instructionText VARCHAR(2000), 
    IN p_sortOrder INT, 
    OUT p_instructionID INT)
BEGIN
    INSERT INTO Instructions (recipeID, instructionText, sortOrder) 
    VALUES ((SELECT Recipes.recipeID FROM Recipes WHERE Recipes.title = p_recipe_title), p_instructionText, p_sortOrder);

    -- Store the ID of the last inserted row
    SELECT LAST_INSERT_ID() into p_instructionID;
    -- Display the ID of the last inserted person.
    SELECT LAST_INSERT_ID() AS 'new_instruction_id';

END //

DELIMITER ;

-- # Citation for the following function:
-- # Date: 5/21/2025
-- # Copied from /OR/ Adapted from /OR/ Based on:
-- # Source URL: https://canvas.oregonstate.edu/courses/1999601/pages/exploration-implementing-cud-operations-in-your-app?module_item_id=25352968


-- #############################
-- UPDATE Users
-- #############################
DROP PROCEDURE IF EXISTS sp_UpdateUser;

DELIMITER //
CREATE PROCEDURE sp_UpdateUser(IN p_userID INT, IN p_firstName VARCHAR(35), IN p_lastName VARCHAR(35), IN p_email VARCHAR(50))

BEGIN
    UPDATE Users SET firstName = p_firstName, lastName = p_lastName, email = p_email WHERE userID = p_userID; 
END //
DELIMITER ;

-- # Citation for the following function:
-- # Date: 5/24/2025
-- # Copied from /OR/ Adapted from /OR/ Based on:
-- # Source URL: https://canvas.oregonstate.edu/courses/1999601/pages/exploration-implementing-cud-operations-in-your-app?module_item_id=25352968

-- #############################
-- UPDATE Recipe
-- #############################
DROP PROCEDURE IF EXISTS sp_UpdateRecipe;

DELIMITER //
CREATE PROCEDURE sp_UpdateRecipe(IN p_recipeID INT, IN p_title VARCHAR(35), IN p_description VARCHAR(35))

BEGIN
    UPDATE Recipes SET title = p_title, description = p_description, modifiedOn = (NOW()) WHERE recipeID = p_recipeID; 
END //
DELIMITER ;

-- # Citation for the following function:
-- # Date: 5/24/2025
-- # Copied from /OR/ Adapted from /OR/ Based on:
-- # Source URL: https://canvas.oregonstate.edu/courses/1999601/pages/exploration-implementing-cud-operations-in-your-app?module_item_id=25352968


-- #############################
-- UPDATE Ingredients
-- #############################
DROP PROCEDURE IF EXISTS sp_UpdateIngredient;

DELIMITER //
CREATE PROCEDURE sp_UpdateIngredient(
    IN p_ingredientID INT, 
    IN p_name VARCHAR(50))

BEGIN
    UPDATE Ingredients SET name = p_name WHERE ingredientID = p_ingredientID; 
END //
DELIMITER ;

-- # Citation for the following function:
-- # Date: 5/27/2025
-- # Copied from /OR/ Adapted from /OR/ Based on:
-- # Source URL: https://canvas.oregonstate.edu/courses/1999601/pages/exploration-implementing-cud-operations-in-your-app?module_item_id=25352968


-- #############################
-- UPDATE RecipeInstruction
-- #############################
DROP PROCEDURE IF EXISTS sp_UpdateRI;

DELIMITER //
CREATE PROCEDURE sp_UpdateRI(IN p_riID INT, IN p_recipe_title VARCHAR(200), IN p_ingredient_name VARCHAR(50), IN p_quantity VARCHAR(50), IN p_description VARCHAR(150))

BEGIN
    UPDATE RecipeIngredients SET recipeID = (SELECT Recipes.recipeID FROM Recipes WHERE Recipes.title = p_recipe_title), ingredientID = (SELECT Ingredients.ingredientID FROM Ingredients WHERE Ingredients.name = p_ingredient_name), quantity = p_quantity, description = p_description WHERE recipeIngredientID = p_riID; 
END //
DELIMITER ;

-- # Citation for the following function:
-- # Date: 5/27/2025
-- # Copied from /OR/ Adapted from /OR/ Based on:
-- # Source URL: https://canvas.oregonstate.edu/courses/1999601/pages/exploration-implementing-cud-operations-in-your-app?module_item_id=25352968


-- #############################
-- UPDATE Instruction
-- #############################
DROP PROCEDURE IF EXISTS sp_UpdateInstruction;

DELIMITER //
CREATE PROCEDURE sp_UpdateInstruction(IN p_instructionID INT, IN p_recipe_title VARCHAR(200), IN p_instructionText VARCHAR(2000), IN p_sortOrder INT)

BEGIN
    UPDATE Instructions SET  recipeID = (SELECT Recipes.recipeID FROM Recipes WHERE Recipes.title = p_recipe_title), instructionText = p_instructionText,
        sortOrder = p_sortOrder WHERE instructionID = p_instructionID; 
END //
DELIMITER ;

-- # Citation for the following function:
-- # Date: 5/22/2025
-- # Copied from /OR/ Adapted from /OR/ Based on:
-- # Source URL: https://canvas.oregonstate.edu/courses/1999601/pages/exploration-implementing-cud-operations-in-your-app?module_item_id=25352968

-- #############################
-- DELETE Users
-- #############################
DROP PROCEDURE IF EXISTS sp_DeleteUser;

DELIMITER //
CREATE PROCEDURE sp_DeleteUser(IN p_userID INT)
BEGIN
    DECLARE error_message VARCHAR(255); 

    -- error handling
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        -- Roll back the transaction on any error
        ROLLBACK;
        -- Propogate the custom error message to the caller
        RESIGNAL;
    END;

    START TRANSACTION;
        
        DELETE FROM Instructions WHERE recipeID IN (
            SELECT recipeID FROM Recipes WHERE userID = p_userID
        );
        DELETE FROM RecipeIngredients WHERE recipeID IN (
            SELECT recipeID FROM Recipes WHERE userID = p_userID
        );
        DELETE FROM Recipes WHERE userID = p_userID;
        DELETE FROM Users WHERE userID = p_userID;

        -- ROW_COUNT() returns the number of rows affected by the preceding statement.
        IF ROW_COUNT() = 0 THEN
            set error_message = CONCAT('No matching record found in Users for id: ', p_userID);
            -- Trigger custom error, invoke EXIT HANDLER
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = error_message;
        END IF;

    COMMIT;

END //
DELIMITER ;

-- # Citation for the following function:
-- # Date: 5/24/2025
-- # Copied from /OR/ Adapted from /OR/ Based on:
-- # Source URL: https://canvas.oregonstate.edu/courses/1999601/pages/exploration-implementing-cud-operations-in-your-app?module_item_id=25352968

-- #############################
-- DELETE Recipe
-- #############################
DROP PROCEDURE IF EXISTS sp_DeleteRecipe;

DELIMITER //
CREATE PROCEDURE sp_DeleteRecipe(IN p_recipeID INT)
BEGIN
    DECLARE error_message VARCHAR(255); 

    -- error handling
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        -- Roll back the transaction on any error
        ROLLBACK;
        -- Propogate the custom error message to the caller
        RESIGNAL;
    END;

    START TRANSACTION;
        
        DELETE FROM Instructions WHERE recipeID = p_recipeID;
        DELETE FROM RecipeIngredients WHERE recipeID = p_recipeID;
        DELETE FROM Recipes WHERE recipeID = p_recipeID;

        -- ROW_COUNT() returns the number of rows affected by the preceding statement.
        IF ROW_COUNT() = 0 THEN
            set error_message = CONCAT('No matching record found in Recipes for id: ', p_recipeID);
            -- Trigger custom error, invoke EXIT HANDLER
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = error_message;
        END IF;

    COMMIT;

END //
DELIMITER ;

-- # Citation for the following function:
-- # Date: 5/24/2025
-- # Copied from /OR/ Adapted from /OR/ Based on:
-- # Source URL: https://canvas.oregonstate.edu/courses/1999601/pages/exploration-implementing-cud-operations-in-your-app?module_item_id=25352968

-- #############################
-- DELETE Ingredient
-- #############################
DROP PROCEDURE IF EXISTS sp_DeleteIngredient;

DELIMITER //
CREATE PROCEDURE sp_DeleteIngredient(IN p_ingredientID INT)
BEGIN
    DECLARE error_message VARCHAR(255); 

    -- error handling
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        -- Roll back the transaction on any error
        ROLLBACK;
        -- Propogate the custom error message to the caller
        RESIGNAL;
    END;

    START TRANSACTION;
        
        DELETE FROM RecipeIngredients WHERE ingredientID = p_ingredientID;
        DELETE FROM Ingredients WHERE ingredientID = p_ingredientID;

        -- ROW_COUNT() returns the number of rows affected by the preceding statement.
        IF ROW_COUNT() = 0 THEN
            set error_message = CONCAT('No matching record found in Ingredients for id: ', p_ingredientID);
            -- Trigger custom error, invoke EXIT HANDLER
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = error_message;
        END IF;

    COMMIT;

END //
DELIMITER ;

-- # Citation for the following function:
-- # Date: 5/28/2025
-- # Copied from /OR/ Adapted from /OR/ Based on:
-- # Source URL: https://canvas.oregonstate.edu/courses/1999601/pages/exploration-implementing-cud-operations-in-your-app?module_item_id=25352968

-- #############################
-- DELETE RecipeInstruction
-- #############################
DROP PROCEDURE IF EXISTS sp_DeleteRI;

DELIMITER //
CREATE PROCEDURE sp_DeleteRI(IN p_riID INT)
BEGIN
    DECLARE error_message VARCHAR(255); 

    -- error handling
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        -- Roll back the transaction on any error
        ROLLBACK;
        -- Propogate the custom error message to the caller
        RESIGNAL;
    END;

    START TRANSACTION;
        
        DELETE FROM RecipeIngredients WHERE recipeIngredientID = p_riID;

        -- ROW_COUNT() returns the number of rows affected by the preceding statement.
        IF ROW_COUNT() = 0 THEN
            set error_message = CONCAT('No matching record found in RecipeIngredients for id: ', p_riID);
            -- Trigger custom error, invoke EXIT HANDLER
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = error_message;
        END IF;

    COMMIT;

END //
DELIMITER ;

-- # Citation for the following function:
-- # Date: 5/28/2025
-- # Copied from /OR/ Adapted from /OR/ Based on:
-- # Source URL: https://canvas.oregonstate.edu/courses/1999601/pages/exploration-implementing-cud-operations-in-your-app?module_item_id=25352968

-- #############################
-- DELETE Instruction
-- #############################
DROP PROCEDURE IF EXISTS sp_DeleteInstruction;

DELIMITER //
CREATE PROCEDURE sp_DeleteInstruction(IN p_instructionID INT)
BEGIN
    DECLARE error_message VARCHAR(255); 

    -- error handling
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        -- Roll back the transaction on any error
        ROLLBACK;
        -- Propogate the custom error message to the caller
        RESIGNAL;
    END;

    START TRANSACTION;
        
        DELETE FROM Instructions WHERE instructionID = p_instructionID;

        -- ROW_COUNT() returns the number of rows affected by the preceding statement.
        IF ROW_COUNT() = 0 THEN
            set error_message = CONCAT('No matching record found in Instructions for id: ', p_instructionID);
            -- Trigger custom error, invoke EXIT HANDLER
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = error_message;
        END IF;

    COMMIT;

END //
DELIMITER ;