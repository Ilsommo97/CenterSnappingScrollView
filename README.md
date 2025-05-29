# CenterSnappingScrollView
A swift package for achieving snapping behaviour in SwiftUI-scroll views for items with variable widths/heights.



## Usage

```swift
import CenterSnappingScrollView

ScrollView(.horizontal) {
    HStack(spacing: 16) {
        ForEach(items) { item in
            ItemView(item: item)
                .scrollTargetCenterLayout()
        }
    }
}
.scrollSnapsToCenter(spacing: 16)
