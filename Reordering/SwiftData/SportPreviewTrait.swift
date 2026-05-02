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

struct SportPreviewTrait: PreviewModifier {
    func body(content: Content, context: ModelContainer) -> some View {
        content.modelContainer(context)
    }

    static func makeSharedContext() async throws -> ModelContainer {
        let container = try ModelContainer(
            for: Sport.self,
            configurations: ModelConfiguration(isStoredInMemoryOnly: true)
        )
        Sport.examples.forEach { container.mainContext.insert($0) }
        return container
    }
}

extension PreviewTrait where T == Preview.ViewTraits {
    static var sportExamples: Self = .modifier(SportPreviewTrait())
}
