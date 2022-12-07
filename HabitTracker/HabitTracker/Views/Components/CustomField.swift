//
//  CustomField.swift
//  HabitTracker
//
//  Created by Arturo Diaz on 18/10/22.
//

import SwiftUI

struct CustomField: View {
    @Binding var searchText: String
    var image = ""
    var text = ""
    @FocusState private var isSearchBarFocused: Bool
    var backgroundColor: Color = Color("Primary")
    
    var body: some View {
        HStack {
            HStack {
                if image != "" {
                    Image(systemName: image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 20, height: 20, alignment: .center)
                        .foregroundColor(.secondary)
                }
                
                ZStack(alignment: .leading) {
                    if searchText.isEmpty {
                        Text(text)
                            .foregroundColor(.secondary)
                    }
                    TextField("", text: $searchText)
                        .focused($isSearchBarFocused)
                }
                .font(.system(size: 17))
                
                
                if searchText != "" {
                    Button(action: {
                        searchText = ""
                        isSearchBarFocused = true
                    }, label: {
                        Image(systemName: "xmark")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 15, height: 15, alignment: .center)
                            .padding(-2)
                            .foregroundColor(Color.primary)
                    })
                    .padding(.trailing, -4)
                }
            }
            .padding(16)
            .frame(height: 50)
            .background(backgroundColor)
//            .backgroundStyle(cornerRadius: 16, opacity: 0.4)
            .foregroundColor(.primary)
            .cornerRadius(12)
//            .shadow(color: Color.black.opacity(0.08), radius: 15, x: 0, y: 15)
        }
    }
}

struct CustomField_Previews: PreviewProvider {
    static var previews: some View {
        CustomField(searchText: .constant(""))
    }
}
