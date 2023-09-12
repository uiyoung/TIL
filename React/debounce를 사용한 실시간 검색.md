기존
```jsx
import { useState, useEffect } from 'react';
import './App.css';

function App() {
  const [searchInput, setSearchInput] = useState('');
  const [animals, setAnimals] = useState([]);

  useEffect(() => {
    const lastQuery = localStorage.getItem('lastQuery');
    if (lastQuery) {
      searchAnimals(lastQuery);
    } else {
      searchAnimals('');
    }
  }, []);

  async function searchAnimals(value) {
    setSearchInput(value);

    try {
      const response = await fetch('http://localhost:5000?' + new URLSearchParams({ q: value }));
      if (!response.ok) {
        throw new Error('Network response was not ok');
      }
      const data = await response.json();
      setAnimals(data);
      localStorage.setItem('lastQuery', value);
    } catch (error) {
      console.error(error);
    }
  }

  return (
    <>
      <input type='search' value={searchInput} onChange={(e) => searchAnimals(e.target.value)} />
      <hr />
      <ul>
        {animals.map((animal) => {
          return (
            <li key={animal.id}>
              <strong>{animal.type}</strong> {animal.name}({animal.age} years old)
            </li>
          );
        })}
        {animals.length <= 0 && 'No animals found'}
      </ul>
    </>
  );
}

export default App;
```

위의 코드는 인풋 요소의 `onChange` 핸들러가 매 입력마다 즉시 서버에 요청을 보내므로 네트워크 트래픽이 폭주할 수 있습니다. 입력이 완료된 후에 요청을 보내는 것이 더 효율적일 수 있습니다. 이를 위해 타이머를 사용하여 입력이 멈출 때까지 기다리고 요청을 보내도록 변경할 수 있습니다.

debounce 사용
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