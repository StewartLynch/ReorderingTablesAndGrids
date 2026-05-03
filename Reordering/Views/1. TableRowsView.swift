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

struct TableRowsView: View {
    @Query(sort: \Sport.sortOrder) private var sports:[Sport]
    @Environment(\.modelContext) var modelContext
    @State private var isAddingSport = false
    var body: some View {
        NavigationStack {
            List {
                ForEach(sports) { item in
                    Label {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(item.title)
                                .font(.headline)
                            Text(item.detail)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                    } icon: {
                        Image(systemName: item.symbolName)
                            .foregroundStyle(item.color)
                            .frame(width: 28)
                    }
                }
                .onMove(perform: moveRows)
                .onDelete(perform: deleteRows)
            }
            .navigationTitle("List Reordering")
            .toolbar {
                if sports.isEmpty {
                    Button("Seed Data", systemImage: "tray.and.arrow.down") {
                        ItemStorage.seedSports(in: modelContext)
                    }
                }
                Button("Add Sport", systemImage: "plus") {
                    isAddingSport = true
                }
                EditButton()
            }
            .sheet(isPresented: $isAddingSport) {
                AddSportView(nextSortOrder: ItemStorage.nextSortOrder(after: sports))
            }
        }
    }
    private func moveRows(from source: IndexSet, to destination: Int) {
        var reorderedSports = sports
        reorderedSports.move(fromOffsets: source, toOffset: destination)
        ItemStorage.updateSortOrder(for: reorderedSports)
        try? modelContext.save()
    }
    
    private func deleteRows(at indexSet: IndexSet) {
        for index in indexSet {
            modelContext.delete(sports[index])
        }
        var remainingSports = sports
        remainingSports.remove(atOffsets: indexSet)
        ItemStorage.updateSortOrder(for: remainingSports)
        try? modelContext.save()
    }
}


#Preview(traits: .sportExamples) {
    TableRowsView()
}
