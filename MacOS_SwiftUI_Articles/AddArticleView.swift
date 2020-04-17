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
    
    @State private var alertIdentifier: AlertID?
    @State private var message: String = ""
    @State private var message1: String = ""
    
    var body: some View {
        Form {
            VStack {
                HStack (alignment: .center) {
                    Text("Enter article data")
                        .font(.system(size: 35, weight: .ultraLight, design: .rounded))
                        .padding(.top, 50)
                        .padding(.bottom, 30)
                }
                InputField(heading: "MinType", placeHolder: "Enter mainType", value: self.$mainType)
                InputField(heading: "SubType", placeHolder: "Enter subType", value: self.$subType)
                InputField(heading: "Title", placeHolder: "Enter Title", value: self.$title)
                InputField(heading: "Introduction", placeHolder: "Enter Introduction", value: self.$introduction)
                InputField(heading: "Url", placeHolder: "Enter Url", value: self.$url)
                Spacer()
                
                Button(action: {
                    self.saveArticle(mainType: self.mainType,
                                     subType: self.subType,
                                     title: self.title,
                                     introduction: self.introduction,
                                     url: self.url)
                }, label: {
                    HStack {
                        Text("Save article")
                    }
                })
                    .controlSize(ControlSize.small)
            }
        }
        .alert(item: $alertIdentifier) { alert in
            switch alert.id {
            case .first:
                return Alert(title: Text(self.message), message: Text(self.message1), dismissButton: .cancel())
            case .second:
                return Alert(title: Text(self.message), message: Text(self.message1), dismissButton: .cancel())
            case .third:
                return Alert(title: Text(self.message), message: Text(self.message1), dismissButton: .cancel())
            }
        }
    }
    
    func saveArticle(mainType: String,
                     subType: String,
                     title: String,
                     introduction: String,
                     url: String) {
        
        if self.mainType.count > 0,
            self.subType.count > 0,
            self.title.count > 0,
            self.introduction.count > 0,
            self.subType.count > 0  {
            
            /// Sjekker om denne posten finnes fra før
            CloudKitArticle.doesArticleExist(introduction: self.introduction) { (result) in
                if result == true {
                    self.message = NSLocalizedString("Existing data", comment: "AddArticleView")
                    self.message1 = NSLocalizedString("This article was stored earlier", comment: "AddArticleView")
                    self.alertIdentifier = AlertID(id: .first)
                } else {
                    let article = Article(mainType: self.mainType,
                                          subType: self.subType,
                                          title: self.title,
                                          introduction: self.introduction,
                                          url: self.url)
                    CloudKitArticle.saveArticle(item: article) { (result) in
                        switch result {
                        case .success:
                            self.message = NSLocalizedString("Article saved", comment: "AddArticleView")
                            self.message1 = NSLocalizedString("This article is now stored in CloudKit", comment: "AddArticleView")
                            self.alertIdentifier = AlertID(id: .first)
                        case .failure(let err):
                            self.message = err.localizedDescription
                            self.alertIdentifier = AlertID(id: .first)
                        }
                    }
                }
            }
        } else {
            self.message = NSLocalizedString("Missing data", comment: "AddArticleView")
            self.message1 = NSLocalizedString("Check that all fields have a value", comment: "AddArticleView")
            self.alertIdentifier = AlertID(id: .first)
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

