document.addEventListener('DOMContentLoaded', () => {

    // CREATE selectors (to be shared across all pages)
    const createSection = document.querySelector('.create-section');
    const createBtn = document.querySelector('.new-button');

    // UPDATE selectors (to be shared across all pages)
    const updateSection = document.querySelector('.update-section');
    const updateBtns = document.querySelectorAll('.update-button');

    // Users Only
    const userID = document.getElementById('update_user_id');
    const firstName = document.getElementById('update_user_firstName');
    const lastName = document.getElementById('update_user_lastName');
    const email = document.getElementById('update_user_email');
    // Recipes Only
    const recipeID = document.getElementById('update_recipe_id');
    const title = document.getElementById('update_recipe_title');
    const recipeDesc = document.getElementById('update_recipe_description');
    // Ingredients Only
    const ingredientID = document.getElementById('update_ingredient_id');
    const updateName = document.getElementById('update_ingredient_name');
    // Instructions Only
    const instructionID = document.getElementById('update_instruction_id');
    const instructionRecipe = document.getElementById('update_instruction_recipe_title');
    const instructionText = document.getElementById('update_instruction_text');
    const sortOrder = document.getElementById('update_instruction_sort_order');
    // RecipeIngredients Only
    const riRecipeTitle = document.getElementById('update_ri_recipe_title');
    const recipeIngredient = document.getElementById('update_recipe_ingredient');
    const riIngredientName = document.getElementById('update_ri_ingredient_name');
    const quantity = document.getElementById('update_ri_quantity');
    const note = document.getElementById('update_ri_note');


    // CANCEL selector
    const cancelBtns = document.querySelectorAll('.cancel-button');

    /******************* 
    ** CREATE SECTION **
    ********************/
    // When user clicks create button, reveal section
    createBtn.addEventListener('click', () => {
        createSection.classList.remove('hidden');
        createSection.scrollIntoView({ behavior: 'smooth' });
    });

    /*******************
    ** UPDATE SECTION **
    ********************/
    // When user clicks update next to a record, reveal section to edit
    updateBtns.forEach(btn => {
        btn.addEventListener('click', () => {
            updateSection.classList.remove('hidden');

            const type = btn.getAttribute('data-type');

            // USERS
            if (type === 'user') {
                // Set the visible (disabled) select value to show in UI
                userID.value = btn.getAttribute('data-userid');
                firstName.value = btn.getAttribute('data-firstname');
                lastName.value = btn.getAttribute('data-lastname');
                email.value = btn.getAttribute('data-email');
            }

            // RECIPES
            if (type === 'recipe') {
                recipeID.value = btn.getAttribute('data-recipeid');
                userID.value = btn.getAttribute('data-userid');
                title.value = btn.getAttribute('data-title');
                recipeDesc.value = btn.getAttribute('data-recipedesc');
            }

            // INGREDIENTS
            if (type === 'ingredient') {
                ingredientID.value = btn.getAttribute('data-ingredientid');
                updateName.value = btn.getAttribute('data-name');
            }

            // INSTRUCTIONS
            if (type === 'instruction') {
                instructionID.value = btn.getAttribute('data-instructionid');
                instructionRecipe.value = btn.getAttribute('data-recipe');
                instructionText.value = btn.getAttribute('data-text');
                sortOrder.value = btn.getAttribute('data-sort');
            }

            if (type === 'recipe-ingredient') {
                riRecipeTitle.value = btn.getAttribute('data-recipetitle');
                recipeIngredient.value = btn.getAttribute('data-recipeingredientid');
                riIngredientName.value = btn.getAttribute('data-ingredientname');
                quantity.value = btn.getAttribute('data-quantity');
                note.value = btn.getAttribute('data-note');
            }

            updateSection.scrollIntoView({ behavior: 'smooth' });
        });
    });

    /*******************
    ** CANCEL BUTTON ***
    ********************/

    cancelBtns.forEach(btn => {
        btn.addEventListener('click', () => {
            // When clicking "cancel," hide and reset CREATE form if visible
            if (!createSection.classList.contains('hidden')) {
                createSection.classList.add('hidden');
                createSection.querySelector('form').reset();
            }

            // When clicking "cancel," hide and reset UPDATE form if visible
            if (!updateSection.classList.contains('hidden')) {
                updateSection.classList.add('hidden');
                updateSection.querySelector('form').reset();
            }
        });
    });

})