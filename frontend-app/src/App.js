import React, { useState } from 'react';
import axios from 'axios';

function App() {
  const [ingredients, setIngredients] = useState('');
  const [recipes, setRecipes] = useState([]);

  const handleInputChange = (e) => {
    setIngredients(e.target.value);
  };

  const handleSearch = () => {
    axios.get(process.env.REACT_APP_API_ENDPOINT, {
      params: {
        ingredients: ingredients.split(',').map((ingredient) => ingredient.trim()),
      },
    })
    .then((response) => {
      setRecipes(response.data);
    })
    .catch((error) => {
      console.error(error);
    });
  };
  return (
    <div className="App">
      <h1>Recipe Search</h1>
      <div>
        <input
          type="text"
          value={ingredients}
          onChange={handleInputChange}
          placeholder="Enter ingredients (comma-separated)"
        />
        <button onClick={handleSearch}>Search</button>
      </div>
      <div>
        {recipes.map((recipe) => (
          <div key={recipe.id}>
            <h2>{recipe.title}</h2>
            <p>Cook Time: {recipe.cook_time} minutes</p>
            <p>Prep Time: {recipe.prep_time} minutes</p>
            <h3>Ingredients:</h3>
            <ul>
              {recipe.ingredients.map((ingredient, index) => (
                <li key={index}>{ingredient}</li>
              ))}
            </ul>
            <p>Ratings: {recipe.ratings}</p>
            <p>Cuisine: {recipe.cuisine}</p>
            <p>Category: {recipe.category}</p>
            <p>Author: {recipe.author}</p>
            <img src={recipe.image} alt={recipe.title} />
          </div>
        ))}
      </div>
    </div>
  );
}

export default App;
