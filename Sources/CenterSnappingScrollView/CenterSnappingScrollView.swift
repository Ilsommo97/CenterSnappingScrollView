// The Swift Programming Language
// https://docs.swift.org/swift-book

import SwiftUI

// MARK: - Preference Key to collect an ordered array of view sizes
public struct ScrollTargetSizesPreferenceKey: @preconcurrency PreferenceKey {
    @MainActor public static var defaultValue: [CGSize] = []

    public static func reduce(value: inout [CGSize], nextValue: () -> [CGSize]) {
        value.append(contentsOf: nextValue()) // Appends sizes in their declaration order
    }
}

// MARK: - Environment Key for the array of view sizes
public struct ScrollTargetSizesEnvironmentKey: EnvironmentKey {
    public static let defaultValue: [CGSize] = []
}

public extension EnvironmentValues {
    var scrollTargetSizes: [CGSize] {
        get { self[ScrollTargetSizesEnvironmentKey.self] }
        set { self[ScrollTargetSizesEnvironmentKey.self] = newValue }
    }
}

// MARK: - View Modifier to read and propagate a view's size
public struct SnappingItemModifier: ViewModifier {
    public init() {}

    public func body(content: Content) -> some View {
        content
            .background {
                GeometryReader { proxy in
                    Color.clear
                        .preference(
                            key: ScrollTargetSizesPreferenceKey.self,
                            value: [proxy.size]
                        )
                }
            }
    }
}

// MARK: - Container modifier to enable center snapping for a ScrollView
public struct CenterSnappingScrollModifier: ViewModifier {
    @State private var sizes: [CGSize] = []
    public let spacing: CGFloat
    public var axis : Axis.Set = .horizontal
    @State private var readHeight: CGFloat = 100
    @State private var readWidth : CGFloat = 100
    public init(spacing: CGFloat, axis : Axis.Set = .horizontal) {
        self.spacing = spacing
        self.axis = axis
      }
    

    public func body(content: Content) -> some View {
    
        GeometryReader { proxy in
            content
                .onPreferenceChange(ScrollTargetSizesPreferenceKey.self) { newSizes in
                    self.sizes = newSizes
                }
                .environment(\.scrollTargetSizes, sizes)
                .scrollTargetBehavior(CenteredSnappingBehaviour(sizes: self.sizes, spacing: self.spacing, axis: self.axis))
                .contentMargins(axis == .horizontal ? .horizontal : .vertical, EdgeInsets(
                    top: axis == .vertical ? proxy.size.height / 2 - (self.sizes.first?.height ?? 0) / 2 : 0,
                    leading: axis == .horizontal ?  proxy.size.width / 2 - (self.sizes.first?.width ?? 0) / 2 : 0,
                    bottom: axis == .vertical ?     proxy.size.height / 2 - (self.sizes.last?.height ?? 0) / 2 : 0,
                    trailing: axis == .horizontal ? proxy.size.width / 2 - (self.sizes.last?.width ?? 0) / 2 : 0
                    )
                )
                .background {
                    GeometryReader { contentProxy in
                        Color.clear.onAppear {
                            self.readHeight = contentProxy.size.height
                            self.readWidth = contentProxy.size.width
                        }
                    }
                }
        }
        // If axis passed is vertical -> Scroll view scrolls vertically -> we need to assign a valid width
        // If axis passed is horizontal -> Scroll view scrolls horizontally -> We need to assign a valid height
        .frame(width: axis == .horizontal ? nil : readWidth, height: axis == .vertical ? nil : readHeight)
       // .frame(height: readHeight)
    }
    
//    private func returnMargin(firstMargin : Bool, proxy : GeometryProxy) -> CGFloat {
//        let margin : CGFloat
//        if firstMargin {
//            margin = self.axis == .horizontal ?
//            proxy.size.width / 2 - (self.sizes.first?.width ?? 0) / 2 :
//            proxy.size.height / 2 - (self.sizes.first?.height ?? 0) / 2
//        }
//        else {
//            margin = self.axis == .horizontal ?
//            proxy.size.width / 2 - (self.sizes.last?.width ?? 0) / 2 :
//            proxy.size.height / 2 - (self.sizes.last?.height ?? 0) / 2
//        }
//        return margin
//    }
}

// MARK: - Convenience extensions
public extension View {
    /// Apply to each item inside a scroll view to enable snapping behavior
    func snappingItem() -> some View {
        self.modifier(SnappingItemModifier())
    }

    /// Apply to the scroll view container to enable center snapping
    func centerSnappingScroll(spacing: CGFloat, axis: Axis.Set = .horizontal) -> some View {
        self.modifier(CenterSnappingScrollModifier(spacing: spacing, axis : axis))
    }
}

// MARK: - Custom scroll snapping behavior
public struct CenteredSnappingBehaviour: ScrollTargetBehavior {
    public let sizes: [CGSize]
    public let spacing: CGFloat
    public var axis : Axis.Set = .horizontal
    public var centerViewSizes: [CGFloat] = []

    public init(sizes: [CGSize], spacing: CGFloat, axis : Axis.Set = .horizontal) {
        self.sizes = sizes
        self.spacing = spacing
        self.axis = axis
        self.centerViewSizes = determineEachCenterViewOffset()
    }

    public func updateTarget(_ target: inout ScrollTarget, context: TargetContext) {
        guard !self.centerViewSizes.isEmpty else { return }

        let proposedContentOffset = self.axis == .horizontal ?  target.rect.origin.x : target.rect.origin.y
        let firstViewCenterOffset = self.centerViewSizes.first!

        let adjustedProposedOffset = proposedContentOffset + firstViewCenterOffset

        var nearestIndex = 0
        var minDistance = abs(self.centerViewSizes[0] - adjustedProposedOffset)

        for (index, centerOffset) in self.centerViewSizes.enumerated() {
            let distance = abs(centerOffset - adjustedProposedOffset)
            if distance < minDistance {
                minDistance = distance
                nearestIndex = index
            }
        }
        if self.axis == .horizontal{
            target.rect.origin.x = self.centerViewSizes[nearestIndex] - firstViewCenterOffset
        }
        else {
            target.rect.origin.y = self.centerViewSizes[nearestIndex] - firstViewCenterOffset
        }
    }

    private func determineEachCenterViewOffset() -> [CGFloat] {
        var calculatedOffsets: [CGFloat] = []
        for (index, size) in self.sizes.enumerated() {
            if index == 0 {
                calculatedOffsets.append( self.axis == .horizontal ? size.width / 2 : size.height / 2)
            } else {
                let accumulatedSpacing = self.spacing * CGFloat(index)
                let totalPreviousWidths = self.sizes[..<index].reduce(0) { $0 + (self.axis == .horizontal ? $1.width : $1.height) }
                let currentViewCenter = totalPreviousWidths + accumulatedSpacing + ( self.axis == .horizontal ?  size.width / 2 : size.height / 2)
                calculatedOffsets.append(currentViewCenter)
            }
        }
        return calculatedOffsets
    }
}
