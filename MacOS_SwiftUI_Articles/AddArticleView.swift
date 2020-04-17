//
//  AddArticleView.swift
//  MacOS_SwiftUI_Articles
//
//  Created by Jan Hovland on 17/04/2020.
//  Copyright © 2020 Jan Hovland. All rights reserved.
//

import SwiftUI

struct AddArticleView: View {
    
    @State private var mainType = ""
    @State private var subType = ""
    @State private var title = ""
    @State private var introduction = ""
    @State private var url = ""
    
    @State private var saveArticle = false
    
    var body: some View {
        Form {
            VStack {
                HStack (alignment: .center) {
                    Text("Enter article data")
                        .font(.system(size: 35, weight: .ultraLight, design: .rounded))
                        .padding(.top, 50)
                        .padding(.bottom, 30)
                }
                InputField(heading: "MinType", placeHolder: "Enter mainType", value: $mainType)
                InputField(heading: "SubType", placeHolder: "Enter subType", value: $subType)
                InputField(heading: "Title", placeHolder: "Enter Title", value: $title)
                InputField(heading: "Introduction", placeHolder: "Enter Introduction", value: $introduction)
                InputField(heading: "Url", placeHolder: "Enter Url", value: $url)
                Spacer()
                
                Button(action: {
                    self.saveArticle.toggle()
                }, label: {
                    HStack {
                        Text("Save article")
                    }
                })
                .controlSize(ControlSize.small)
            }
        }
        
    }
}

struct InputField: View {
    var heading: String
    var placeHolder: String
    @Binding var value: String
    var body: some View {
        VStack (alignment: .leading, spacing: 0) {
            Text(heading)
            TextField(placeHolder, text: $value)
        }
        .padding(.leading, 10)
    }
}
