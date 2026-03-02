# Architecture Decisions

This document captures the key technical decisions made during the project setup and their rationale.

## Table of Contents

- [State Management: Riverpod](#state-management-riverpod)
- [Firebase Configuration](#firebase-configuration)
- [Phone Normalization](#phone-normalization)
- [Offline Persistence](#offline-persistence)
- [Quran Data Strategy](#quran-data-strategy)
- [Architecture Pattern](#architecture-pattern)

---

## State Management: Riverpod

**Decision**: Use Riverpod (with code generation) for state management

**Context**: Need reactive state management for complex forms, async data loading, and real-time updates.

### Alternatives Considered

1. **Bloc (Business Logic Component)**
   - ✅ Pros: Very structured, battle-tested, excellent testing support
   - ❌ Cons: Significant boilerplate, steeper learning curve

2. **Provider (built into Flutter)**
   - ✅ Pros: Simpler than Bloc, built into Flutter SDK
   - ❌ Cons: Less type-safe, harder to test, deprecated by Flutter team

3. **GetX**
   - ✅ Pros: Extremely fast, lots of features built-in
   - ❌ Cons: Harder to test, magic/implicit state management

4. **Riverpod** (selected)
   - ✅ Pros: Compile-safe providers, excellent testability, code generation reduces boilerplate, active maintenance
   - ✅ Cons: Slightly steeper learning curve than Provider

### Rationale

- **Type Safety**: Riverpod's code generation provides compile-time safety that prevents many runtime errors
- **Testability**: Providers can be tested in isolation without widgets, making unit testing easier
- **State Isolation**: Riverpod's scope-based isolation prevents state leakage between tests
- **Future-Proof**: Riverpod is actively maintained and recommended by the Flutter team as the successor to Provider
- **Code Generation**: Reduces boilerplate significantly compared to Bloc and manual Provider implementation

### Tradeoffs

- **Learning Curve**: Team needs to learn Riverpod's concepts (providers, ref, scope)
- **Boilerplate**: Initial setup requires annotation and build_runner, but code generation handles most of it
- **Debugging**: More complex than Provider, but Riverpod's DevTools integration helps

**References**:
- [Riverpod Documentation](https://riverpod.dev)
- [Flutter Official Statement](https://flutter.dev/docs/development/data-and-backend/state-mgmt/simple)

---

## Firebase Configuration

**Decision**: Use single Firebase project with shared configuration across platforms initially

**Context**: Need to support iOS and Android with authentication, database, messaging, storage, and crash reporting.

### Alternatives Considered

1. **Multiple Firebase Projects**
   - ✅ Pros: Clear separation of environments, can have different configs per platform
   - ❌ Cons: More complex management, duplication of data, harder to sync

2. **Single Firebase Project with Environment Variables**
   - ✅ Pros: Easier management, unified data, consistent rules
   - ❌ Cons: Requires careful config management for different environments

3. **No Firebase (Custom Backend)**
   - ✅ Pros: Full control, no vendor lock-in
   - ❌ Cons: Requires building backend infrastructure, more development time

### Rationale

- **Unified Data**: Single database makes it easier to analyze cross-platform usage and user behavior
- **Consistent Rules**: Firebase Security Rules are easier to maintain and understand with single set
- **Future Flexibility**: Can add environment-specific rules later if needed
- **Simplified Development**: No need to manage multiple projects, credentials, or environments during initial development

### Tradeoffs

- **Environment Management**: Currently using single environment (development), but can be extended to production
- **Cost**: Single project means unified Firebase costs across all platforms
- **Scalability**: Single project works well for MVP, can split if requirements grow significantly

**References**:
- [Firebase Documentation](https://firebase.google.com/docs)
- [FlutterFire Setup Guide](https://firebase.google.com/docs/flutter/setup)

---

## Phone Normalization

**Decision**: Use digits-only format (e.g., "966501234567") for phone numbers

**Context**: Need to normalize phone numbers for parent authentication and identification.

### Alternatives Considered

1. **E.164 International Format**
   - ✅ Pros: Standard format, works internationally, widely supported
   - ❌ Cons: Includes country code, longer string, requires knowledge of country codes

2. **Digits-Only Format** (selected)
   - ✅ Pros: Simple, easy to generate parent emails, works for local usage
   - ❌ Cons: Not international, can't differentiate same number in different countries

3. **Regional Format (with country code)**
   - ✅ Pros: More specific, can include country code
   - ❌ Cons: Still requires format knowledge, more complex validation

4. **Unique Identifier Format**
   - ✅ Pros: Guaranteed unique, no validation needed
   - ❌ Cons: Hard to map back to actual phone numbers, confusing for users

### Rationale

- **Simple Generation**: Easy to create parent email: `parent{digits}@madrasa.local`
- **Local Focus**: Madrasa likely serves local community, so country code not necessary
- **Data Integrity**: Single format reduces validation complexity
- **Privacy**: Digits-only format hides specific phone number details while maintaining uniqueness

### Tradeoffs

- **Limited International Support**: Not suitable for global distribution without modification
- **Validation Complexity**: Need to validate phone number format (e.g., Saudi phone numbers typically 9 or 10 digits)
- **Mapping**: Need to maintain mapping between normalized and actual phone numbers for display

**Constitution Alignment**:
- ✅ Principle 2 (One Source of Truth): Single phone normalization function
- ✅ Principle 4 (Data Continuity): No migration needed for existing data

**References**:
- Constitution § 4.2: Parent authentication email generation

---

## Offline Persistence

**Decision**: Enable unlimited offline cache size for Firestore

**Context**: Need to ensure app works offline and syncs when connection is restored.

### Alternatives Considered

1. **Default Cache Size (Limited)**
   - ✅ Pros: Reduces storage usage on device
   - ❌ Cons: Risk of cache overflow, data loss during extended offline use

2. **Limited Cache with Configurable Size**
   - ✅ Pros: Balance between storage and functionality
   - ❌ Cons: Requires user configuration, complexity

3. **Unlimited Cache Size** (selected)
   - ✅ Pros: Maximum offline capability, no data loss risk
   - ❌ Cons: Uses more device storage

4. **Hybrid Approach (Network First, Cache Second)**
   - ✅ Pros: Smart handling of network issues
   - ❌ Cons: More complex implementation

### Rationale

- **Reliability**: Quran Madrasa is for memorization tracking, critical data shouldn't be lost
- **User Experience**: Students/teachers can track progress anytime, anywhere without concern about cache limits
- **Simplicity**: No user configuration needed for optimal experience
- **Local Use**: Project likely for local use, device storage is generally not a constraint

### Tradeoffs

- **Storage Usage**: App uses more device storage when offline
- **Sync Strategy**: Need clear sync indicators to show when data will be synced

**Constitution Alignment**:
- ✅ Principle 4 (Data Continuity): Maximum offline capability ensures data continuity
- ✅ Principle 3 (No Unnecessary Flows): No need for manual sync or cache management

**References**:
- Constitution § 12: Firestore offline persistence settings
- [Firebase Documentation](https://firebase.google.com/docs/firestore/manage-data/offline-capabilities)

---

## Quran Data Strategy

**Decision**: Embed Quran metadata as static JSON asset instead of API calls

**Context**: Need to provide fast access to surah information (114 surahs, verse counts) for various queries.

### Alternatives Considered

1. **API Calls**
   - ✅ Pros: Always up-to-date, no storage required
   - ❌ Cons: Network dependency, slower, requires API keys or rate limits

2. **Embedded JSON** (selected)
   - ✅ Pros: Instant access, no network dependency, complete control
   - ❌ Cons: Requires storage for 114 surahs (~8KB JSON file)

3. **Cached API Response**
   - ✅ Pros: Balance of speed and accuracy
   - ❌ Cons: Complex caching logic, still requires network initially

4. **Separate Backend Service**
   - ✅ Pros: No Flutter app dependency, highly scalable
   - ❌ Cons: Additional infrastructure, slower initial load

### Rationale

- **Speed**: Instant access to surah information without network calls
- **Reliability**: No API key management, rate limits, or service downtime issues
- **Control**: Complete control over data format and updates
- **Simplicity**: No caching logic needed, data is static and won't change
- **Data Size**: 114 surahs is small (~8KB), storage is not a concern

### Tradeoffs

- **Updates**: Need to manually update JSON file when Quran metadata changes (rare event)
- **Storage**: Uses ~8KB of storage on device (negligible)

**Data Source**:
- Primary: https://api.alquran.cloud/v1/meta
- Backup: https://github.com/risan/quran-json

**Constitution Alignment**:
- ✅ Principle 2 (One Source of Truth): Single JSON source for all Quran metadata queries
- ✅ Principle 3 (No Unnecessary Flows): Direct access without API overhead

**References**:
- Constitution § 12.3: Quran metadata embedded as asset
- [AlQuran Cloud API](https://alquran.cloud/)

---

## Architecture Pattern

**Decision**: Use Feature-Based Architecture with Clean Architecture principles

**Context**: Need to organize code for scalability, maintainability, and team collaboration.

### Alternatives Considered

1. **Monolithic Codebase**
   - ✅ Pros: Simple to start, no folder structure decisions
   - ❌ Cons: Becomes unmanageable, hard to scale, tight coupling

2. **Folder-by-Feature (Selected)**
   - ✅ Pros: Clear separation of concerns, easy to find code, scalable
   - ❌ Cons: Requires discipline to follow pattern

3. **Layered Architecture (MVC/MVVM)**
   - ✅ Pros: Classic pattern, well-understood
   - ❌ Cons: Can become rigid, hard to maintain large codebases

4. **Module-Based Architecture**
   - ✅ Pros: Easy to feature-flag, independent deployments
   - ❌ Cons: Complex build system, overkill for MVP

### Rationale

- **Scalability**: Feature folders make it easy to add new features without disrupting existing ones
- **Team Collaboration**: Multiple developers can work on different features simultaneously
- **Maintainability**: Clear structure reduces cognitive load when making changes
- **Testability**: Each feature can be tested independently
- **Extensibility**: Easy to add new features without refactoring existing code

### Structure

```
lib/
├── core/                    # Shared, cross-cutting concerns
│   ├── models/              # Base models and interfaces
│   ├── providers/           # Global state management
│   ├── services/            # External service integrations
│   ├── utils/               # Utility functions (shared)
│   └── widgets/             # Reusable UI components
└── features/                # Application-specific features
    ├── auth/                # Authentication feature
    │   ├── data/            # Data layer (repositories, sources)
    │   ├── domain/          # Domain layer (entities, use cases)
    │   └── presentation/    # Presentation layer (widgets, providers)
    └── [other_features]/    # Other feature modules
```

### Tradeoffs

- **Complexity**: More initial setup and structure to understand
- **Boilerplate**: Feature folders require consistent structure
- **Navigation**: Need to decide on navigation strategy (go_router selected)

**References**:
- [Clean Architecture](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
- [Flutter Official Architecture Recommendations](https://flutter.dev/docs/development/data-and-backend/state-mgmt/options)

---

## Summary

These architectural decisions prioritize:
- **Simplicity**: No unnecessary complexity for MVP
- **Scalability**: Build patterns that support growth
- **Maintainability**: Code structure that's easy to understand and modify
- **Reliability**: Patterns that ensure robust behavior
- **User Experience**: Decisions that prioritize performance and usability

**Constitution Alignment**: All decisions align with the principles in the project constitution, particularly:
- Principle 2: One Source of Truth
- Principle 3: No Unnecessary Flows
- Principle 4: Data Continuity
- Principle 5: Prevent Mistakes by Design

---

**Last Updated**: 2026-03-02
**Version**: 1.0.0
