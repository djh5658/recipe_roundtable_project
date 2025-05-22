/*
    Project Step 2
    Group 33: Alanna McCann and David Hall
    Last Updated: 05/22/2025
*/

/*
    Citations for disabling foreign key checks and autocommits:
    # Date: 04/29/2025
    # Copied from source URL: https://canvas.oregonstate.edu/courses/1999601/assignments/10006385?module_item_id=25352941

    Citations for usage of ON DELETE/ON UPDATE:
    # Date: 04/29/2025
    # Copied from Source URL: https://canvas.oregonstate.edu/courses/1999601/pages/exploration-mysql-cascade?module_item_id=25352939

    Citations for recipes (emails are fake):
    # Date: 04/29/2025
    # https://www.allrecipes.com/recipe/26317/chicken-pot-pie-ix/
    # https://www.spendwithpennies.com/easy-homemade-lasagna/
    # https://natashaskitchen.com/caesar-salad-recipe/
*/

-- #############################
-- RESET Tables
-- #############################
DROP PROCEDURE IF EXISTS sp_ResetTable;

DELIMITER //

CREATE PROCEDURE sp_ResetTable()
BEGIN

	SET FOREIGN_KEY_CHECKS=0;
	SET AUTOCOMMIT = 0;

	-- Statements to create tables

	CREATE OR REPLACE TABLE Users (
		userID int auto_increment NOT NULL,
		email varchar(50) unique NOT NULL,
		firstName varchar(35) NOT NULL,
		lastName varchar(35) NOT NULL,
		PRIMARY KEY (userID)
	);

	CREATE OR REPLACE TABLE Recipes (
		recipeID int auto_increment unique NOT NULL,
		userID int NOT NULL,
		title varchar(200) NOT NULL,
		description varchar(1000) NOT NULL,
		createdOn datetime NOT NULL,
		modifiedOn datetime,
		PRIMARY KEY (recipeID),
		FOREIGN KEY (userID) REFERENCES Users(userID) ON DELETE RESTRICT ON UPDATE CASCADE
	);

	CREATE OR REPLACE TABLE Ingredients (
		ingredientID int auto_increment unique NOT NULL,
		name varchar(50) NOT NULL,
		PRIMARY KEY (ingredientID)
	);

	CREATE OR REPLACE TABLE RecipeIngredients (
		recipeIngredientID int auto_increment unique NOT NULL,
		recipeID int NOT NULL,
		ingredientID int NOT NULL,
		quantity varchar(50) NOT NULL,
		description varchar(150),
		PRIMARY KEY (recipeIngredientID),
		FOREIGN KEY (recipeID) REFERENCES Recipes(recipeID) ON DELETE RESTRICT ON UPDATE CASCADE,
		FOREIGN KEY (ingredientID) REFERENCES Ingredients(ingredientID) ON DELETE RESTRICT ON UPDATE CASCADE
	);

	CREATE OR REPLACE TABLE Instructions (
		instructionID int auto_increment unique NOT NULL,
		recipeID int NOT NULL,
		instructionText varchar(2000) NOT NULL,
		sortOrder int NOT NULL, -- This is the sort order of the each instruction step within a recipe
		PRIMARY KEY (instructionID),
		FOREIGN KEY (recipeID) REFERENCES Recipes(recipeID) ON DELETE RESTRICT ON UPDATE CASCADE
	);

	-- Statements to insert sample data into tables

	INSERT INTO Users (email, firstName, lastName)
	VALUES  ('robbierice@hotmail.com', 'Robbie', 'Rice'),
			('hollynilson@outlook.com', 'Holly', 'Nilson'),
			('natashak@gmail.com', 'Natasha', 'Kravchuk');

	INSERT INTO Recipes (userID, title, description, createdOn)
	VALUES  ( 
				(SELECT userID FROM Users WHERE firstName = 'Robbie' AND lastName = 'Rice'), 
				'Chicken Pot Pie', 
				'A delicious chicken pie made from scratch with carrots, peas, and celery in a pre-made crust. Add thyme and poultry seasoning for more flavor.', 
				(NOW())
			),
			(
				(SELECT userID FROM Users WHERE firstName = 'Holly' AND lastName = 'Nilson'),
				'Lasagna',
				'In this classic lasagna recipe, sheets of pasta are layered with a cheesy filling, a rich meaty tomato sauce, and more cheese and then baked until bubbly and browned.',
				(NOW())
			),
			(
				(SELECT userID FROM Users WHERE firstName = 'Natasha' AND lastName = 'Kravchuk'), 
				'Caesar Salad', 
				'Classic Caesar Salad with crisp homemade croutons and a light caesar dressing - for when you want to impress your dinner guests.', (NOW())
			);
			
	INSERT INTO Instructions (recipeID, instructionText, sortOrder)
	VALUES  ( 
				(SELECT recipeID FROM Recipes WHERE title = 'Chicken Pot Pie'), 
				'Gather all ingredients and preheat the oven to 425 degrees F (220 degrees C.)', 
				1
			),
			( 
				(SELECT recipeID FROM Recipes WHERE title = 'Chicken Pot Pie'), 
				'Combine chicken, carrots, peas, and celery in a saucepan; add water to cover and bring to a boil. Boil for 15 minutes, then remove from the heat and drain.', 
				2
			),
			( 
				(SELECT recipeID FROM Recipes WHERE title = 'Chicken Pot Pie'), 
				'While chicken is cooking, melt butter in another saucepan over medium heat. Add onion and cook until soft and translucent, 5 to 7 minutes. Stir in flour, salt, pepper, and celery seed.', 
				3
			),
			( 
				(SELECT recipeID FROM Recipes WHERE title = 'Chicken Pot Pie'), 
				'Slowly stir in chicken broth and milk.', 
				4
			),
			( 
				(SELECT recipeID FROM Recipes WHERE title = 'Chicken Pot Pie'), 
				'Reduce heat to medium-low and simmer until thick, 5 to 10 minutes. Remove from heat and set aside.', 
				5
			),
			( 
				(SELECT recipeID FROM Recipes WHERE title = 'Chicken Pot Pie'), 
				'Place chicken and vegetables in the bottom pie crust. Pour hot broth mixture over top.', 
				6
			),
			( 
				(SELECT recipeID FROM Recipes WHERE title = 'Chicken Pot Pie'), 
				'Cover with top crust, seal the edges, and cut away any excess dough. Make several small slits in the top crust to allow steam to escape.', 
				7
			),
			( 
				(SELECT recipeID FROM Recipes WHERE title = 'Chicken Pot Pie'), 
				'Bake in the preheated oven until pastry is golden brown and filling is bubbly, 30 to 35 minutes. Cool for 10 minutes before serving.', 
				8
			),
			( 
				(SELECT recipeID FROM Recipes WHERE title = 'Lasagna'), 
				'Preheat the oven to 350°F. Bring a large pot of salted water to a boil. Add the lasagna noodles and cook until al dente (firm) according to package directions. Drain, rinse under cold water, and set aside.', 
				1
			),
			( 
				(SELECT recipeID FROM Recipes WHERE title = 'Lasagna'), 
				'Meanwhile, in a large skillet or Dutch oven, brown the beef, sausage, onion, and garlic over medium-high heat until no pink remains. Drain any fat.', 
				2
			),
			( 
				(SELECT recipeID FROM Recipes WHERE title = 'Lasagna'), 
				'Stir in the pasta sauce, tomato paste, Italian seasoning, ½ teaspoon of salt, and ¼ teaspoon of black pepper. Simmer uncovered over medium heat for 5 minutes or until slightly thickened. Taste and season with additional salt if desired.', 
				3
			),
			( 
				(SELECT recipeID FROM Recipes WHERE title = 'Lasagna'), 
				'In a separate medium bowl, combine 1 ½ cups mozzarella cheese, ¼ cup parmesan cheese, ricotta, parsley, egg, and ¼ teaspoon salt.', 
				4
			),
			( 
				(SELECT recipeID FROM Recipes WHERE title = 'Lasagna'), 
				'Spread 1 cup of the meat sauce in a 9×13 pan or casserole dish. Top it with 3 lasagna noodles. Layer with ⅓ of the ricotta cheese mixture and 1 cup of meat sauce. Repeat twice more. Finish with 3 noodles topped with remaining sauce.', 
				5
			),
			( 
				(SELECT recipeID FROM Recipes WHERE title = 'Lasagna'), 
				'Cover with foil and bake for 45 minutes.', 
				6
			),
			( 
				(SELECT recipeID FROM Recipes WHERE title = 'Lasagna'), 
				'Remove the foil and sprinkle the top of the lasagna with the remaining 2 ½ cups mozzarella cheese and ¼ cup parmesan cheese. Bake uncovered for an additional 15 minutes or until browned and bubbly. Broil for 2-3 minutes if desired.', 
				7
			),
			( 
				(SELECT recipeID FROM Recipes WHERE title = 'Lasagna'), 
				'Rest for at least 15 minutes before cutting.', 
				8
			),
			( 
				(SELECT recipeID FROM Recipes WHERE title = 'Caesar Salad'), 
				'Preheat oven to 350˚F. Cut the baguette in half lengthwise through the top of the baguette then slice diagonally into 1/4" thick pieces. Place the breads onto a baking sheet.', 
				1
			),
			( 
				(SELECT recipeID FROM Recipes WHERE title = 'Caesar Salad'), 
				'In a small bowl, combine 3 Tbsp extra virgin olive oil and 1 tsp of finely minced garlic. Drizzle the garlic oil over the croutons and sprinkle the top with 2 Tbsp grated parmesan cheese.', 
				2
			),
			( 
				(SELECT recipeID FROM Recipes WHERE title = 'Caesar Salad'), 
				'Toss until evenly coated. Spread in a single layer over the baking sheet and bake at 350˚F until light golden and crisp (10-12 minutes), or to desired crispness.', 
				3
			),
			( 
				(SELECT recipeID FROM Recipes WHERE title = 'Caesar Salad'), 
				'In a small bowl, whisk together garlic, dijon, Worcestershire, lemon juice and red wine vinegar.', 
				4
			),
			( 
				(SELECT recipeID FROM Recipes WHERE title = 'Caesar Salad'), 
				'Slowly drizzle in extra virgin olive oil while whisking constantly.', 
				5
			),
			( 
				(SELECT recipeID FROM Recipes WHERE title = 'Caesar Salad'), 
				'Whisk in 1/2 tsp salt and 1/8 tsp black pepper, or season to taste', 
				6
			),
			( 
				(SELECT recipeID FROM Recipes WHERE title = 'Caesar Salad'), 
				'Rinse, dry and chop or tear the romaine into bite-sized pieces. Place in a large serving bowl and sprinkle generously with shredded parmesan cheese and cooled croutons. Drizzle with caesar dressing and toss gently until lettuce is evenly coated.', 
				7
			);
			
	INSERT INTO Ingredients (name)
	VALUES  ( 
				'chicken breast'
			),
			(
				'carrots'
			),
			(
				'green peas'
			),
			(
				'celery'
			),
			(
				'butter'
			),
			(
				'onion'
			),
			(
				'all-purpose flour'
			),
			(
				'salt'
			),
			(
				'black pepper'
			),
			(
				'celery seed'
			),
			(
				'chicken broth'
			),
			(
				'milk'
			),
			(
				'(9-inch) unbaked pie crusts'
			),
			(
				'lasagna noodles'
			),
			(
				'mozzarella cheese'
			),
			(
				'ground beef'
			),
			(
				'Italian sausage'
			),
			(
				'garlic'
			),
			(
				'pasta sauce'
			),
			(
				'tomato paste'
			),
			(
				'Italian seasoning'
			),
			(
				'ricotta cheese'
			),
			(
				'parsley'
			),
			(
				'eggs'
			),
			(
				'French Baguette'
			),
			(
				'extra virgin olive oil'
			),
			(
				'parmesan cheese'
			),
			(
				'dijon mustard'
			),
			(
				'Worcestershire sauce'
			),
			(
				'lemon juice'
			),
			(
				'red wine vinegar'
			),
			(
				'romaine lettuce'
			);
			
	INSERT INTO RecipeIngredients (recipeID, ingredientID, quantity, description)
	VALUES  ( 
				(SELECT recipeID FROM Recipes WHERE title = 'Chicken Pot Pie'), 
				(SELECT ingredientID FROM Ingredients WHERE name = 'chicken breast'), 
				'1 pound',
				'skinless, boneless, halves - cubed'
			),
			(
				(SELECT recipeID FROM Recipes WHERE title = 'Chicken Pot Pie'), 
				(SELECT ingredientID FROM Ingredients WHERE name = 'carrots'), 
				'1 cup',
				'sliced'
			),
			(
				(SELECT recipeID FROM Recipes WHERE title = 'Chicken Pot Pie'), 
				(SELECT ingredientID FROM Ingredients WHERE name = 'green peas'), 
				'1 cup',
				'frozen'
			),
			(
				(SELECT recipeID FROM Recipes WHERE title = 'Chicken Pot Pie'), 
				(SELECT ingredientID FROM Ingredients WHERE name = 'celery'), 
				'1/2 cup',
				'sliced'
			),
			(
				(SELECT recipeID FROM Recipes WHERE title = 'Chicken Pot Pie'), 
				(SELECT ingredientID FROM Ingredients WHERE name = 'butter'), 
				'1/3 cup',
				NULL
			),
			(
				(SELECT recipeID FROM Recipes WHERE title = 'Chicken Pot Pie'), 
				(SELECT ingredientID FROM Ingredients WHERE name = 'onion'), 
				'1/3 cup',
				'chopped'
			),
			(
				(SELECT recipeID FROM Recipes WHERE title = 'Chicken Pot Pie'), 
				(SELECT ingredientID FROM Ingredients WHERE name = 'all-purpose flour'), 
				'1/3 cup',
				NULL
			),
			(
				(SELECT recipeID FROM Recipes WHERE title = 'Chicken Pot Pie'), 
				(SELECT ingredientID FROM Ingredients WHERE name = 'salt'), 
				'1/2 teaspoon',
				NULL
			),
			(
				(SELECT recipeID FROM Recipes WHERE title = 'Chicken Pot Pie'), 
				(SELECT ingredientID FROM Ingredients WHERE name = 'black pepper'), 
				'1/4 teaspoon',
				NULL
			),
			(
				(SELECT recipeID FROM Recipes WHERE title = 'Chicken Pot Pie'), 
				(SELECT ingredientID FROM Ingredients WHERE name = 'celery seed'), 
				'1/4 teaspoon',
				NULL
			),
			(
				(SELECT recipeID FROM Recipes WHERE title = 'Chicken Pot Pie'), 
				(SELECT ingredientID FROM Ingredients WHERE name = 'chicken broth'), 
				'1 3/4 cups',
				NULL
			),
			(
				(SELECT recipeID FROM Recipes WHERE title = 'Chicken Pot Pie'), 
				(SELECT ingredientID FROM Ingredients WHERE name = 'milk'), 
				'2/3 cup',
				NULL
			),
			(
				(SELECT recipeID FROM Recipes WHERE title = 'Chicken Pot Pie'), 
				(SELECT ingredientID FROM Ingredients WHERE name = '(9-inch) unbaked pie crusts'), 
				'2',
				NULL
			),
			(
				(SELECT recipeID FROM Recipes WHERE title = 'Lasagna'), 
				(SELECT ingredientID FROM Ingredients WHERE name = 'lasagna noodles'),
				'12',
				'uncooked'
			),
			(
				(SELECT recipeID FROM Recipes WHERE title = 'Lasagna'), 
				(SELECT ingredientID FROM Ingredients WHERE name = 'mozzarella cheese'),
				'4 cups',
				'shredded, divided'
			),
			(
				(SELECT recipeID FROM Recipes WHERE title = 'Lasagna'), 
				(SELECT ingredientID FROM Ingredients WHERE name = 'parmesan cheese'),
				'1/2 cup',
				'shredded and divided'
			),
			(
				(SELECT recipeID FROM Recipes WHERE title = 'Lasagna'), 
				(SELECT ingredientID FROM Ingredients WHERE name = 'salt'), 
				'3/4 teaspoon',
				NULL
			),
			(
				(SELECT recipeID FROM Recipes WHERE title = 'Lasagna'), 
				(SELECT ingredientID FROM Ingredients WHERE name = 'ground beef'),
				'1/2 pound',
				'lean'
			),
			(
				(SELECT recipeID FROM Recipes WHERE title = 'Lasagna'), 
				(SELECT ingredientID FROM Ingredients WHERE name = 'Italian sausage'),
				'1/2 pound',
				NULL
			),
			(
				(SELECT recipeID FROM Recipes WHERE title = 'Lasagna'), 
				(SELECT ingredientID FROM Ingredients WHERE name = 'onion'),
				'1 large (yellow)',
				'diced'
			),
			(
				(SELECT recipeID FROM Recipes WHERE title = 'Lasagna'), 
				(SELECT ingredientID FROM Ingredients WHERE name = 'garlic'),
				'2 cloves',
				'minced'
			),
			(
				(SELECT recipeID FROM Recipes WHERE title = 'Lasagna'), 
				(SELECT ingredientID FROM Ingredients WHERE name = 'pasta sauce'),
				'36 ounces',
				NULL
			),
			(
				(SELECT recipeID FROM Recipes WHERE title = 'Lasagna'), 
				(SELECT ingredientID FROM Ingredients WHERE name = 'tomato paste'),
				'2 tablespoons',
				NULL
			),
			(
				(SELECT recipeID FROM Recipes WHERE title = 'Lasagna'), 
				(SELECT ingredientID FROM Ingredients WHERE name = 'Italian seasoning'),
				'1 teaspoon',
				NULL
			),
			(
				(SELECT recipeID FROM Recipes WHERE title = 'Lasagna'), 
				(SELECT ingredientID FROM Ingredients WHERE name = 'ricotta cheese'),
				'2 cups',
				NULL
			),
			(
				(SELECT recipeID FROM Recipes WHERE title = 'Lasagna'), 
				(SELECT ingredientID FROM Ingredients WHERE name = 'parsley'),
				'1/4 cup',
				'chopped'
			),
			(
				(SELECT recipeID FROM Recipes WHERE title = 'Lasagna'), 
				(SELECT ingredientID FROM Ingredients WHERE name = 'eggs'),
				'1 Large',
				NULL
			),
			(
				(SELECT recipeID FROM Recipes WHERE title = 'Caesar Salad'), 
				(SELECT ingredientID FROM Ingredients WHERE name = 'French Baguette'),
				'1/2',
				NULL
			),
			(
				(SELECT recipeID FROM Recipes WHERE title = 'Caesar Salad'), 
				(SELECT ingredientID FROM Ingredients WHERE name = 'extra virgin olive oil'),
				'1/2 cup',
				NULL
			),
			(
				(SELECT recipeID FROM Recipes WHERE title = 'Caesar Salad'), 
				(SELECT ingredientID FROM Ingredients WHERE name = 'garlic'),
				'2 teaspoon',
				'minced'
			),
			(
				(SELECT recipeID FROM Recipes WHERE title = 'Caesar Salad'), 
				(SELECT ingredientID FROM Ingredients WHERE name = 'parmesan cheese'),
				'1/2 cup',
				'grated'
			),
			(
				(SELECT recipeID FROM Recipes WHERE title = 'Caesar Salad'), 
				(SELECT ingredientID FROM Ingredients WHERE name = 'dijon mustard'),
				'2 teaspoon',
				NULL
			),
			(
				(SELECT recipeID FROM Recipes WHERE title = 'Caesar Salad'), 
				(SELECT ingredientID FROM Ingredients WHERE name = 'Worcestershire sauce'),
				'1 teaspoon',
				NULL
			),
			(
				(SELECT recipeID FROM Recipes WHERE title = 'Caesar Salad'), 
				(SELECT ingredientID FROM Ingredients WHERE name = 'lemon juice'),
				'2 teaspoons',
				NULL
			),
			(
				(SELECT recipeID FROM Recipes WHERE title = 'Caesar Salad'), 
				(SELECT ingredientID FROM Ingredients WHERE name = 'red wine vinegar'),
				'1 1/2 teaspoon',
				NULL
			),
			(
				(SELECT recipeID FROM Recipes WHERE title = 'Caesar Salad'), 
				(SELECT ingredientID FROM Ingredients WHERE name = 'salt'),
				'1/2 teaspoon',
				NULL
			),
			(
				(SELECT recipeID FROM Recipes WHERE title = 'Caesar Salad'), 
				(SELECT ingredientID FROM Ingredients WHERE name = 'black pepper'),
				'1/8 teaspoon',
				NULL
			),
			(
				(SELECT recipeID FROM Recipes WHERE title = 'Caesar Salad'), 
				(SELECT ingredientID FROM Ingredients WHERE name = 'romaine lettuce'),
				'1 large head',
				NULL
			);

	SET FOREIGN_KEY_CHECKS=1;
	COMMIT;

END //

DELIMITER ;
