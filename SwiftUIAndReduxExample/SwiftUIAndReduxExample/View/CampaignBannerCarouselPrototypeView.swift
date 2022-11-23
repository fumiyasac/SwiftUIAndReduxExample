//
//  CampaignBannerCarouselPrototypeView.swift
//  SwiftUIAndReduxExample
//
//  Created by 酒井文也 on 2022/11/22.
//

import SwiftUI

struct PrototypeItem: Identifiable {
    var id: Int
    var title: String
    var color: Color
}

struct CampaignBannerCarouselPrototypeView: View {
    @State private var items: [PrototypeItem]

    @State private var snappedItem = 0.0
    @State private var draggingItem = 0.0
    
    @State private var offset: CGFloat = .zero
    @State private var lastOffset: CGFloat = .zero
        
    init(colors: [Color]) {
        var targetItems: [PrototypeItem] = []
        for i in 0..<colors.count {
            let new = PrototypeItem(id: i + 1, title: "Item \(i)", color: colors[i])
            targetItems.append(new)
        }
        self.items = targetItems
    }

    var body: some View {
        ZStack {
            ForEach(items) { item in
                // article view
                ZStack {
                    RoundedRectangle(cornerRadius: 18)
                        .fill(item.color)
                    Text(item.title)
                        .padding()
                }
                .frame(width: 365, height: 196)
                .scaleEffect(1.0 - abs(distance(item.id)) * 0.2 )
                .opacity(1.0 - abs(distance(item.id)) * 0.3 )
                .offset(x: myXOffset(item.id), y: 0)
                .zIndex(1.0 - abs(distance(item.id)) * 0.1)
            }
        }
        .gesture(
            DragGesture()
                .onChanged { value in
                    draggingItem = snappedItem + value.translation.width / 250
                }
                .onEnded { value in
                    withAnimation {
                        draggingItem = snappedItem + value.translation.width / 250
                        draggingItem = round(draggingItem).remainder(dividingBy: Double(items.count))
                        snappedItem = draggingItem
                    }
                }
        )
    }
    
    func distance(_ item: Int) -> Double {
        return (draggingItem - Double(item))
            .remainder(dividingBy: Double(items.count))
    }
    
    func myXOffset(_ item: Int) -> Double {
        let angle = Double.pi * 2 / Double(items.count) * distance(item)
        print(sin(angle) * 200)
        return sin(angle) * 200
    }
}

//struct CampaignBannerCarouselPrototypeView_Previews: PreviewProvider {
//    static var previews: some View {
//        let colors: [Color] = [.red, .orange, .blue, .teal, .mint, .green, .gray, .indigo]
//        CampaignBannerCarouselPrototypeView(
//            colors: colors
//        )
//    }
//}

struct ScrollingHStackModifier: ViewModifier {
    
    @State private var scrollOffset: CGFloat
    @State private var dragOffset: CGFloat
    
    var items: Int
    var itemWidth: CGFloat
    var itemSpacing: CGFloat
    
    init(items: Int, itemWidth: CGFloat, itemSpacing: CGFloat) {
        self.items = items
        self.itemWidth = itemWidth
        self.itemSpacing = itemSpacing
        
        // Calculate Total Content Width
        let contentWidth: CGFloat = CGFloat(items) * itemWidth + CGFloat(items - 1) * itemSpacing
        let screenWidth = UIScreen.main.bounds.width
        
        // Set Initial Offset to first Item
        let initialOffset = (contentWidth/2.0) - (screenWidth/2.0) + ((screenWidth - itemWidth) / 2.0)
        
        self._scrollOffset = State(initialValue: initialOffset)
        self._dragOffset = State(initialValue: 0)
    }
    
    func body(content: Content) -> some View {
        content
            .offset(x: scrollOffset + dragOffset, y: 0)
            .gesture(DragGesture()
                .onChanged({ event in
                    dragOffset = event.translation.width
                })
                .onEnded({ event in
                    // Scroll to where user dragged
                    scrollOffset += event.translation.width
                    dragOffset = 0
                    
                    // Now calculate which item to snap to
                    let contentWidth: CGFloat = CGFloat(items) * itemWidth + CGFloat(items - 1) * itemSpacing
                    let screenWidth = UIScreen.main.bounds.width
                    
                    // Center position of current offset
                    let center = scrollOffset + (screenWidth / 2.0) + (contentWidth / 2.0)
                    
                    // Calculate which item we are closest to using the defined size
                    var index = (center - (screenWidth / 2.0)) / (itemWidth + itemSpacing)
                    
                    // Should we stay at current index or are we closer to the next item...
                    if index.remainder(dividingBy: 1) > 0.5 {
                        index += 1
                    } else {
                        index = CGFloat(Int(index))
                    }
                    
                    // Protect from scrolling out of bounds
                    index = min(index, CGFloat(items) - 1)
                    index = max(index, 0)
                    
                    // Set final offset (snapping to item)
                    let newOffset = index * itemWidth + (index - 1) * itemSpacing - (contentWidth / 2.0) + (screenWidth / 2.0) - ((screenWidth - itemWidth) / 2.0) + itemSpacing
                    
                    // Animate snapping
                    withAnimation {
                        scrollOffset = newOffset
                    }
                    
                })
            )
    }
}

struct ScrollingHStack: View {
    
    var colors: [Color] = [.blue, .green, .red, .orange]
    
    var body: some View {
        HStack(alignment: .center, spacing: 16) {
            ForEach(0..<colors.count) { i in
                 colors[i]
                     .frame(width: 320, height: 400, alignment: .center)
                     .cornerRadius(10)
            }
        }.modifier(ScrollingHStackModifier(items: colors.count, itemWidth: 320, itemSpacing: 16))
    }
}

struct ScrollingHStack_Previews: PreviewProvider {
    static var previews: some View {
        ScrollingHStack()
    }
}
