https://docs.nestjs.com/techniques/configuration

Nestjs 프로젝트 실행시에 미리 정의된 환경설정을 읽어와서 실행한다.
이때 <mark style="background: #FFB8EBA6;">환경변수</mark>를 통해서 가져오는 방법과 <mark style="background: #ABF7F7A6;">설정파일</mark>을 통해 가져오는 방법이 있다.

#### 환경변수
- 보안상 중요한 내용을 코드에 노출하지 않기 위해 사용
- 개발시에는 `.env` 파일을 이용해서 관리
- `.env`는 `.gitignore`에 추가해서 서버에 배포되지 않게 한다
- 서버에서는 프로파일에 export로 정의
- AWS는 ECS task definitions 에서 정의
#### 설정파일
- 개발/운영등의 환경에 맞는 설정을 다르게 사용하기 위해 사용
- yaml 형식의 파일을 사용

## NestJS Config
Nestjs에서는 설정 파일을 쉽게 관리할 수 있도록 `@nestjs/config` 패키지를 제공한다.
`@nestjs/config` 패키지는 dotenv를 포함하고 있으므로 따로 설치하지 않아도 된다.
```shell
$ npm i @nestjs/config
```

다음으로  AppModule에서 config를 사용할 수 있도록 `ConfigModule`을 import 한다.

```ts file:src/app.module.ts
import { ConfigModule } from '@nestjs/config';
…

@Module({
  imports: [
    ConfigModule.forRoot({
      isGlobal: true
    }),
    ….]
…
```
> isGlobal option은 다른 모듈에서 config를 사용할 수 있도록 global로 설정한다.

#### 환경 변수 정의
프로젝트 루트 폴더에 .env를 만들고 다음과 같이 작성한다.
```
NODE_ENV=development
NODE_SERVER_PORT=3000
```

main.ts 파일에서 다음과 같이 사용할 수 있다.
```ts file:main.ts
const port = process.env.NODE_SERVER_PORT
// …
await app.listen(port);
logger.log(`Application listening on port ${port}`);
```

#### ConfigService 사용하기
이제 ConfigService를 사용하도록 main.ts 를 변경한다.
- `@nestjs/config`의 `ConfigService`를 사용한다
- `configService.get('NODE_SERVER_PORT')`를 사용하여 port를 읽어온다.

```ts file:main.ts
import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import * as cookieParser from 'cookie-parser';
import { ConfigService } from "@nestjs/config";

async function bootstrap() {
  const app = await NestFactory.create(AppModule);
  app.use(cookieParser());
  const configService = app.get(ConfigService);
  const port = configService.get('NODE_SERVER_PORT');
  await app.listen(port);
  console.log(`Application listening on port ${port}`);
}
bootstrap();
```
서버를 실행해보면 이전과 동일하게 서버가 올라간다.

ConfigService를 다른 곳에서 사용하려면 constructor로 추가하면 된다.

```ts
import { ConfigService } from '@nestjs/config';
// …
constructor(private configService: ConfigService);
// …
configService.get('…');
```

#### Custom Configuration - 개발 / 운영 설정 파일을 분리하는 방법
yaml 파일 처리를 위해 js-yaml 패키지를 설치
```shell
npm i js-yaml @types/js-yaml
```

config 폴더를 만들고 다음과 같이 파일을 추가한다.

```yaml file:src/config/production.yaml
server:
  port: 3001
```

```yaml file:src/config/development.yaml
server:
  port: 3002
```
테스트를 위해 개발/운영 포트를 각각 다르게 준다.

config/config.ts 파일을 다음과 같이 만든다.

```ts file:src/config/config.ts
import { readFileSync } from 'fs';
import * as yaml from 'js-yaml';
import { join } from 'path';

const YAML_CONFIG_PROD = 'production.yaml';
const YAML_CONFIG_DEV = 'development.yaml';

export default () => {
  return yaml.load(
      (process.env.NODE_ENV === 'production')?
        readFileSync(join(__dirname, YAML_CONFIG_PROD), 'utf8')
      : readFileSync(join(__dirname, YAML_CONFIG_DEV), 'utf8'),
  ) as Record<string, any>;
};
```
환경변수의 NODE_ENV가 `production`일 경우는 production.yaml을 읽고 그외의 경우에는 development.yaml을 읽게 한다.

AppModule을 수정해서 load시 config.ts 정보를 가져오도록 한다.
```ts
import config from './config/config';
…
@Module({
  imports: [
    ConfigModule.forRoot({
      load: [config],
      isGlobal: true
    }),…
```

main.ts에서 config를 이용해 포트를 읽어오도록 변경한다
```ts
const configService = app.get(ConfigService);
const port = configService.get<string>('server.port');
```

이렇게 실행을 하면 에러가 나는데 yaml 파일을 읽을 수 없어서이다.
![[Pasted image 20230907183737.png]]
yaml은 ts파일이 아니기때문에 컴파일시에 dist 폴더로 copy가 되지 않으므로 파일을 찾을 수 없는 것이다.

package.json에서 script를 이용해 yaml을 copy하기 위해 다음 패키지를 설치한다.
```shell
npm i cpx
```

package.json을 다음과 같이 파일 복사 스크립트를 추가한다.

- scripts에 "copy-files"를 아래와 같이 추가
	- `"copy-files": "cpx \"src/config/*.yaml\" dist/config/",`
- start 및 build 스크립트에 `npm run copy-files` 를 추가
	```json file:package.json
	// …
	"scripts": {
	    "copy-files": "cpx \"src/config/*.yaml\" dist/config/",
	    "prebuild": "rimraf dist",
	    "build": "npm run copy-files && nest build",
	    "format": "prettier --write \"src/**/*.ts\" \"test/**/*.ts\"",
	    "start": "npm run copy-files && nest start",
	    "start:dev": "npm run copy-files && nest start --watch",
	    "start:debug": "npm run copy-files && nest start --debug --watch",
	    "start:prod": "npm run copy-files && node dist/main",
	// ...
	```

프로젝트 실행
```shell
npm run start:dev
```

.env의 `"NODE_ENV=development"`일 경우에는 3002번 포트로 서버가 실행된다.
![[attachments/de9d99200df0c903b8085f92ab860170_MD5.png]]

.env의 `"NODE_ENV=production"`일 경우에는 3001번 포트로 서버가 실행된다.
![[attachments/7f776ea12d459c0ef26f5a74fd3048dc_MD5.png]]

이렇게 환경 설정파일을 분리해서 개발과 운영의 환경을 다르게 설정할 수 있다.

---


> [!Question] `"start": "npm run copy-files && nest start"` 이렇게 하면 dist폴더에 yaml 파일이 복사된후 start 를 하면서 dist 폴더가 삭제후 다시 생성됩니다 그럼 yaml 파일도 삭제가 됩니다 어떻게 해야 할까요?
>  찾아보니 nest-cli.json 파일에 `"compilerOptions": { "deleteOutDir": true }` 이것때문에 계속 빌드할때마다 dist 폴더가 삭제후 다시 생성되고있었습니다
