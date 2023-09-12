**기존**
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

**debounce 사용**
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
- `searchInput` 상태값이 변경될때마다 0.5초 후에 `searchAnimals()`를 호출한다
- `return () => clearTimeout(timer);` 부분: `useEffect`의 함수 내에서 반환한 함수는 컴포넌트가 언마운트되거나 `searchInput` 값이 변경되어 다시 렌더링될 때 실행된다. 이 부분은 컴포넌트가 언마운트되기 전에 이전에 설정한 타이머를 취소하는 역할을 합니다. `clearTimeout(timer)` 함수를 호출하여 설정한 타이머를 취소하고 메모리 누수를 방지합니다.

---
lodash 라이브러리를 이용한 debounce 구현
```shell
npm install lodash
```

```jsx
import React, { useState, useEffect } from 'react';
import './App.css';
import debounce from 'lodash/debounce';

function App() {
  const [searchInput, setSearchInput] = useState('');
  const [animals, setAnimals] = useState([]);

  useEffect(() => {
    const lastQuery = localStorage.getItem('lastQuery');
    if (lastQuery) {
      searchAnimals(lastQuery);
    }
  }, []);

  // lodash의 debounce 함수를 사용하여 디바운스 효과 적용
  const delayedSearch = debounce((value) => {
    searchAnimals(value);
  }, 500);

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
      <input
        type='search'
        value={searchInput}
        onChange={(e) => delayedSearch(e.target.value)} // 디바운스된 검색 함수 호출
      />
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
`lodash`의 `debounce` 함수를 사용하여 `delayedSearch` 함수를 생성하고, 입력 값이 변경될 때마다 이 함수가 호출됩니다. 이 함수는 입력 값이 변경되고 0.5초가 지난 후에 실제로 검색 요청을 보냅니다. 이렇게 함으로써 디바운스 효과를 쉽게 구현할 수 있습니다.