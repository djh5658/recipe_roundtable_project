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