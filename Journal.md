# Reordering Journal

## The Big Picture

Reordering is a tiny teaching kitchen for SwiftUI ordering patterns. One counter shows the classic restaurant ticket rail: rows in a table that can be moved up and down. The other counter is a tray of cards: grab one, drag it across the grid, and drop it into a new spot.

The important promise is that the app remembers. When someone arranges the rows or grid cards, their order survives relaunching the app.

## Architecture Deep Dive

Think of `Sport` as one tiny SwiftData record format. The table and grid both show the same sports, just through different SwiftUI reordering controls.

Persistence now lives in SwiftData. Both tabs use a `@Query` sorted by `sortOrder`, so changing the order in one tab updates the database-backed records that the other tab is already watching.

```text
[
  { id: "build", title: "Build", sortOrder: 0 },
  { id: "test", title: "Test", sortOrder: 1 }
]
```

The trick is keeping UI-only details at the edge. `Sport` stores a simple `colorName`, then exposes a computed `color` for the views.

## The Codebase Map

- `ReorderingApp.swift` is the front door. It launches `ContentView`.
- `ContentView.swift` contains the two-tab shell.
  - `TableRowsView` demonstrates `List` reordering with `.onMove`.
  - `GridReorderingView` demonstrates drag and drop with `LazyVGrid`.
  - `GridItemDropDelegate` handles moving a dragged card as it enters another card's drop area.
- `Sport.swift` contains the SwiftData model plus the example sports used for seeding and previews.
- `ItemStorage.swift` contains small helpers for seeding and assigning `sortOrder`.
- `AddSportView.swift` contains the sheet for creating a new sport and picking its SF Symbol.

## Tech Stack & Why

SwiftUI is doing the heavy lifting because this is exactly the kind of UI it makes pleasantly small: lists, grids, toolbar buttons, tab navigation, and drag/drop hooks.

SwiftData is the persistence layer because this demo now behaves like a real model-backed app. The records live in a model container, the views observe them with `@Query`, and reordering updates the stored `sortOrder`.

## The Journey

- Built the starter screen into a two-tab demo: one tab for rows, one tab for grid cards.
- Used stable string IDs so SwiftUI can understand identity during reordering.
- Chose model-driven `sortOrder` persistence so the sample content behaves more like records in a real app.
- Added reset buttons for both examples because demos need a friendly way back to square one.
- Split the original one-file demo into separate files. `ContentView` is now the traffic controller, while the table, grid, model, and persistence code each get their own quiet little workspace. Much easier to teach from, and much easier to find the part you want to explain.
- Moved the actual move/reset functions into the views where the behavior happens. The table view now owns table movement, and the grid view owns drag/drop movement. `ContentView` has officially retired from micromanagement.
- Moved the reorder state into the example views too. Since the table and grid demos do not need to coordinate with each other, bindings were extra plumbing. Now each demo view owns its own tiny world: load saved order, let the user rearrange, save the new order.
- Removed the reset buttons. They were handy during construction, but for a teaching demo they pulled attention away from the real lesson: move the item, save the order, restore it later.
- Switched to a model-driven `sortOrder` integer. Each model now carries its own place in line, like a numbered deli ticket. After every move, the app renumbers the models so they can be saved in their new order.
- Replaced the `ItemStore` and `UserDefaults` JSON helper with SwiftData. The shared source of truth is now the model container, and both tabs observe it directly.
- Changed the sample data to sports and added an add-sport sheet with `SFSymbolPicker`, limited to the `"sport"` search term.
- Added a preview trait that creates an in-memory SwiftData container and seeds it with the example sports. The previews now get realistic data without touching the app's real store.

## Engineer's Wisdom

Stable identity is the quiet hero of reorderable UIs. If SwiftUI cannot tell which item is which, animations get weird, rows appear to teleport, and persistence becomes a guessing game.

The useful pattern here is: persist simple SwiftData records, keep UI-only types at the edge, and sort queries by a model-owned `sortOrder`.

## If I Were Starting Over...

If I were starting over, I would probably begin with SwiftData earlier once the demo includes adding records. Reordering plus creation wants one real source of truth, and `@Query` makes that relationship easy to see.
