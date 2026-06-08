# Contributing to StreamX

Thank you for your interest in contributing to StreamX! This document provides guidelines and instructions.

## Code of Conduct

Be respectful, inclusive, and professional. Harassment of any form is not tolerated.

## Branch Strategy

```
main         ← Production-ready code (protected, PR-only)
develop      ← Integration branch for features
feature/*    ← New features (branch from develop)
bugfix/*     ← Bug fixes (branch from develop)
hotfix/*     ← Critical production fixes (branch from main)
release/*    ← Release preparation (branch from develop)
```

## Development Workflow

### 1. Fork & Clone
```bash
git clone https://github.com/YOUR_USERNAME/streamx.git
cd streamx
git remote add upstream https://github.com/AvinashK123-A/streamx.git
```

### 2. Set Up Environment
```bash
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
cp .env.dev .env
```

### 3. Create Feature Branch
```bash
git checkout -b feature/your-feature-name develop
```

### 4. Development Loop
```bash
# Run the app
flutter run

# Run tests
flutter test

# Run lints
flutter analyze

# Format code
dart format lib/ test/
```

### 5. Commit Guidelines

Follow Conventional Commits:

```
feat: add picture-in-picture support
fix: resolve video buffering on slow connections
refactor: extract auth token refresh logic
test: add search use case tests
docs: update deployment guide
chore: upgrade firebase_core to 2.27.1
```

### 6. Pull Request

- Target branch: `develop`
- Fill out the PR template completely
- Ensure all CI checks pass
- Request review from at least 1 maintainer
- Squash commits before merging

## Architecture Guidelines

### Must Follow
- Clean Architecture layers: domain → data → presentation
- Domain layer: ZERO Flutter imports (pure Dart only)
- Controllers: NEVER import data layer directly (use use cases)
- All use cases return `Either<Failure, T>` from dartz
- All GetX Controllers extend `GetxController`
- All Views extend `GetView<MyController>`

### Naming Conventions
```
Entities:     UserEntity, VideoEntity
DTOs:         UserDTO, VideoDTO  
Repositories: AuthRepository (abstract), AuthRepositoryImpl (concrete)
Use Cases:    LoginUseCase, GetFeaturedVideosUseCase
Controllers:  AuthController, HomeController
Views:        LoginView, HomeView, PlayerView
Bindings:     AuthBinding, HomeBinding
Widgets:      StreamXTextField, VideoCard, FeaturedBanner
```

### File Organization
```
lib/features/auth/
├── domain/
│   ├── entities/
│   ├── repositories/   ← abstract interfaces
│   └── usecases/
├── data/
│   ├── models/         ← DTOs
│   ├── datasources/    ← abstract + impl
│   └── repositories/   ← concrete implementations
└── presentation/
    ├── controllers/
    ├── views/
    ├── widgets/
    └── bindings/
```

## Testing Requirements

- All new use cases must have unit tests
- All new controllers must have unit tests
- All new views must have widget tests
- Target: 80%+ code coverage
- Run before each PR: `flutter test --coverage`

## Code Style

- Follow `analysis_options.yaml` rules
- Run `dart format lib/ test/` before committing
- Zero lint warnings/errors allowed
- Max line length: 80 characters
- Use `const` wherever possible
- Prefer `final` over `var`

## Questions?

Open a GitHub Discussion or file an Issue.
