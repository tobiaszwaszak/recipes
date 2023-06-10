import React, { useState } from 'react';
import axios from 'axios';

function App() {
  const [ingredients, setIngredients] = useState('');
  const [recipes, setRecipes] = useState([]);

  const handleInputChange = (e) => {
    setIngredients(e.target.value);
  };

  const handleSearch = () => {
    axios.get('http://localhost:3001/recipes', {
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
            {/* Display other recipe details */}
          </div>
        ))}
      </div>
    </div>
  );
}

export default App;
