//
//----------------------------------------------
// Original project: Reordering
//
// Follow me on Mastodon: https://iosdev.space/@StewartLynch
// Follow me on Threads: https://www.threads.net/@stewartlynch
// Follow me on Bluesky: https://bsky.app/profile/stewartlynch.bsky.social
// Follow me on X: https://x.com/StewartLynch
// Follow me on LinkedIn: https://linkedin.com/in/StewartLynch
// Email: slynch@createchsol.com
// Subscribe on YouTube: https://youTube.com/@StewartLynch
// Buy me a ko-fi:  https://ko-fi.com/StewartLynch
//----------------------------------------------
// Copyright © 2026 CreaTECH Solutions (Stewart Lynch). All rights reserved.

import SwiftData
import SwiftUI
import UniformTypeIdentifiers

struct GridReorderingView: View {
    private let columns = [
        GridItem(.adaptive(minimum: 140), spacing: 16)
    ]

    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Sport.sortOrder) private var sports: [Sport]
    @State private var draggedItem: Sport?
    @State private var dragSports: [Sport] = []
    @State private var isAddingSport = false

    private var displayedSports: [Sport] {
        draggedItem == nil ? sports : dragSports
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(displayedSports) { item in
                        SportCard(item: item)
                        .onDrag {
                            setDraggedItem(item)
                            return NSItemProvider(object: item.title as NSString)
                        }
                        .onDrop(
                            of: [UTType.text],
                            delegate: GridItemDropDelegate(
                                targetItem: item,
                                draggedItem: draggedItem,
                                moveItem: moveItem,
                                commitMove: commitMove
                            )
                        )
                    }
                }
                .padding()
            }
            .navigationTitle("Grid Reordering")
            .toolbar {
                if sports.isEmpty {
                    Button("Seed Data", systemImage: "tray.and.arrow.down") {
                        ItemStorage.seedSports(in: modelContext)
                    }
                }

                Button("Add Sport", systemImage: "plus") {
                    isAddingSport = true
                }
            }
            .sheet(isPresented: $isAddingSport) {
                AddSportView(nextSortOrder: ItemStorage.nextSortOrder(after: sports))
            }
        }
    }

    private func setDraggedItem(_ item: Sport?) {
        draggedItem = item
        dragSports = item == nil ? [] : sports
    }

    private func moveItem(_ item: Sport, to target: Sport) {
        guard item != target,
              let sourceIndex = dragSports.firstIndex(of: item),
              let targetIndex = dragSports.firstIndex(of: target)
        else { return }

        withAnimation(.snappy) {
            dragSports.move(
                fromOffsets: IndexSet(integer: sourceIndex),
                toOffset: targetIndex > sourceIndex ? targetIndex + 1 : targetIndex
            )
        }
    }

    private func commitMove() {
        let reorderedSports = dragSports
        setDraggedItem(nil)

        ItemStorage.updateSortOrder(for: reorderedSports)
        try? modelContext.save()
    }
}

private struct SportCard: View {
    let item: Sport

    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: item.symbolName)
                .font(.system(size: 34, weight: .semibold))
                .foregroundStyle(item.color)
                .frame(width: 58, height: 58)
                .background(item.color.opacity(0.15), in: Circle())

            Text(item.title)
                .font(.headline)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .minimumScaleFactor(0.85)
        }
        .frame(maxWidth: .infinity, minHeight: 134)
        .padding()
        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 8))
        .overlay {
            RoundedRectangle(cornerRadius: 8)
                .stroke(item.color.opacity(0.35), lineWidth: 1)
        }
    }
}

private struct GridItemDropDelegate: DropDelegate {
    let targetItem: Sport
    let draggedItem: Sport?
    let moveItem: (Sport, Sport) -> Void
    let commitMove: () -> Void

    func dropEntered(info: DropInfo) {
        guard let draggedItem else { return }
        moveItem(draggedItem, targetItem)
    }

    func performDrop(info: DropInfo) -> Bool {
        commitMove()
        return true
    }

    func dropUpdated(info: DropInfo) -> DropProposal? {
        DropProposal(operation: .move)
    }
}

#Preview(traits: .sportExamples) {
    GridReorderingView()
}
