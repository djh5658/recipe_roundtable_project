// ########################################
// ########## SETUP

// Express
const express = require('express');
const app = express();
app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use(express.static('public'));

const PORT = 3300;

// Database
const db = require('./database/db-connector');

// Handlebars
const { engine } = require('express-handlebars'); // Import express-handlebars engine
app.engine('.hbs', engine({ extname: '.hbs' })); // Create instance of handlebars
app.set('view engine', '.hbs'); // Use handlebars engine for *.hbs files.

// ########################################
// ########## ROUTE HANDLERS

// READ ROUTES

app.get('/', async function (req, res) {
    try {
        res.render('home'); // Render the home.hbs file
    } catch (error) {
        console.error('Error rendering page:', error);
        // Send a generic error message to the browser
        res.status(500).send('An error occurred while rendering the page.');
    }
});

app.get('/users', async function (req, res) {
    try {
        // Create and execute our queries
        // In query1, we use a JOIN clause to display the names of the homeworlds
        const query1 = `SELECT * FROM Users;`;
        const [users] = await db.query(query1);

        // Render the bsg-people.hbs file, and also send the renderer
        //  an object that contains our bsg_people and bsg_homeworld information
        res.render('users', { users: users, });
    } catch (error) {
        console.error('Error executing queries:', error);
        // Send a generic error message to the browser
        res.status(500).send(
            'An error occurred while executing the database queries.'
        );
    }
});

app.get('/recipes', async function (req, res) {
    try {
        // Create and execute our queries

        const query1 = `SELECT Recipes.recipeID, CONCAT(Users.firstName, ' ', Users.lastName) AS 'user', \
        Recipes.userID, Recipes.title, Recipes.description, Recipes.createdOn, Recipes.modifiedOn \
        FROM Recipes JOIN Users ON Recipes.UserID = Users.UserID;`;
        const query2 = `SELECT r.recipeID, r.title, i.sortOrder, i.instructionText \
        FROM Recipes AS r \
        JOIN Instructions AS i ON i.recipeID = r.recipeID \
        ORDER BY r.recipeID, i.sortOrder ASC; `
        const [recipes] = await db.query(query1);
        const [recipeDetails] = await db.query(query2)

        // Render the recips.hbs file, and also send the renderer
        //  an object that contains our recipe information
        res.render('recipes', { recipes: recipes, recipeDetails: recipeDetails });
    } catch (error) {
        console.error('Error executing queries:', error);
        // Send a generic error message to the browser
        res.status(500).send(
            'An error occurred while executing the database queries.'
        );
    }
});

app.get('/ingredients', async function (req, res) {
    try {
        // Create and execute our queries
        // In query1, we use a JOIN clause to display the names of the homeworlds
        const query1 = `SELECT * FROM Ingredients;`;
        const [ingredients] = await db.query(query1);

        // Render the bsg-people.hbs file, and also send the renderer
        //  an object that contains our bsg_people and bsg_homeworld information
        res.render('ingredients', { ingredients: ingredients, });
    } catch (error) {
        console.error('Error executing queries:', error);
        // Send a generic error message to the browser
        res.status(500).send(
            'An error occurred while executing the database queries.'
        );
    }
});

app.get('/recipe-ingredients', async function (req, res) {
    try {
        // Create and execute our queries
        // In query1, we use a JOIN clause to display the names of the homeworlds
        const query1 = `SELECT ri.recipeID, r.title, ri.ingredientID, i.name, ri.quantity, ri.description \
        FROM RecipeIngredients AS ri \
        JOIN Recipes AS r ON ri.recipeID = r.recipeID \ 
        JOIN Ingredients AS i ON ri.ingredientID = i.ingredientID \ 
        ORDER BY ri.recipeID, i.name ASC;`;
        const [recipeIngredients] = await db.query(query1);

        // Render the bsg-people.hbs file, and also send the renderer
        //  an object that contains our bsg_people and bsg_homeworld information
        res.render('recipe-ingredients', { recipeIngredients: recipeIngredients, });
    } catch (error) {
        console.error('Error executing queries:', error);
        // Send a generic error message to the browser
        res.status(500).send(
            'An error occurred while executing the database queries.'
        );
    }
});

app.get('/instructions', async function (req, res) {
    try {
        // Create and execute our queries
        // In query1, we use a JOIN clause to display the names of the homeworlds
        const query1 = `SELECT Instructions.instructionID, Recipes.title, \
        Instructions.instructionText, Instructions.sortOrder\
        FROM Instructions JOIN Recipes ON Instructions.recipeID = Recipes.recipeID `;
        const query2 = `SELECT Recipes.title, Recipes.recipeID FROM Recipes;`

        const [instructions] = await db.query(query1);
        const [recipes] = await db.query(query2);

        // Render the bsg-people.hbs file, and also send the renderer
        //  an object that contains our bsg_people and bsg_homeworld information
        res.render('instructions', { instructions: instructions, recipes: recipes });
    } catch (error) {
        console.error('Error executing queries:', error);
        // Send a generic error message to the browser
        res.status(500).send(
            'An error occurred while executing the database queries.'
        );
    }
});

// Reset Tables
app.post('/reset', async function (req, res) {
    try {
        // Call the stored procedure
        const [reset] = await db.query('CALL sp_ResetTable();');

        console.log('Table Successfully Reset');

        // Redirect the user to the updated webpage
        res.render('home');
    } catch (error) {
        console.error('Error executing queries:', error);
        res.status(500).send('An error occurred while executing the database queries.');
    }
});

// # Citation for the following function:
// # Date: 5/21/2025
// # Copied from /OR/ Adapted from /OR/ Based on:
// # Source URL: https://canvas.oregonstate.edu/courses/1999601/pages/exploration-implementing-cud-operations-in-your-app?module_item_id=25352968


// CREATE ROUTES
app.post('/users/create', async function (req, res) {
    try {
        // Parse frontend form information
        let data = req.body;

        // Create and execute our queries
        // Using parameterized queries (Prevents SQL injection attacks)
        const query1 = `CALL sp_CreateUser(?, ?, ?, @new_user_id);`;

        // Store ID of last inserted row
        const [[[rows]]] = await db.query(query1, [
            data.create_user_firstName,
            data.create_user_lastName,
            data.create_user_email,
        ]);

        console.log(`CREATE user. ID: ${rows.new_user_id} ` +
            `Name: ${data.create_user_firstName} ${data.create_user_lastName}`
        );

        // Redirect the user to the updated webpage
        res.redirect('/users');
    } catch (error) {
        console.error('Error executing queries:', error);
        // Send a generic error message to the browser
        res.status(500).send(
            'An error occurred while executing the database queries.'
        );
    }
});

// # Citation for the following function:
// # Date: 5/21/2025
// # Copied from /OR/ Adapted from /OR/ Based on:
// # Source URL: https://canvas.oregonstate.edu/courses/1999601/pages/exploration-implementing-cud-operations-in-your-app?module_item_id=25352968

// UPDATE ROUTES
app.post('/users/update', async function (req, res) {
    try {
        // Parse frontend form information
        const data = req.body;

        // Create and execute our query
        // Using parameterized queries (Prevents SQL injection attacks)
        const query1 = 'CALL sp_UpdateUser(?, ?, ?, ?);';
        const query2 = 'SELECT firstName, lastName, email FROM Users WHERE UserID = ?;';
        await db.query(query1, [
            data.update_user_id,
            data.update_user_firstName,
            data.update_user_lastName,
            data.update_user_email,
        ]);
        const [[rows]] = await db.query(query2, [data.update_user_id]);

        console.log(`UPDATE Users. ID: ${data.update_user_id} ` +
            `Name: ${rows.firstName} ${rows.lastName}`
        );

        // Redirect the user to the updated webpage data
        res.redirect('/users');
    } catch (error) {
        console.error('Error executing queries:', error);
        // Send a generic error message to the browser
        res.status(500).send(
            'An error occurred while executing the database queries.'
        );
    }
});

// # Citation for the following function:
// # Date: 5/21/2025
// # Copied from /OR/ Adapted from /OR/ Based on:
// # Source URL: https://canvas.oregonstate.edu/courses/1999601/pages/exploration-implementing-cud-operations-in-your-app?module_item_id=25352968

// DELETE ROUTES
app.post('/users/delete', async function (req, res) {
    try {
        // Parse frontend form information
        let data = req.body;

        // Create and execute our query
        // Using parameterized queries (Prevents SQL injection attacks)
        const query1 = `CALL sp_DeleteUser(?);`;
        await db.query(query1, [data.delete_person_id]);

        console.log(`DELETE user. ID: ${data.delete_person_id} ` +
            `Name: ${data.delete_person_name}`
        );

        // Redirect the user to the updated webpage data
        res.redirect('/users');
    } catch (error) {
        console.error('Error executing queries:', error);
        // Send a generic error message to the browser
        res.status(500).send(
            'An error occurred while executing the database queries.'
        );
    }
});

// ########################################
// ########## LISTENER

app.listen(PORT, function () {
    console.log(
        'Express started on http://localhost:' +
        PORT +
        '; press Ctrl-C to terminate.'
    );
});