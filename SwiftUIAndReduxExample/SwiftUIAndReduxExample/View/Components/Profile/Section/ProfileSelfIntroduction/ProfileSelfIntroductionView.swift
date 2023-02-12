//
//  ProfileSelfIntroductionView.swift
//  SwiftUIAndReduxExample
//
//  Created by 酒井文也 on 2022/12/31.
//

import SwiftUI

struct ProfileSelfIntroductionView: View {

    // MARK: - Property

    private var selfIntroductionFont: Font {
        return Font.custom("AvenirNext-Regular", size: 12)
    }

    private var selfIntroductionColor: Color {
        return Color.secondary
    }

    private let profileSelfIntroductionViewObject: ProfileSelfIntroductionViewObject

    // MARK: - Initializer

    init(profileSelfIntroductionViewObject: ProfileSelfIntroductionViewObject) {
        self.profileSelfIntroductionViewObject = profileSelfIntroductionViewObject
    }

    // MARK: - Body

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(profileSelfIntroductionViewObject.introduction)
                    .font(selfIntroductionFont)
                    .foregroundColor(selfIntroductionColor)
            }
        }
        .padding([.leading, .trailing], 12.0)
    }
}

// MARK: - Preview

struct ProfileSelfIntroductionView_Previews: PreviewProvider {
    static var previews: some View {
        // MEMO: 部品1つあたりを表示するためのViewObject
        let ProfileSelfIntroductionViewObject = ProfileSelfIntroductionViewObject(
            id: 100,
            introduction: "普段は東京でイタリアンレストランのシェフをしていますが、その傍らで自宅でも美味しく食べられる本格イタリアンデザート等のプロデュース等も手掛けております。普段は仕事が忙しいのもあって外食が多くなりがちではあるので、ジャンル問わずに幅広く食べ歩くのが趣味です。ただ最近は運動不足もあってちょっと体重が増えかけているので、自分でもヘルシーな食事を心がけたり、お酒を控えめにしています。よろしくお願いします。"
        )
        // Preview: ProfileSelfIntroductionView
        ProfileSelfIntroductionView(profileSelfIntroductionViewObject: ProfileSelfIntroductionViewObject)
    }
}
