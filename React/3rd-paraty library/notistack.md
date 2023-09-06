[notistack](https://notistack.com/getting-started)
Notistack is a React library which makes it super easy to display notifications on your web apps.

**install**
```bash
$ npm i notistack
```

**Usage**
1.  main.jsx 파일에서 `SnackbarProvider`를 import하고 `<App/>`을 감싼다
	```js
	//...
	import { SnackbarProvider } from 'notistack';
	
	ReactDOM.createRoot(document.getElementById('root')).render(
	  <React.StrictMode>
	    <BrowserRouter>
	      <SnackbarProvider>
	        <App />
	      </SnackbarProvider>
	    </BrowserRouter>
	  </React.StrictMode>
	);

	```
 SnackbarProvider 로 앱을 감싸주면 하위 컴포넌트 어디서든 props 로 접근해서 디스플레이 하는게 가능하다.
 2. `useSnackbar` hook을 이용해서 `enqueueSnackbar`, `closeSnackbar`를 사용한다.
	```tsx
	import { SnackbarProvider, useSnackbar } from 'notistack'
	
	const MyButton = () => {
	  const { enqueueSnackbar, closeSnackbar } = useSnackbar()
	  return (
	    <Button onClick={() => enqueueSnackbar('I love hooks')}>
	      Show snackbar
	    </Button>
	  )
	}
	```


[`enqueueSnackbar:`](https://notistack.com/#enqueuesnackbar)

Adds a snackbar to the queue to be displayed to the user. It takes two arguments `message` and an object of [`options`](https://notistack.com/api-reference) and returns a key that is used to reference that snackbar later on (e.g. to dismiss it programmatically).

```tsx
const key = enqueueSnackbar(message, options)

// or
const key = enqueueSnackbar({ message, ...options })
```

[`closeSnackbar:`](https://notistack.com/#closesnackbar)

Dismiss snackbar with the given key. You can close all snackbars at once by not passing a key to this function.

```tsx
// dismiss all open snackbars
closeSnackbar()

// dismiss a specific snackbar by passing 
// the key returned from enqueueSnackbar
closeSnackbar(key)
```


---
_e.g._

main.jsx
- Use `TI:"your title"` to add title
- Use `HL:"numbers"` to add highlight, such as `HL:"1,2,3"`, `HL:"1-3"`, separate by `,`
```jsx TI:"main.jsx" HL:1-5
// ...
import { SnackbarProvider } from 'notistack';

ReactDOM.createRoot(document.getElementById('root')).render(
  <React.StrictMode>
    <BrowserRouter>
      <SnackbarProvider>
        <App />
      </SnackbarProvider>
    </BrowserRouter>
  </React.StrictMode>
);

```

/pages/CreateBooks.jsx
```jsx

function CreateBooks() {
  const [title, setTitle] = useState('');
  const [author, setAuthor] = useState('');
  const [publishYear, setPublishYear] = useState('');
  const [loading, setLoading] = useState(false);

  const navigate = useNavigate();
  const { enqueueSnackbar } = useSnackbar();

  function handleSaveBook() {
    setLoading(true);

    const data = {
      title,
      author,
      publishYear,
    };

    fetch('http://localhost:5000/books', {
      headers: { 'Content-Type': 'application/json' },
      method: 'POST',
      body: JSON.stringify(data),
    })
      .then((res) => res.json())
      .then((data) => {
        setLoading(false);
        enqueueSnackbar('Book created successfully', { variant: 'success' });
        console.log(data);
        navigate('/');
      })
      .catch((err) => {
        setLoading(false);
        enqueueSnackbar('Error creating book', { variant: 'error' });
        console.error(err);
        alert('Error creating book');
      });
  }

  return (
   // ...
  );
}

export default CreateBooks;

```

성공시 메시지
[[attachments/9ac21ae2979270d8f7c683c71f36ee8c_MD5.png|Open: Pasted image 20230906163238.png]]
![[attachments/9ac21ae2979270d8f7c683c71f36ee8c_MD5.png]]
실패시 메시지
[[attachments/462e150a07e919fc0defdf40398c1a26_MD5.png|Open: Pasted image 20230906163623.png]]
![[attachments/462e150a07e919fc0defdf40398c1a26_MD5.png]]