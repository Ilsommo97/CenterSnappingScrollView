//
//  Example.swift
//  CenterSnappingScrollView
//
//  Created by Simone De Angelis on 29/05/25.
//

import SwiftUI
import CenterSnappingScrollView


struct FaultedSnapExample: View {
    let screenWidth = UIScreen.main.bounds.width
    var body: some View {
        VStack{
            Text("Faulted Snap Behaviour")
                .font(.largeTitle)
            ScrollView(.horizontal) {
                HStack(spacing: 24) {
                    ForEach(0..<10, id: \.self) { index in
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color.blue.opacity(0.7))
                            .frame(width:  CGFloat((index + 1) * 20),
                                   height: 100
                            )
                        
                    }
                }
                .scrollTargetLayout()
            }
            .scrollIndicators(.hidden)
            .scrollTargetBehavior(.viewAligned)
            .contentMargins(.horizontal,
                            EdgeInsets(top: 0,
                                       leading: screenWidth / 2 - (20 / 2) ,
                                       bottom: 0,
                                       trailing: screenWidth / 2 - (10 * 20 / 2)
                                      )
            )
            .overlay(content: {
                Rectangle()
                    .fill(.green)
                    .frame(width: 5, height: 100)
            })

        }
    }
}

struct CorrectSnapExample : View {
    var body: some View {
        VStack{
            Text("Correct Snap Behaviour")
                .font(.largeTitle)
            ScrollView(.horizontal) {
                HStack(spacing: 24) {
                    ForEach(0..<10, id: \.self) { index in
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color.blue.opacity(0.7))
                            .frame(width:  CGFloat((index + 1) * 20),
                                   height: 100
                            )
                            .snappingItem()
                    }
                }
            }
            .scrollIndicators(.hidden)
            .centerSnappingScroll(spacing: 24, axis: .horizontal)
            .overlay(content: {
                Rectangle()
                    .fill(.green)
                    .frame(width: 5, height: 100)
            })

        }
    }
}
