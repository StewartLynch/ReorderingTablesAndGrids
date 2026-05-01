# Reordering

## Project Overview

Reordering is a small SwiftUI teaching app that demonstrates two common ordering patterns:

- Reordering rows in a `List` using SwiftUI's built-in move support.
- Reordering cards in a grid using drag and drop.

The app is meant to be readable and workshop-friendly. The code favors straightforward data flow and stable identifiers over clever abstractions.

## Architecture Decisions

- The app uses one SwiftData `Sport` model for both examples.
- Both example views use `@Query(sort: \Sport.sortOrder)` so they stay synchronized through SwiftData.
- `ItemStorage` only contains small SwiftData helper methods for seeding and updating `sortOrder`.
- The row example uses `List` and `.onMove`.
- The grid example uses `LazyVGrid`, `.onDrag`, `.onDrop`, and a small `DropDelegate`.

## Conventions

- Use modern SwiftUI APIs such as `NavigationStack`, `toolbar`, `foregroundStyle`, and stable `ForEach` identity.
- Keep action behavior in private methods on the owning view when it is more than a single line.
- Prefer stable domain IDs over index-based identity for anything reorderable.
- Persist user-facing order changes immediately after a move.

## Build And Run

- Open `Reordering.xcodeproj` in Xcode.
- Select the `Reordering` scheme.
- Build and run on an iOS simulator or device.

Command-line build:

```bash
xcodebuild -project Reordering.xcodeproj -scheme Reordering -destination 'generic/platform=iOS Simulator' build
```

## Gotchas

- The grid reordering depends on stable IDs. Changing an item's `id` makes it a new item from the persistence layer's point of view.
- SwiftData owns persistence. Keep the `Sport` model fields simple and sortable by `sortOrder`.
