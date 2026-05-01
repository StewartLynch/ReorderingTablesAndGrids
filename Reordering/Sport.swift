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

@Model
final class Sport {
    var title: String
    var detail: String
    var symbolName: String
    var colorName: String
    var sortOrder: Int

    init(
        title: String,
        detail: String,
        symbolName: String,
        colorName: String,
        sortOrder: Int
    ) {
        self.title = title
        self.detail = detail
        self.symbolName = symbolName
        self.colorName = colorName
        self.sortOrder = sortOrder
    }

    var color: Color {
        switch colorName {
        case "blue": .blue
        case "brown": .brown
        case "green": .green
        case "indigo": .indigo
        case "mint": .mint
        case "orange": .orange
        case "pink": .pink
        case "purple": .purple
        case "red": .red
        case "teal": .teal
        default: .primary
        }
    }
}

extension Sport {
    static var examples: [Sport] {
        [
            Sport(
                title: "Soccer",
                detail: "Team play, footwork, and goals.",
                symbolName: "soccerball",
                colorName: "green",
                sortOrder: 0
            ),
            Sport(
                title: "Basketball",
                detail: "Fast breaks, jump shots, and rebounds.",
                symbolName: "basketball",
                colorName: "orange",
                sortOrder: 1
            ),
            Sport(
                title: "Baseball",
                detail: "Pitching, batting, and fielding.",
                symbolName: "baseball",
                colorName: "red",
                sortOrder: 2
            ),
            Sport(
                title: "Football",
                detail: "Yardage, tackles, and touchdowns.",
                symbolName: "football",
                colorName: "brown",
                sortOrder: 3
            ),
            Sport(
                title: "Tennis",
                detail: "Serves, volleys, and rallies.",
                symbolName: "tennisball",
                colorName: "mint",
                sortOrder: 4
            ),
            Sport(
                title: "Hockey",
                detail: "Skating, shots, and saves.",
                symbolName: "hockey.puck",
                colorName: "indigo",
                sortOrder: 5
            )
        ]
    }
}
