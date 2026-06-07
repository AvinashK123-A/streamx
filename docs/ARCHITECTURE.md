# StreamX Architecture Documentation

## Clean Architecture Overview

StreamX follows Clean Architecture principles with strict layer separation and SOLID principles throughout.

```
┌─────────────────────────────────────────────────────┐
│                  PRESENTATION LAYER                 │
│   Views │ Controllers │ Widgets │ Bindings          │
│         (Flutter + GetX)                            │
├─────────────────────────────────────────────────────┤
│                   DOMAIN LAYER                      │
│   Entities │ Repositories │ UseCases                │
│         (Pure Dart — zero dependencies)             │
├─────────────────────────────────────────────────────┤
│                    DATA LAYER                       │
│   Models │ DTOs │ DataSources │ Repository Impl     │
│         (Dio │ Hive │ Firebase)                     │
└─────────────────────────────────────────────────────┘
```

## Layer Responsibilities

### Domain Layer (Pure Dart)
- **Entities**: Core business objects (User, Video, SearchResult)
- **Repository Interfaces**: Abstract contracts
- **Use Cases**: One business rule per class, returns `Either<Failure, T>`
- **Zero Flutter imports** — testable without framework

### Data Layer
- **DTOs**: Network/storage models with fromJson/toJson/toDomain
- **DataSources**: Remote (Dio) and Local (Hive) implementations  
- **Repository Implementations**: Implement domain interfaces, handle caching
- **Error Mapping**: Network exceptions → domain Failures

### Presentation Layer
- **GetX Controllers**: Reactive state management with `.obs`
- **Views**: `GetView<Controller>` — purely declarative
- **Widgets**: Stateless components
- **Bindings**: Lazy dependency injection wiring

## GetX Architecture

```
Route Request
    │
    ▼
AppPages.getPages()
    │
    ├─ Binding.dependencies()
    │       │
    │       ├─ Get.lazyPut(DataSource)
    │       ├─ Get.lazyPut(Repository)
    │       ├─ Get.lazyPut(UseCase)
    │       └─ Get.lazyPut(Controller)
    │
    ▼
View (GetView<Controller>)
    │
    ├─ controller.someState (Rx<T>)
    └─ Obx(() => Widget(controller.value))
```

## Data Flow

```
User Action
    │
    ▼
Controller.method()
    │
    ▼
UseCase.call(params) → Either<Failure, T>
    │
    ├─ Right(T) → Controller updates state
    └─ Left(Failure) → Controller shows error
         │
         ▼
    Repository.method()
         │
         ├─ RemoteDataSource.fetch() → Dio HTTP
         ├─ LocalDataSource.cache() → Hive
         └─ DTO.toDomain() → Entity
```

## Dependency Injection

GetX Bindings provide lazy DI:

```dart
class HomeBinding extends Bindings {
  @override
  void dependencies() {
    // Data layer
    Get.lazyPut<VideoRemoteDataSource>(
      () => VideoRemoteDataSourceImpl(Get.find<DioClient>()),
    );
    Get.lazyPut<VideoLocalDataSource>(
      () => VideoLocalDataSourceImpl(Get.find<HiveStorage>()),
    );
    Get.lazyPut<VideoRepository>(
      () => VideoRepositoryImpl(
        Get.find<VideoRemoteDataSource>(),
        Get.find<VideoLocalDataSource>(),
      ),
    );
    // Use cases
    Get.lazyPut(() => GetFeaturedVideosUseCase(Get.find()));
    // Controller
    Get.lazyPut(() => HomeController(Get.find(), Get.find(), Get.find()));
  }
}
```

## Error Handling

All errors flow through `Either<Failure, T>` from the dartz package:

```dart
// Domain: Failure classes
abstract class Failure extends Equatable {}
class NetworkFailure extends Failure {}
class ServerFailure extends Failure { final String message; }
class AuthFailure extends Failure {}
class CacheFailure extends Failure {}
class NotFoundFailure extends Failure {}

// Repository: Maps exceptions to Failures
try {
  final result = await remoteDataSource.fetchVideos();
  return Right(result.map((dto) => dto.toDomain()).toList());
} on DioException catch (e) {
  return Left(_mapDioError(e));
} on HiveError catch (e) {
  return Left(CacheFailure());
}

// Controller: Handles Either
final result = await useCase(params);
result.fold(
  (failure) => _handleFailure(failure),
  (videos) => featuredVideos.assignAll(videos),
);
```

## Security Architecture

### Token Management
```
Login Response
    │
    ▼
Tokens stored in FlutterSecureStorage
(Keychain on iOS, EncryptedSharedPreferences on Android)
    │
    ▼
Auth Interceptor reads token per request
    │
    ▼
401 Response → Auto refresh → Retry original request
    │
    ▼
Refresh fails → Clear tokens → Navigate to login
```

### Network Security
- NSAppTransportSecurity configured for HTTPS-only
- network_security_config.xml enforces SSL
- Certificate pinning in production (flutter_certificate_pinner)
- Request/Response logging disabled in production

## Performance Architecture

### Video Buffering Strategy
```
User taps video
    │
    ▼
PlayerController.initialize(videoUrl)
    │
    ├─ better_player caches segments to disk
    ├─ Pre-buffer next video while current plays
    └─ Adaptive quality based on network speed
```

### Image Caching
- cached_network_image with LRU memory cache (100 images)
- Disk cache up to 200MB
- Progressive JPEG loading with shimmer placeholders

### List Performance
- ListView.builder (lazy rendering — only visible items)
- AutomaticKeepAliveClientMixin for tab persistence
- const constructors throughout widget tree
- RepaintBoundary for video thumbnail rows

## Testing Strategy

```
Unit Tests (lib/) ──────────────────── 80%+ coverage target
    │ Mock: repositories, datasources, usecases
    │ Test: business logic, state changes
    │
Widget Tests (test/widget/) ───────── UI component coverage
    │ Mock: controllers via GetX
    │ Test: rendering, user interactions
    │
Integration Tests (integration_test/)  E2E flows
      Mock: none (or test Firebase project)
      Test: complete user journeys
```
