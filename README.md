# CenterSnappingScrollView

A Swift package for achieving precise snapping behavior in SwiftUI `ScrollView` with items of variable widths or heights.

## The Problem

SwiftUI's native `ScrollTargetBehavior` (via `ScrollTargetBehaviorProtocol`) fails to align items correctly when their dimensions along the scroll axis are dynamic. For example:
- A horizontal `ScrollView` with images in `aspectFit` mode (variable widths)
- A vertical `ScrollView` with text of inconsistent heights

### Demonstration of the Issue

![Faulted Snap Behavior](https://github.com/Ilsommo97/CenterSnappingScrollView/blob/main/faulted_snap.gif?raw=true)


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
## The Solution
CenterSnappingScrollView ensures consistent snapping behavior regardless of item dimensions. Simply:

- Apply the  `.snappingItem()`  modifier to child views

- Use the  `.centerSnappingScroll(spacing:axis:)()`  modifier on the parent ScrollView


## Correct Behaviour
![Faulted Snap Behavior](https://github.com/Ilsommo97/CenterSnappingScrollView/blob/main/correct_snap.gif?raw=true)

## Usage
```swift
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
```
