#vim
## select inner tag
`vit`
##  select whole tag block
`vat`
Note that, depending on where the cursor is, you may need to type `at` a few more times until the whole `<div>` is selected.

*e.g.*
Supposing the cursor is in a `<td>` you'd need `vatatatat` to select the whole `<div>`:
```html
<div>      ^  at
  <table>  |  at
		<tr>   |  at
			<td> | vat
```

## select method
`vab`
![[Pasted image 20230905095336.png]]
`vabob`
![[Pasted image 20230905095352.png]]


