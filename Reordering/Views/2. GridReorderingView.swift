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

struct GridReorderingView: View {
    private let columns = [
        GridItem(.adaptive(minimum: 140), spacing: 16)
    ]

    private let sports = Sport.examples

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(sports) { item in
                        SportCard(item: item)
                    }
                }
                .padding()
            }
            .navigationTitle("Grid Reordering")
        }
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

#Preview {
    GridReorderingView()
}
