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

import SwiftUI

struct TableRowsView: View {
    private let sports = Sport.examples
    
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
            }
            .navigationTitle("List Reordering")
        }
    }
}


#Preview {
    TableRowsView()
}
