//
//  OnboardingContentsView.swift
//  SwiftUIAndReduxExample
//
//  Created by 酒井文也 on 2023/02/05.
//

import SwiftUI

struct OnboardingContentsView: View {

    // MARK: - Property

    private let screen = UIScreen.main.bounds

    private var screenWidth: CGFloat {
        return screen.width - 88.0
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
        return Color(uiColor: AppConstants.ColorPalette.mint)
    }

    // MARK: - Body

    var body: some View {
        VStack(spacing: 0.0) {
            TabView {
                OnboardingItemView()
                    .tag(0)
                OnboardingItemView()
                    .tag(1)
                OnboardingItemView()
                    .tag(2)
            }
            .tabViewStyle(PageTabViewStyle())
            .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
            HStack {
                Spacer()
                Button(action: {}, label: {
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
        .overlay(
            RoundedRectangle(cornerRadius: 8.0)
                .stroke(baseBorderColor, lineWidth: 1.0)
        )
        .clipShape(RoundedRectangle(cornerRadius: 8.0))
        .background(baseBackgroundColor)
        .frame(width: screenWidth, height: 480.0)
        .padding(.vertical, 64.0)
        .padding(.horizontal, 44.0)
    }
}

struct OnboardingContentsView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingContentsView()
    }
}
