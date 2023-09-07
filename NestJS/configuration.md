https://docs.nestjs.com/techniques/configuration

Nestjs 프로젝트 실행시에 미리 정의된 환경설정을 읽어와서 실행한다.
이때 <mark style="background: #FFB8EBA6;">환경변수</mark>를 통해서 가져오는 방법과 <mark style="background: #ABF7F7A6;">설정파일</mark>을 통해 가져오는 방법이 있다.

##### 환경변수
- 보안상 중요한 내용을 코드에 노출하지 않기 위해 사용
- 개발시에는 `.env` 파일을 이용해서 관리
- `.env`는 `.gitignore`에 추가해서 서버에 배포되지 않게 한다
- 서버에서는 프로파일에 export로 정의
- AWS의 ECS 같은 경우는 작업정의에서 정의
##### 설정파일
- 개발/운영등의 환경에 맞는 설정을 다르게 사용하기 위해 사용
- yaml 형식의 파일을 사용

## NestJS Config
Nestjs에서는 설정 파일을 쉽게 관리할 수 있도록 @nestjs/config 패키지를 제공한다.
`@nestjs/config` 패키지는 dotenv를 포함하고 있으므로 따로 설치하지 않아도 된다.
```shell
$ npm i @nestjs/config
```




