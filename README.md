# HOXY

익명 만남 플랫폼
- 진행기간 : 2021. 01. 18 ~ 2021. 02. 21
- 사용기술 : Android Studio, Flutter, Firebase, Firestore, geolocator, geocoding, permission_handler

<p align="center"><img src="https://user-images.githubusercontent.com/55052074/111107641-9703d280-859a-11eb-833d-28d9f419d17d.jpg" width="30%"/> <img src="https://user-images.githubusercontent.com/55052074/111107650-99fec300-859a-11eb-8d2c-c64634b383ac.jpg" width="30%"/></p>

## 서비스 소개

- HOXY는 사람이 필요한 사람들을 위해 모임을 개설하고 주변 사람들을 쉽게 모을 수 있도록 도와주는 Flutter/iOS 기반의 플랫폼 앱입니다.
- 사용자의 위치정보를 통해 주변에서 개설된 모임 목록을 확인하고 이에 참여하거나 직접 모임을 개설합니다.
- 모임 개설/참여 시 생성되는 랜덤 닉네임과 이모지를 통해 익명모임을 진행합니다.
- 세가지 소통레벨(조용히 만나기, 대화 가능, 활발한 소통)로 모임을 나눠 혼밥, 액티비티 등 한사람 혹은 여러 사람이 필요한 다양한 경우의 모임을 주최할 수 있습니다.
- 채팅기능을 통해 참여자들이 실시간으로 소통하고 모임을 진행할 수 있습니다.
- 모임 이후 서로에 대한 평가 혹은 차단을 통한 이후 만남 거부 가능(예정)

## 상세 기능 소개

### 1. 회원가입

### 1-1. 회원가입

<p align="center"><img src="https://user-images.githubusercontent.com/55052074/111109632-7b023000-859e-11eb-916a-ae1ccfdf29fa.jpg" width="30%"/> <img src="https://user-images.githubusercontent.com/55052074/111109646-7f2e4d80-859e-11eb-8015-aa441c161748.jpg" width="30%"/> <img src="https://user-images.githubusercontent.com/55052074/111109651-80f81100-859e-11eb-8d17-083b74b8fa0c.jpg" width="30%"/></p>

- 로그인 화면에서 **회원가입** 선택시 해당 화면으로 이동하며, 현재 이메일 회원가입/로그인 기능 지원 (구글, 애플 로그인은 추후 예정)
- 이메일로 회원가입 시 휴대폰 인증을 통해 중복 가입을 방지합니다.
- 기본정보 입력 후 **진행하기** 버튼을 선택시 나오는 **정보설정** 화면에는 GPS 기반 사용자 위치를 받아 동네이름을 표시하고 이에 맞는 모임 목록을 불러옵니다, **사용연령 설정**은 모임 개설시 표시되는 정보로 타 사용자에게 제공되는 유일한 사용자 정보 입니다.

### 1-2. 로그인

<p align="center"><img src="https://user-images.githubusercontent.com/55052074/111109883-e946f280-859e-11eb-9a64-2de5ebe8ad91.jpg" width="30%"/></p>

- 이메일로 로그인은 Firebase Authentication을 사용합니다.

### 2. 모임 개설

<p align="center"><img src="https://user-images.githubusercontent.com/55052074/111109960-0bd90b80-859f-11eb-800e-e1f1082a8ba3.jpg" width="30%"/></p>

- 인원 모집 글을 게시하고 사람을 모집하거나 모집중인 모임에 참여할 수 있습니다.
- 현재 위치 또는 프로필 위치를 기준으로 5km 근방의 모집 글이 표시됩니다.
- 만나지 않기로 설정된 회원의 게시글이나 나를 만나지 않기로 설정한 회원의 게시글은 표시되지 않습니다.

### 2-1. 모집글 게시

<p align="center"><img src="https://user-images.githubusercontent.com/55052074/111110082-42168b00-859f-11eb-9de7-3f7ff920b787.jpg" width="30%"/> <img src="https://user-images.githubusercontent.com/55052074/111110087-45aa1200-859f-11eb-9994-3fcaf9f19ccf.jpg" width="30%"/> <img src="https://user-images.githubusercontent.com/55052074/111110088-46db3f00-859f-11eb-8839-7e220a0260a0.jpg" width="30%"/></p>

- 인원 모집 글을 게시할 수 있습니다.
- 현재 위치와 프로필 위치 중 어느 위치에 등록할 지 선택할 수 있습니다.
- 모집 인원, 소통레벨, 시작시간, 모임시간을 정하고 글을 게시합니다.
- 닉네임은 랜덤으로 생성됩니다.

### 2-2. 모집글 조회

<p align="center"><img src="https://user-images.githubusercontent.com/55052074/111110234-8144dc00-859f-11eb-87b8-c031fd7e63f5.jpg" width="30%"/> <img src="https://user-images.githubusercontent.com/55052074/111110242-86099000-859f-11eb-9239-407605785e8e.jpg" width="30%"/> <img src="https://user-images.githubusercontent.com/55052074/111110245-873abd00-859f-11eb-9d98-ecef49039427.jpg" width="30%"/>

- 모임 글 목록에서 글을 선택하면 모임의 내용이 표시됩니다.
- 본인의 글일 경우 상단바 우측 버튼을 통해  수정, 삭제가 가능합니다.
- 다른 사람의 글일 경우 불량 모임의 신고가 가능하며, 주최자와 만나지 않기를 선택해 해당 사용자와 서로의 글을 목록에서 숨길 수 있습니다.

### 2-3. 모임 참여

<p align="center"><img src="https://user-images.githubusercontent.com/55052074/111110763-79d20280-85a0-11eb-9141-86a8830708ba.jpg" width="30%"/> <img src="https://user-images.githubusercontent.com/55052074/111110774-80607a00-85a0-11eb-8a62-bb60672c3ce2.jpg" width="30%"/> <img src="https://user-images.githubusercontent.com/55052074/111110779-8191a700-85a0-11eb-9580-643491df5674.jpg" width="30%"/></p>

- 모집글의 하단 **신청하기** 버튼을 눌러 모임 참여가 가능합니다.
- 상단에 표시된 인원 만큼 신청 가능하며 인원충족시 모임신청이 불가합니다.
- 팝업에 모임에서 쓰일 닉네임이 랜덤으로 생성되어 표시되고, 취소 및 신청하기를 다시 선택 시 새로 생성된 닉네임을 사용 가능 합니다.
- 이미 신청된 모임이거나 인원이 모두 찬 모임에서는 신청하기 버튼이 비활성화 되며 참여할 수 없게 됩니다.

### 3. 채팅

<p align="center"><img src="https://user-images.githubusercontent.com/55052074/111110960-d2090480-85a0-11eb-9154-f8431cc530ad.jpg" width="30%"/></p>

- Firestore를 기반으로 실시간 채팅이 가능합니다.

### 3-1. 채팅

<p align="center"><img src="https://user-images.githubusercontent.com/55052074/111111031-efd66980-85a0-11eb-892b-a214253da945.jpg" width="30%"/></p>

- 모임 개설시 자동으로 생성되는 채팅방에서 모임 참가자들과 채팅을 진행할 수 있습니다.
- 상대 프로필 이모지를 누르거나 우측 드로어 메뉴에서 상대방 프로필을 확인할 수 있습니다.
- 드로어/사이드 메뉴는 모임장/본인/나머지 참여 인원 순서로 표시되며 본인이 모임장일 경우 하나로만 표시됩니다.

### 3-2. 상대 프로필
<p align="center"><img src="https://user-images.githubusercontent.com/55052074/111111078-054b9380-85a1-11eb-8d96-59e4225001fa.jpg" width="30%"/> <img src="https://user-images.githubusercontent.com/55052074/111111085-08df1a80-85a1-11eb-90db-9c5917f7171a.jpg" width="30%"></p>

- 기본적인 상대방 정보 확인과 상대방 차단이 가능합니다.

### 4. 마이페이지
<p align="center"><img src="https://user-images.githubusercontent.com/55052074/111111155-2d3af700-85a1-11eb-84ab-a9b3f3e1389f.jpg" width="30%"/></p>

- 본인의 프로필 이모지, 위치 등 정보를 관리할 수 있습니다.

### 4-1. 이모지 변경

<p align="center"><img src="https://user-images.githubusercontent.com/55052074/111111192-42178a80-85a1-11eb-8e54-36e64b415e6d.jpg" width="30%"/></p>

- 자신의 프로필 이모지를 변경할 수 있습니다.
- 이모지는 랜덤으로 선택되며 원하는 이모지가 아닐 경우 재시도 버튼을 통해 다시 랜덤 이모지를 생성할 수 있습니다.
- 원하는 이모지가 나오지 않을 경우 취소 버튼을 눌러 기존의 이모지로 되돌아갈 수 있습니다.

### 4-2. 위치 변경

<p align="center"><img src="https://user-images.githubusercontent.com/55052074/111111255-5eb3c280-85a1-11eb-9685-ad1935611e91.jpg" width="30%"/> <img src="https://user-images.githubusercontent.com/55052074/111111270-670bfd80-85a1-11eb-8871-8db4bba0650b.jpg" width="30%"/></p>

- 현재 위치를 재설정하거나 프로필 위치를 현재 위치로 변경할 수 있습니다.
- 위치 요청 시 위치 권한을 확인하고 현재 위치를 가져옵니다.

### 4-3. 차단 회원 목록

<p align="center"><img src="https://user-images.githubusercontent.com/55052074/111111352-8145db80-85a1-11eb-8f52-f415ce8b3b7e.jpg" width="30%"/></p>

- 차단한 회원의 목록을 열람하고, 차단을 해제할 수 있습니다.
- 차단을 해제하면 차단한 상대와 나에게 모두 서로의 글이 다시 보이게 됩니다.

## 보완 사항

- 구글/애플로그인 추가
- 모임에 대한 평가와 참가자 간 상호 리뷰 기능 필요

## 기타 사항

- iOS / AOS 다이얼로그, 액션시트 구분

<p align="center"><img src="https://user-images.githubusercontent.com/55052074/111111439-a76b7b80-85a1-11eb-99d5-09a55b1de05f.jpg" width="30%"/> <img src="https://user-images.githubusercontent.com/55052074/111111408-9884c900-85a1-11eb-890e-2f6ef1d101ab.png" width="30%"/></p>
<p align="center"><img src="https://user-images.githubusercontent.com/55052074/111111433-a33f5e00-85a1-11eb-99a8-5e1a085e262a.jpg" width="30%"/> <img src="https://user-images.githubusercontent.com/55052074/111111417-9b7fb980-85a1-11eb-8852-08b9a8b429e7.png" width="30%"/></p>
