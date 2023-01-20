//
//  PickupPhotosGridView.swift
//  SwiftUIAndReduxExample
//
//  Created by 酒井文也 on 2022/12/07.
//

import SwiftUI
import Kingfisher

// MEMO: Snapを伴うCarousel方式でのバナー表示の参考（決まった数量のデータを表示する）
// ※ 参考リンクでの実装方針を元に改変したものになります。
// https://stackoverflow.com/questions/66101176/how-could-i-use-a-swiftui-lazyvgrid-to-create-a-staggered-grid

struct PickupPhotosGridView: View {

    // MARK: - Property

    private var pickupPhotosGridViewObjects: [PickupPhotosGridViewObject] = []

    // MEMO: Grid表示View要素に表示する内容を格納するための変数
    @State private var splittedPickupPhotosGridViewObjects: (leftPhotosGridViewObjects: [PickupPhotosGridViewObject], rightPhotosGridViewObjects: [PickupPhotosGridViewObject]) = (leftPhotosGridViewObjects: [], rightPhotosGridViewObjects: [])

    // MARK: - Initializer

    init(pickupPhotosGridViewObjects: [PickupPhotosGridViewObject]) {
        self.pickupPhotosGridViewObjects = pickupPhotosGridViewObjects

        // イニシャライザ内で「_(変数名)」値を代入することでState値の初期化を実行する
        // 👉 ここでは引数で受け取ったpickupPhotosGridViewObject配列を2つに分割する
        _splittedPickupPhotosGridViewObjects = State(initialValue: getSplittedPickupPhotosGridViewObjects())
    }
    
    // MARK: - Body

    var body: some View {
        // MEMO: StaggeredGridの様な表現をするために、VStackを縦に2つ並べて表現する
        // 👉 LazyVGridにすると表示がおかしくなったのでこの形としています。
        HStack(alignment: .top) {
            VStack(spacing: 8.0) {
                ForEach(splittedPickupPhotosGridViewObjects.leftPhotosGridViewObjects) { viewObject in
                    PickupPhotosCellView(
                        viewObject: viewObject,
                        tapCellAction: {
                            print("想定: Tap処理を実行した際に何らかの処理を実行する (ID:\(viewObject.id))")
                        }
                    )
                }
            }
            VStack(spacing: 8.0) {
                ForEach(splittedPickupPhotosGridViewObjects.rightPhotosGridViewObjects) { viewObject in
                    PickupPhotosCellView(
                        viewObject: viewObject,
                        tapCellAction: {
                            print("想定: Tap処理を実行した際に何らかの処理を実行する (ID:\(viewObject.id))")
                        }
                    )
                }
            }
        }
    }

    // MARK: - Private Function

    private func getSplittedPickupPhotosGridViewObjects() -> (leftPhotosGridViewObjects: [PickupPhotosGridViewObject], rightPhotosGridViewObjects: [PickupPhotosGridViewObject]) {
        var leftHeightSum: Int = 0
        var rightHeightSum: Int = 0
        var leftPhotosGridViewObjects: [PickupPhotosGridViewObject] = []
        var rightPhotosGridViewObjects: [PickupPhotosGridViewObject] = []
        // MEMO: 算出したサムネイル画像高さの大きさ元にして左右のどちらに配置するかを決定する
        // 👉 今回のサンプルではAPIレスポンス内でサムネイルの幅と高さを持つ想定なので、この部分をうまく活用する
        for viewObject in pickupPhotosGridViewObjects {
            let standardWidth = UIScreen.main.bounds.width / 2
            let standardHeight = Int(ceil(standardWidth / viewObject.photoWidth * viewObject.photoHeight))
            // Debug.
            print("ID:\(viewObject.id) / leftHeightSum:\(leftHeightSum) / rightHeightSum:\(rightHeightSum) / standardHeight:\(standardHeight)")
            // 左右の配置決定と左右高さ合計値加算処理を実行する
            if leftHeightSum > rightHeightSum {
                rightPhotosGridViewObjects.append(viewObject)
                rightHeightSum += standardHeight
            } else {
                leftPhotosGridViewObjects.append(viewObject)
                leftHeightSum += standardHeight
            }
        }
        return (leftPhotosGridViewObjects: leftPhotosGridViewObjects, rightPhotosGridViewObjects: rightPhotosGridViewObjects)
    }
}

// MARK: - PickupPhotosCellView

struct PickupPhotosCellView: View {

    // MARK: - Property

    private let screen = UIScreen.main.bounds

    private var cellTitleFont: Font {
        return Font.custom("AvenirNext-Bold", size: 14)
    }

    private var cellCaptionFont: Font {
        return Font.custom("AvenirNext-Regular", size: 12)
    }

    private var cellTitleColor: Color {
        return Color.white
    }

    private var cellCaptionColor: Color {
        return Color.white
    }

    private var standardWidth: CGFloat {
        // MEMO: 間隔は8.0×3=24.0と想定しています
        return CGFloat((screen.width - 24.0) / 2)
    }

    private var standardHeight: CGFloat {
        return CGFloat(Int(ceil(standardWidth / viewObject.photoWidth * viewObject.photoHeight)))
    }

    private var bottomAreaBackground: Color {
        return Color.black.opacity(0.36)
    }

    private var cellRoundRectangleColor: Color {
        return Color.secondary.opacity(0.5)
    }

    private var viewObject: PickupPhotosGridViewObject
    private var tapCellAction: TapCellAction

    // MARK: - Typealias

    typealias TapCellAction = () -> Void

    // MARK: - Initializer

    init(
        viewObject: PickupPhotosGridViewObject,
        tapCellAction: @escaping TapCellAction
    ) {
        self.viewObject = viewObject
        self.tapCellAction = tapCellAction
    }
    
    var body: some View {
        // サムネイル画像とタイトル＆キャプションを重ねて表示する
        ZStack {
            // (1) サムネイル画像を表示する部分
            KFImage(viewObject.photoUrl)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .clipped()
            // (2) タイトル＆キャプションを重ねて表示する部分
            VStack {
                Spacer()
                HStack {
                    VStack {
                        Text(viewObject.title)
                            .font(cellTitleFont)
                            .foregroundColor(cellTitleColor)
                            .lineLimit(1)
                        Text(viewObject.caption)
                            .font(cellCaptionFont)
                            .foregroundColor(cellCaptionColor)
                            .lineLimit(1)
                    }
                    .padding(8.0)
                }
                // MEMO: テキスト要素のまわりに余白を与える
                .frame(maxWidth: .infinity)
                .background(bottomAreaBackground)
            }
        }
        // MEMO: タップ領域の確保とタップ時の処理
        .contentShape(Rectangle())
        .onTapGesture(perform: tapCellAction)
        // MEMO: 表示要素全体に付与する角丸と配色を設定している部分
        .cornerRadius(4.0)
        .frame(width: standardWidth, height: standardHeight)
        .background(
            RoundedRectangle(cornerRadius: 4.0)
                .stroke(cellRoundRectangleColor)
        )
    }
}

// MARK: - ViewObject

struct PickupPhotosGridViewObject: Identifiable {
    let id: Int
    let title: String
    let caption: String
    let photoUrl: URL?
    let photoWidth: CGFloat
    let photoHeight: CGFloat
}

// MARK: - Preview

struct PickupPhotosGridView_Previews: PreviewProvider {
    static var previews: some View {

        // MEMO: Preview表示用にレスポンスを想定したJsonを読み込んで画面に表示させる
        let pickupPhotoResponse = getPickupPhotoResponse()
        let pickupPhotoGridViewObjects = pickupPhotoResponse.result
            .map {
                PickupPhotosGridViewObject(
                    id: $0.id,
                    title: $0.title,
                    caption: $0.caption,
                    photoUrl: URL(string: $0.photoUrl) ?? nil,
                    photoWidth: CGFloat($0.photoWidth),
                    photoHeight: CGFloat($0.photoHeight)
                )
            }

        // Preview: PickupPhotosGridView
        // MEMO: 全体を表示させたいのでScrollViewを仕込んでいる
        ScrollView {
            PickupPhotosGridView(pickupPhotosGridViewObjects: pickupPhotoGridViewObjects)
        }
        .previewDisplayName("PickupPhotosGridView Preview")

        // MEMO: 部品1つあたりを表示するためのViewObject
        let viewObject1 = PickupPhotosGridViewObject(
            id: 1,
            title: "Pickup Photo No.1",
            caption: "Premium Gourmet Photo No.1",
            photoUrl: URL(string: "https://ones-mind-topics.s3.ap-northeast-1.amazonaws.com/pickup_photo1.jpg") ?? nil,
            photoWidth: 960,
            photoHeight: 960
        )
        let viewObject2 = PickupPhotosGridViewObject(
            id: 2,
            title: "Pickup Photo No.2",
            caption: "Premium Gourmet Photo No.2",
            photoUrl: URL(string: "https://ones-mind-topics.s3.ap-northeast-1.amazonaws.com/pickup_photo2.jpg") ?? nil,
            photoWidth: 960,
            photoHeight: 1280
        )
        let viewObject3 = PickupPhotosGridViewObject(
            id: 3,
            title: "Pickup Photo No.3",
            caption: "Premium Gourmet Photo No.3",
            photoUrl: URL(string: "https://ones-mind-topics.s3.ap-northeast-1.amazonaws.com/pickup_photo3.jpg") ?? nil,
            photoWidth: 1200,
            photoHeight: 800
        )

        // Preview: PickupPhotosCellView
        PickupPhotosCellView(viewObject: viewObject1, tapCellAction: {})
            .previewDisplayName("PickupPhotosCellView1 Preview")
        PickupPhotosCellView(viewObject: viewObject2, tapCellAction: {})
            .previewDisplayName("PickupPhotosCellView2 Preview")
        PickupPhotosCellView(viewObject: viewObject3, tapCellAction: {})
            .previewDisplayName("PickupPhotosCellView3 Preview")
    }

    // MARK: - Private Static Function

    private static func getPickupPhotoResponse() -> PickupPhotoResponse {
        guard let path = Bundle.main.path(forResource: "pickup_photos", ofType: "json") else {
            fatalError()
        }
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: path)) else {
            fatalError()
        }
        guard let result = try? JSONDecoder().decode([PickupPhotoEntity].self, from: data) else {
            fatalError()
        }
        return PickupPhotoResponse(result: result)
    }
}
