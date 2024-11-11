#### 개요
사내 문화 개선 프로젝트
막내의 커피 심부름 문화를 개선하여 여러 팀원들이 소통할 수 있는 장을 마련하여 보다 돈독한 팀관계 형성을 목적으로 한 프로젝트

#### 사용방법
1. 메뉴 접수를 위한 방을 생성한다.
2. 방 비밀번호 또는 초대 링크를 통해 접속하여 각자 메뉴를 접수한다.
3. 접수가 끝난 후 방을 마감하면 랜덤으로 배달원이 배정된다.

#### 구축정보
1. AWS EC2  인스턴스 생성 및 Load Balancers를 이용한 ssl 인증서 적용, Route 53 가비아 구매 도메인 연동
2. Docker 를 이용하여 proxy, api, web, db서버 구축 (nginx, mysql)
3. Laravel + MySql 을 이용해 RESTful API를 구축하기 위해 노력하였습니다.
4. ios, aos, web 을 구축하기 위해 flutter 를 사용하였습니다.

## docker-compose 를 이용한 proxy, web, api 세팅

#### 버전 정보
|server|type|version
|:--:|:--:|:--:
|web|nginx|1.25.1
|web|flutter|3.16.2

### 로그인
- flutter에서 이메일, 비밀번호의 유효성검사를 합니다
- Api 서버에 로그인 요청을 하여 token을 발급받아 로그인 세션을 유지합니다.
<img src="https://github.com/user-attachments/assets/1d101960-90d6-4581-b913-91a34a080eb4"  width="400"/>

### 회원가입
- fluuter에서 회원정보의 유효성검사를 합니다.
- Api 서버에서 계정 중복 확인 후 회원가입 처리 및 로그인 token을 발급합니다.
<img src="https://github.com/user-attachments/assets/12b4110f-775e-48df-837b-f669ede51c00"  width="400"/>

### 비밀번호찾기
- 이메일을 이용하여 비밀번호를 재발급받습니다.
<img src="https://github.com/user-attachments/assets/f0aa437b-fea4-40f9-b634-31721f736586"  width="400"/>

### 이용약관 & 개인정보처리방침
<img src="https://github.com/user-attachments/assets/7e035724-3e7e-4036-8a24-e10d1e743825"  width="400"/>

### 방생성
<img src="https://github.com/user-attachments/assets/d8d3c192-f965-4d83-9733-4ebbbb5cc2e0"  width="500"/>

### 방목록 전환
<img src="https://github.com/user-attachments/assets/01c0c56b-8521-4ae9-8451-e6f6cfbe828d"  width="500"/>

### 방입장
<img src="https://github.com/user-attachments/assets/c43dc925-12f9-4ded-a537-6fdf57c8b1ed"  width="500"/>

### 주문하기
- 메인과 서브로 주문이 가능하며, 메인메뉴가 품절일때, 서브메뉴를 확인하여 주문할 수 있습니다. 
<img src="https://github.com/user-attachments/assets/83e13794-ae67-4c3b-9d8b-23355d2cbe76"  width="500"/>

### 주문마감 & 주문오픈
- 주문 마감시 주문자 리스트중 랜덤으로 배달원이 배정됩니다.
- 마감된 주문방에서 재오픈시 추가 주문을 받을 수 있습니다.
<img src="https://github.com/user-attachments/assets/86d61a57-8102-460b-8e25-85340aece517"  width="500"/>

### 내정보 수정
<img src="https://github.com/user-attachments/assets/3ad7d10e-4fa6-4a8d-bc44-97f4c27f4930"  width="500"/>

