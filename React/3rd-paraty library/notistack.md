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
 2. `useSnackbar` hook으로 


