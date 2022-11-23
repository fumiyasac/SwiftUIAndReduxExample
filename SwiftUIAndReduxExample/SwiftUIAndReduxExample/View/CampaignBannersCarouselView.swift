//
//  CampaignBannersCarouselView.swift
//  SwiftUIAndReduxExample
//
//  Created by 酒井文也 on 2022/11/19.
//

import SwiftUI

// MEMO: SnapCarousel表示の参考
// https://stackoverflow.com/questions/72343827/carousel-view-swiftui

struct CampaignBannersCarouselView: View {

    // MEMO:
    private let screen = UIScreen.main.bounds

    private var carouselWidth: CGFloat {
        return screen.width - 32.0
    }

    private var carouselHeight: CGFloat {
        return carouselWidth * 156 / 375
    }

    // MEMO:
    @StateObject private var campaignBannersCarouselViewObject = CampaignBannersCarouselViewObject()

    // MEMO:
    @State private var snappedItem = 0.0
    @State private var draggingItem = 0.0
    @State private var offset: CGFloat = .zero
    @State private var lastOffset: CGFloat = .zero

    var body: some View {
        ZStack {
            ForEach(campaignBannersCarouselViewObject.items) { item in
                ZStack {
                    RoundedRectangle(cornerRadius: 12.0)
                        .fill(item.color)
                    Text(item.title)
                        .padding()
                }
                .frame(width: carouselWidth, height: carouselHeight)
                .scaleEffect(1.0 - abs(distance(item.id)) * 0.2)
                .opacity(1.0 - abs(distance(item.id)) * 0.3)
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
                        draggingItem = round(draggingItem).remainder(dividingBy: Double(campaignBannersCarouselViewObject.items.count))
                        snappedItem = draggingItem
                    }
                }
        )
    }

    private func distance(_ item: Int) -> Double {
        return (draggingItem - Double(item))
            .remainder(dividingBy: Double(campaignBannersCarouselViewObject.items.count))
    }

    private func myXOffset(_ item: Int) -> Double {
        let angle = Double.pi * 2 / Double(campaignBannersCarouselViewObject.items.count) * distance(item)
        return sin(angle) * 200
    }
}

struct CampaignBannersCarouselView_Previews: PreviewProvider {
    static var previews: some View {
        CampaignBannersCarouselView()
    }
}


struct Item: Identifiable {
    var id: Int
    var title: String
    var color: Color
}

class CampaignBannersCarouselViewObject: ObservableObject {
    @Published var items: [Item]
    
    let colors: [Color] = [.red, .orange, .blue, .teal, .mint, .green, .gray, .indigo]

    // dummy data
    init() {
        items = []
        for i in 0...7 {
            let new = Item(id: i + 1, title: "Item \(i)", color: colors[i])
            items.append(new)
        }
    }
}


