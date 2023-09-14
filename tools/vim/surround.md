플러그인 작동 방식
- 감싸기(surround)(`ys`)
- 삭제(delete)(`ds`)
- 바꾸기(change)(`cs`)

_e.g. `*`가 커서위치 일 때_

| old text                | command   | new text                  |
| ----------------------- | --------- | ------------------------- |
| `"Hello *world!"`       | `ds"`     | `Hello world!`              |
| `[123+4*56]/2`          | `cs])`    | `(123+456)/2`             |
| `"Look ma, I'm *HTML!"` | `cs"<q>`  | <q>Look ma, I'm HTML!</q> |
| `if *x>3 {`             | `ysW(`    | `if ( x>3 ) {`            |
| `my $str = *whee!;`     | `vllllS'` | `my $str = 'whee!';`      |


---
# 감싸기
## 한 단어 감싸기

```
I am happy.
I am "happy".
```

> **ysiw"**  
> (`ys`: 감싸기; `iw`: 둘러싸고 싶은 단어 위에 커서가 위치한 상태의 전체 단어; `"`: "로 감싸기

## 한 줄 감싸기
```
I am happy; she is sad.
(I am happy; she is sad.)
```

> **yss)**  
> (`ys`: 감싸기 추가; `s`: 한줄 선택; `)` 한 줄을 괄호로 감싼다 )
> **Note**: 만약 `yss(`로 입력을 하게 되면 괄호 사이에 공간이 추가 된다. `( I am happy; she is sad. )`

## 태그로 단락 또는 한줄 감싸기
```
Hello World! How are you?
<p>Hello World! How are you?</p>
```
> `yss<p> `
> (`yss`: 감쌀(surround) 한줄을 선택; `<p> ` 태그를 추가한다.)

## 다중 단어 감싸기

```
I am very very happy.
I am *very very* happy.
```

> **ys2aw***
> (`ys`: 감싸기 추가; `2`: 감쌀 단어의 숫자; `aw`: 단어 주위; `*`: *로 깜싼다)

#### 다중 단어 태그로 감싸기
```
Hello World! How are you?
<h1>Hello World</h1>! How are you?
```

> `ys2aw<h1> `
> [다중 단어 감싸기](https://forteleaf.tistory.com/entry/VIM-Surroundvim-%EC%82%AC%EC%9A%A9%ED%95%98%EA%B8%B0#%EB%8B%A4%EC%A4%91-%EB%8B%A8%EC%96%B4-%EA%B0%90%EC%8B%B8%EA%B8%B0)와 동일하다.

## 선택 영역 감싸기

```
The solution is x + y = z. You responded wrongly.
The solution is `x + y = z`. You responded wrongly.
```

> **veeeeeS`**  
> 커서를 단어 x에 위치한 상태로`v`로 **Visual Mode**로 들어 간 후, `S` 선택 영역을 `` ` ``로 감싸기
---
# 제거
## 감싸기 삭제

```
"Hello World!"
Hello World
```

> **ds"**  
> (`ds`: 감싸기 삭제; `"`: 쌍따옴표 삭제하기

## 감싼 태그 제거

```
<em><p>Hello World!</p></em>
Hello World!
```

> **dstdst**  
> 감싼 태그를 삭제한다. 커서가 안쪽에 있으면, 안쪽 부터 삭제  
> 바깥에 커서가 위치하고 있으면, 바깥 쪽부터 제거한다.
---
# 변경

## 감싸기 변경

```
"Hello World!"
*Hello World!*
```

> **cs"***  
> (`cs`: 감싸기 변경; `"`: 변경 대상자; `*`: *로 변경)

## 태그 변경

```
<p>Hello World!</p>
<em>Hello World!</em>
```

> **cst**_  
> (`cst`: 감싸기 변경 태그; `<em> `: 새로운 태그명)_

---
# 일반적인 예제
## 계산식에 괄호 추가하기

```
3 + 2 + 5 + 7 / 4    # 괄호가 없기에 계산 결과가 달라진다.
3 + 2 + 5 + 7 / 4    # 3에 커서를 위치한 상태에서 veeeeS)iprint
(3 + 2 + 5 + 7) / 4
(3 + 2 + 5 + 7) / 4
print((3 + 2 + 5 + 7) / 4)
```
