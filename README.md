# DDANZI_iOS
애물딴지가 되기 전에, 모바일 배송상품 거래 플랫폼 "딴지" iOS

> 🛒 App Store에서 다운로드 : [딴지](https://apps.apple.com/kr/app/%EB%94%B4%EC%A7%80-%EB%B0%B0%EC%86%A1%EC%84%A0%EB%AC%BC-%EA%B1%B0%EB%9E%98-%EC%84%9C%EB%B9%84%EC%8A%A4/id6508169572)

![Slide 16_9 - 1](https://github.com/user-attachments/assets/f2c9e6f9-c525-443d-9dba-4523eeed1d5f)

## 🛠️ 기술 스택 및 아키텍처

| 구분 | 기술 스택 |
|------|-----------|
| **Language** | Swift |
| **UI Framework** | UIKit |
| **Architecture** | MVVM (Model-View-ViewModel) |
| **Reactive Programming** | RxSwift |
| **CI/CD** | Fastlane |
| **Networking** | Alamofire + RxAlamofire |

## 🏗️ MVVM 아키텍처

### 📊 구조 개요
```
App
├── Models
│   ├── Domain Models
│   └── Data Models
├── Views
│   ├── ViewControllers
│   ├── Views
│   └── Cells
├── ViewModels
│   ├── Protocol
│   └── Implementation
├── Services
│   ├── NetworkService
│   ├── DatabaseService
│   └── AuthService
└── Utils
    ├── Extensions
    └── Constants
```

### 🔄 데이터 플로우
```
View ↔ ViewModel ↔ Model
  ↓       ↓        ↓
UIKit   RxSwift  Business Logic
```

## 🏃‍♂️ 개발 워크플로우

### Git Flow 전략
- `main`: 프로덕션 브랜치
- `develop`: 개발 브랜치
- `feature/*`: 기능 개발 브랜치
- `release/*`: 릴리즈 브랜치
- `hotfix/*`: 핫픽스 브랜치
