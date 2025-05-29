# CenterSnappingScrollView
A swift package for achieving snapping behaviour in SwiftUI-scroll views for items with variable widths/heights.

## What it solves
When using a SwiftUI scroll view, there are a couple of predefined scrolling behaviour that one can implement. However those default behaviour adopting the ScrollTargetBehaviour protocol will not work when the dimension aligned with the scroll direction of children views is variable ( think of a horizontal scroll view with images in scale aspect fit  whose frame height is set and width parameter is left free)
To better visualize the issue, we can write a simple demo showing rectangles of variable width. The GIF shows the default scroll target behaviour .viewAligned. Also the contentMargin of the scroll view is being set so that the first and last item appears at the center of the screen. 


![Demo GIF](https://github.com/Ilsommo97/CenterSnappingScrollView/blob/main/faulted_snap.gif?raw=true)
```swift
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

```

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
