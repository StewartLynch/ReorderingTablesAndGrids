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

enum ItemStorage {
    static func seedSports(in modelContext: ModelContext) {
        Sport.examples.forEach { modelContext.insert($0) }
        try? modelContext.save()
    }

    static func nextSortOrder(after sports: [Sport]) -> Int {
        (sports.map(\.sortOrder).max() ?? -1) + 1
    }

    static func updateSortOrder(for sports: [Sport]) {
        for (index, sport) in sports.enumerated() {
            sport.sortOrder = index
        }
    }
}
