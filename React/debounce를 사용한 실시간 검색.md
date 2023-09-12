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

  useEffect(() => {
    const timer = setTimeout(() => {
      searchAnimals(searchInput);
    }, 500);

    return () => clearTimeout(timer);
  }, [searchInput]);

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
      <input type='search' value={searchInput} onChange={(e) => setSearchInput(e.target.value)} />
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

```jsx
useEffect(() => {
	const timer = setTimeout(() => {
		searchAnimals(searchInput);
	}, 500);

	return () => clearTimeout(timer);
}, [searchInput]);
```
`searchInput` 상태값이 변경될때마다 0.5초 후에 `searchAnimals()`를 호출한다
