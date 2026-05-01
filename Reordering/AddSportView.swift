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

import SFSymbolPicker
import SwiftData
import SwiftUI

struct AddSportView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    let nextSortOrder: Int

    @State private var title = ""
    @State private var detail = ""
    @State private var symbolName = "soccerball"
    @State private var colorName = "blue"
    @State private var isChoosingSymbol = false
    @State private var loader = SymbolLoader()

    private let colorNames = [
        "blue",
        "brown",
        "green",
        "indigo",
        "mint",
        "orange",
        "pink",
        "purple",
        "red",
        "teal"
    ]

    var body: some View {
        NavigationStack {
            Form {
                Section("Sport") {
                    TextField("Name", text: $title)
                    TextField("Details", text: $detail)
                }

                Section("Symbol") {
                    Button {
                        isChoosingSymbol = true
                    } label: {
                        Label(symbolName, systemImage: symbolName)
                    }
                }

                Section("Color") {
                    Picker("Color", selection: $colorName) {
                        ForEach(colorNames, id: \.self) { colorName in
                            Text(colorName.capitalized)
                                .tag(colorName)
                        }
                    }
                }
            }
            .navigationTitle("Add Sport")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        addSport()
                    }
                    .disabled(title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
            .sheet(isPresented: $isChoosingSymbol) {
                NavigationStack {
                    SymbolView(
                        loader: loader,
                        selectedSymbol: $symbolName,
                        searchTerm: "sport"
                    )
                    .navigationTitle("Sport Symbol")
                }
            }
        }
    }

    private func addSport() {
        let sport = Sport(
            title: title.trimmingCharacters(in: .whitespacesAndNewlines),
            detail: detail.trimmingCharacters(in: .whitespacesAndNewlines),
            symbolName: symbolName,
            colorName: colorName,
            sortOrder: nextSortOrder
        )
        modelContext.insert(sport)
        try? modelContext.save()
        dismiss()
    }
}

#Preview(traits: .sportExamples) {
    AddSportView(nextSortOrder: 6)
}
