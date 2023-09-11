기존
```jsx
import { useState, useEffect } from 'react';
import './App.css';

function App() {
  const [input, setInput] = useState('');
  const [animals, setAnimals] = useState([]);

  useEffect(() => {
    const lastQuery = localStorage.getItem('lastQuery');
    setInput(lastQuery);
  }, []);

  useEffect(() => {
    getAnimals(input);
    localStorage.setItem('lastQuery', input);
  }, [input]);

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


debounce 추가
```jsx
import { useState, useEffect } from 'react';
import './App.css';

function App() {
  const [input, setInput] = useState('');
  const [animals, setAnimals] = useState([]);

  useEffect(() => {
    // localStorage에서 검색어를 가져와 초기화합니다.
    const lastQuery = localStorage.getItem('lastQuery');
    if (lastQuery !== null) {
      setInput(lastQuery);
    }
  }, []);

  useEffect(() => {
    // 입력값이 변경될 때마다 debounce를 적용하여 검색합니다.
    const debounceTimer = setTimeout(() => {
      search(input);
      localStorage.setItem('lastQuery', input);
    }, 500);

    return () => clearTimeout(debounceTimer);
  }, [input]);

  async function search(query) {
    try {
      const response = await fetch('http://localhost:5000?' + new URLSearchParams({ q: query }));
      const data = await response.json();
      setAnimals(data);
    } catch (error) {
      console.error(error);
    }
  }

  function handleInputChange(value) {
    // 입력값을 업데이트하고 debounce를 위해 검색 함수를 호출합니다.
    setInput(value);
  }

  return (
    <main>
      <h1>Animal Farm</h1>
      <input
        type='text'
        value={input}
        placeholder='Search'
        onChange={(e) => handleInputChange(e.target.value)}
      />
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