기존
```jsx
import { useState, useEffect } from 'react';
import './App.css';

function App() {
  const [loading, setLoading] = useState(false);
  const [input, setInput] = useState('');
  const [animals, setAnimals] = useState([]);

  useEffect(() => {
    const lastQuery = localStorage.getItem('lastQuery');
    search(lastQuery);
  }, []);

  async function search(input) {
    setLoading(true);
    setInput(input);

    try {
      const response = await fetch('http://localhost:5000?' + new URLSearchParams({ q: input }));
      const data = await response.json();
      setAnimals(data);
      localStorage.setItem('lastQuery', input);
    } catch (error) {
      console.error(error);
    } finally {
      setLoading(false);
    }
  }

  return (
    <main>
      <h1>Animal Farm</h1>
      <input type='text' value={input} placeholder='Search' onChange={(e) => search(e.target.value)} />
      {loading ? (
        <div>lodaing…</div>
      ) : (
        <ul>
          {animals.map((animal) => {
            return (
              <li key={animal.id}>
                <strong>{animal.type}</strong> {animal.name}({animal.age} years old)
              </li>
            );
          })}

          {animals.length === 0 && 'No animals found'}
        </ul>
      )}
    </main>
  );
}

export default App;
```


debounce 추가
```jsx
import { useState, useEffect } from 'react';
import './App.css';

function App() {
  const [input, setInput] = useState('');
  const [debouncedInput, setDebouncedInput] = useState('');
  const [animals, setAnimals] = useState([]);

  useEffect(() => {
    const lastQuery = localStorage.getItem('lastQuery');
    setInput(lastQuery);
    setDebouncedInput(lastQuery);
  }, []);

  useEffect(() => {
    const debounceTimer = setTimeout(() => {
      getAnimals(debouncedInput);
      localStorage.setItem('lastQuery', debouncedInput);
    }, 500);

    return () => clearTimeout(debounceTimer);
  }, [debouncedInput]);

  async function getAnimals(search) {
    try {
      const response = await fetch('http://localhost:5000?' + new URLSearchParams({ q: search }));
      const data = await response.json();
      setAnimals(data);
    } catch (error) {
      console.error(error);
    }
  }

  function handleOnChange(value) {
    setInput(value);
    setDebouncedInput(value);
  }

  return (
    <main>
      <h1>Animal Farm</h1>
      <input type='text' value={input} placeholder='Search' onChange={(e) => handleOnChange(e.target.value)} />
      <ul>
        {animals.map((animal) => {
          return (
            <li key={animal.id}>
              <strong>{animal.type}</strong> {animal.name}({animal.age} years old)
            </li>
          );
        })}

        {animals.length === 0 && 'No animals found'}
      </ul>
    </main>
  );
}

export default App;
```