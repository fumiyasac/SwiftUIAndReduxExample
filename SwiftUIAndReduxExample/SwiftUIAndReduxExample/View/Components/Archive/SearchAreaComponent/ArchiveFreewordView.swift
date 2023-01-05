//
//  ArchiveFreewordView.swift
//  SwiftUIAndReduxExample
//
//  Created by 酒井文也 on 2023/01/04.
//

import SwiftUI

struct ArchiveFreewordView: View {

    // MARK: - Property

    private var searchBarBackgroundColor: Color {
        return Color(uiColor: UIColor(code: "#e7e7e7"))
    }

    private var glassIconColor: Color {
        return Color.gray
    }

    private var textFieldTextColor: Color {
        return Color.primary
    }

    //
    @Binding var text: String
    @Binding var isLoading: Bool

    //
    @State private var isEditing = false

    // MARK: - Body

    var body: some View {
        //
        ZStack(alignment: .leading) {
            searchBarBackgroundColor
                .frame(width: 270.0)
                .frame(height: 36.0)
                .cornerRadius(8.0)
            //
            HStack {
                //
                Image(systemName: "magnifyingglass")
                    .foregroundColor(glassIconColor)
                    .padding([.leading], 8.0)
                //
                TextField("Search", text: $text)
                    .padding(7.0)
                    .padding(.leading, -8.0)
                    .background(searchBarBackgroundColor)
                    .cornerRadius(8.0)
                    .foregroundColor(textFieldTextColor)
                    .onTapGesture(perform: {
                        isEditing = true
                    })
                
                //
                if isEditing {
                    //
                    Button(action: {
                        //
                        text = ""
                        isEditing = false
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    }, label: {
                        Text("Cancel")
                            .foregroundColor(.gray)
                    })
                    .padding([.leading], 4.0)
                    .padding([.trailing], 8.0)
                    .transition(.move(edge: .trailing))
                }
            }
        }
        .padding([.leading, .trailing], 12.0)
    }
}

// MARK: - Preview

struct ArchiveFreewordView_Previews: PreviewProvider {
    static var previews: some View {
        ArchiveFreewordView(text: .constant(""), isLoading: .constant(false))
    }
}
