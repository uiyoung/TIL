플러그인 작동 방식
- 감싸기(surround)(`ys`)
- 삭제(delete)(`ds`)
- 바꾸기(change)(`cs`)

| old text              | command  | new text                  |
| --------------------- | -------- | ------------------------- |
| "Hello* world!"       | ds"      | Hello world!              |
| [123+4*56]/2          | `cs])`   | (123+456)/2               |
| "Look ma, I'm *HTML!" | `cs"<q>` | <q>Look ma, I'm HTML!</q> |
|                       |          |                           |
## 한 단어 감싸기
I am happy