//
//  OnboardingContentsView.swift
//  SwiftUIAndReduxExample
//
//  Created by 酒井文也 on 2023/02/05.
//

import SwiftUI

struct OnboardingContentsView: View {

    // MARK: - Typealias

    typealias CloseOnboardingAction = () -> Void

    // MARK: - Property

    private let screen = UIScreen.main.bounds

    private var screenWidth: CGFloat {
        return screen.width - 64.0
    }

    private var baseBackgroundColor: Color {
        return Color.white
    }

    private var baseBorderColor: Color {
        return Color(uiColor: .lightGray)
    }

    private var quitOnboardingButtonFont: Font {
        return Font.custom("AvenirNext-Bold", size: 16)
    }

    private var quitOnboardingButtonColor: Color {
        return Color(uiColor: UIColor(code: "#b9d9c3"))
    }

    private var closeOnboardingAction: OnboardingContentsView.CloseOnboardingAction

    // MARK: - Initializer

    init(closeOnboardingAction: @escaping OnboardingContentsView.CloseOnboardingAction) {
        self.closeOnboardingAction = closeOnboardingAction
    }

    // MARK: - Body

    var body: some View {
        VStack(spacing: 0.0) {
            TabView {
                OnboardingItemView(
                    imageName: "onboarding1",
                    title: "Welcome to App.",
                    summary: "アプリへようこそ！"
                )
                .tag(0)
                OnboardingItemView(
                    imageName: "onboarding2",
                    title: "Find my favorite.",
                    summary: "お気に入りに出会おう！"
                )
                .tag(1)
                OnboardingItemView(
                    imageName: "onboarding3",
                    title: "Come on! Let's go!",
                    summary: "さあ！使ってみよう！"
                )
                .tag(2)
            }
            .tabViewStyle(PageTabViewStyle())
            .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
            HStack {
                Spacer()
                Button(action: closeOnboardingAction, label: {
                    // MEMO: 縁取りをした角丸ボタンのための装飾
                    Text("オンボーディングを終了")
                        .font(quitOnboardingButtonFont)
                        .foregroundColor(quitOnboardingButtonColor)
                        .background(.white)
                        .frame(width: 240.0, height: 48.0)
                        .cornerRadius(24.0)
                        .overlay(
                            RoundedRectangle(cornerRadius: 24.0)
                                .stroke(quitOnboardingButtonColor, lineWidth: 1.0)
                        )
                })
                Spacer()
            }
            .padding(.top, 24.0)
            .padding(.bottom, 24.0)
        }
        .background(baseBackgroundColor)
        .frame(width: screenWidth, height: 480.0)
        .padding(.vertical, 64.0)
        .padding(.horizontal, 44.0)
    }
}

struct OnboardingContentsView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingContentsView(closeOnboardingAction: {})
    }
}
