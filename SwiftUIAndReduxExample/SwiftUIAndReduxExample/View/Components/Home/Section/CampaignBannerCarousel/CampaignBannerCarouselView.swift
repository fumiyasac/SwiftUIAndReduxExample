//
//  CampaignBannerCarouselView.swift
//  SwiftUIAndReduxExample
//
//  Created by 酒井文也 on 2022/11/23.
//

import SwiftUI
import Kingfisher

// MEMO: Snapを伴うCarousel方式でのバナー表示の参考
// https://stackoverflow.com/questions/72343827/carousel-view-swiftui

struct CampaignBannerCarouselView: View {

    // MARK: - Property

    private let screen = UIScreen.main.bounds

    private var carouselWidth: CGFloat {
        return screen.width - 32.0
    }

    private var carouselHeight: CGFloat {
        return carouselWidth * 156 / 375
    }

    // MEMO: Carousel表示時に利用する変化量を格納するための変数
    @State private var snappedOffset: CGFloat
    @State private var draggingOffset: CGFloat

    // MEMO: Carouselに表示する内容を格納するための変数
    @State private var campaignBannerCarouselViewObjects: [CampaignBannerCarouselViewObject] = []

    // MARK: - Initializer
    
    init(campaignBannerCarouselViewObjects: [CampaignBannerCarouselViewObject]) {

        // イニシャライザ内で「_(変数名)」値を代入することでState値の初期化を実行する
        _campaignBannerCarouselViewObjects = State(initialValue: campaignBannerCarouselViewObjects)
        _snappedOffset = State(initialValue: 0.0)
        _draggingOffset = State(initialValue: 0.0)
    }

    // MARK: - Body
    
    var body: some View {
        ZStack {
            ForEach(campaignBannerCarouselViewObjects) { viewObject in
                ZStack {
                    KFImage(viewObject.bannerUrl)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .cornerRadius(12.0)
                }
                .frame(width: carouselWidth, height: carouselHeight)
                .scaleEffect(getCarouselElementModifierValueBy(itemId: viewObject.id, ratio: 0.2))
                .opacity(getCarouselElementModifierValueBy(itemId: viewObject.id, ratio: 0.3))
                .zIndex(getCarouselElementModifierValueBy(itemId: viewObject.id, ratio: 0.1))
                .offset(x: calculateHorizontalOffsetBy(itemId: viewObject.id), y: 0.0)
                // MEMO: タップ領域の確保とタップ時の処理
                .contentShape(Rectangle())
                .onTapGesture(perform: {
                    print("想定: Tap処理を実行した際に何らかの処理を実行する (ID:\(viewObject.id))")
                })
            }
        }
        .modifier(
            // MEMO: DragGestureの値変化を利用したCarousel表示用のModifier定義
            // 👉 State値に$をつけて値変化と連動させている点がポイントになる
            CampaignBannerCarouselViewModifier(
                snappedOffset: $snappedOffset,
                draggingOffset: $draggingOffset,
                viewObjectsCount: campaignBannerCarouselViewObjects.count
            )
        )
    }

    // MARK: - Private Function

    private func getCarouselElementModifierValueBy(itemId: Int, ratio: CGFloat) -> CGFloat {
        // MEMO: scaleEffect / opacity / zIndexに必要な調整値を算出する
        let distanceByItemId = calculateDistanceBy(itemId: itemId)
        return 1.0 - abs(distanceByItemId) * ratio
    }

    private func calculateDistanceBy(itemId: Int) -> CGFloat {
        // MEMO: remainderを利用して間隔値を算出する
        // 参考: https://dev.classmethod.jp/articles/utility-extension-remainder/
        let allItemsCount = campaignBannerCarouselViewObjects.count
        let draggingOffsetByItemId = (draggingOffset - CGFloat(itemId))
        return draggingOffsetByItemId
            .remainder(dividingBy: CGFloat(allItemsCount))
    }

    private func calculateHorizontalOffsetBy(itemId: Int) -> CGFloat {
        // MEMO: 三角関数(この場合はsinθ)を利用して角度を算出し、奥行きのある重なりを表現する
        let allItemsCount = campaignBannerCarouselViewObjects.count
        let angle = Double.pi * 2 / Double(allItemsCount) * calculateDistanceBy(itemId: itemId)
        return sin(angle) * 200
    }
}

// MARK: - Modifier

struct CampaignBannerCarouselViewModifier: ViewModifier {

    // MARK: - Property

    // MEMO: CampaignBannerCarouselViewに定義したState値の変化量と連動する形としている
    @Binding private var snappedOffset: CGFloat
    @Binding private var draggingOffset: CGFloat

    private var viewObjectsCount: Int

    // MARK: - Initializer

    init(
        snappedOffset: Binding<CGFloat>,
        draggingOffset: Binding<CGFloat>,
        viewObjectsCount: Int
    ) {
        // イニシャライザ内で「_(変数名)」値を代入することでBinding値の初期化を実行する
        // ※viewObjectの総数については従来通りの初期化処理で良い
        _snappedOffset = snappedOffset
        _draggingOffset = draggingOffset
        self.viewObjectsCount = viewObjectsCount
    }

    // MARK: - body

    func body(content: Content) -> some View {
        content
            // MEMO: highPriorityGestureを利用してScrollView内で使用しても上下スクロールとの競合を発生しにくくする（とはいえ出てしまう時はあるかもしれない...）
            // 参考リンク:
            // https://www.hackingwithswift.com/quick-start/swiftui/how-to-force-one-gesture-to-recognize-before-another-using-highprioritygesture
            .highPriorityGesture(
                // 👉 minimumDistanceの値を0よりも少し大きな値にしておく（縦方向スクロールのための配慮）
                DragGesture(minimumDistance: 5)
                .onChanged({ value in
                    // 👉 Carousel要素の移動中はStateと連動するdraggingOffset値を更新する
                    draggingOffset = snappedOffset + value.translation.width / 250
                })
                .onEnded({ value in
                    // 👉 Carousel要素の移動終了時は自然に元の位置または動かそうとした位置に戻る様にしている
                    withAnimation(.easeOut(duration: 0.12)) {
                        draggingOffset = snappedOffset + value.translation.width / 250
                        draggingOffset = round(draggingOffset).remainder(dividingBy: Double(viewObjectsCount))
                        snappedOffset = draggingOffset
                    }
                })
            )
    }
}

// MARK: - Preview

struct CampaignBannerCarouselView_Previews: PreviewProvider {
    
    static var previews: some View {
        // MEMO: Preview表示用にレスポンスを想定したJsonを読み込んで画面に表示させる
        let campaignBannersResponse = getCampaignBannersResponse()
        let campaignBannerCarouselViewObjects = campaignBannersResponse.result
            .map {
                CampaignBannerCarouselViewObject(
                    id: $0.id,
                    bannerContentsId: $0.bannerContentsId,
                    bannerUrl: URL(string: $0.bannerUrl) ?? nil
                )
            }
        CampaignBannerCarouselView(campaignBannerCarouselViewObjects: campaignBannerCarouselViewObjects)
    }

    // MARK: - Private Static Function

    private static func getCampaignBannersResponse() -> CampaignBannersResponse {
        guard let path = Bundle.main.path(forResource: "campaign_banners", ofType: "json") else {
            fatalError()
        }
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: path)) else {
            fatalError()
        }
        guard let result = try? JSONDecoder().decode([CampaignBannerEntity].self, from: data) else {
            fatalError()
        }
        return CampaignBannersResponse(result: result)
    }
}
