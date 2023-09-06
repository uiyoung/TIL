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
	
	// wrap your app
	<SnackbarProvider>
	  <App />
	  <MyButton />
	</SnackbarProvider>
	
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