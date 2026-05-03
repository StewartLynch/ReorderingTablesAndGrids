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

    @Query(sort: \Sport.sortOrder) private var sports: [Sport]
    @Environment(\.modelContext) var modelContext
    
    @State private var draggedItem: Sport?
    @State private var displaySports: [Sport] = []

    @State private var isAddingSport = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(displaySports) { item in
                        SportCard(item: item)
                            .contextMenu {
                                Button(role: .destructive) {
                                        deleteItem(item)
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                            .onDrag {
                                draggedItem = item
                                let id = item.persistentModelID
                                return NSItemProvider(object: "\(id)" as NSString)
                            }
                            .onDrop(
                                of: [UTType.text],
                                delegate: GridItemDropDelegate(
                                    draggedItem: draggedItem,
                                    sports: $displaySports,
                                    targetItem: item,
                                    commitMove: {
                                        ItemStorage.updateSortOrder(for: displaySports)
                                        try? modelContext.save()
                                        draggedItem = nil
                                    }
                                )
                            )
                    }
                }
                .padding()
            }
            .navigationTitle("Grid Reordering")
            .toolbar {
               
                Button("Add Sport", systemImage: "plus") {
                    isAddingSport = true
                }
            }
            .sheet(isPresented: $isAddingSport) {
                AddSportView(nextSortOrder: ItemStorage.nextSortOrder(after: sports))
            }
        }
        .onAppear {
            displaySports = sports
        }
        .onChange(of: sports) {
            guard draggedItem == nil else { return }
            displaySports = sports
        }
    }
    
    private func deleteItem(_ item: Sport) {
        if draggedItem == item { draggedItem = nil }
        modelContext.delete(item)
        displaySports = sports.filter { $0.persistentModelID != item.persistentModelID }
        ItemStorage.updateSortOrder(for: displaySports)
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

struct GridItemDropDelegate: DropDelegate {
    let draggedItem: Sport?
    @Binding var sports: [Sport]
    let targetItem: Sport
    let commitMove: () -> Void
    
    func performDrop(info: DropInfo) -> Bool {
        commitMove()
        return true
    }
    
    func dropEntered(info: DropInfo) {
        guard let item = draggedItem,
              item != targetItem,
              let sourceIndex = sports.firstIndex(of: item),
              let targetIndex = sports.firstIndex(of: targetItem) else { return }
        withAnimation {
            sports.move(fromOffsets: IndexSet(integer: sourceIndex), toOffset: targetIndex > sourceIndex ? targetIndex + 1 : targetIndex)
        }
    }
    
    func dropUpdated(info: DropInfo) -> DropProposal? {
        DropProposal(operation: .move)
    }
}

#Preview(traits: .sportExamples) {
    GridReorderingView()
}
