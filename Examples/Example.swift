//
//  Example.swift
//  CenterSnappingScrollView
//
//  Created by Simone De Angelis on 29/05/25.
//

import SwiftUI
import CenterSnappingScrollView

struct ContentView: View {
    var body: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 12) {
                ForEach(0..<10, id: \.self) { index in
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.blue.opacity(0.7))
                        .frame(width: CGFloat(50 + (index % 3) * 30), height: 100)
                        .snappingItem()
                }
            }
        }
        .centerSnappingScroll(spacing: 12) // accepts also an axis parameter for vertical scroll views
        .padding()
    }
}
