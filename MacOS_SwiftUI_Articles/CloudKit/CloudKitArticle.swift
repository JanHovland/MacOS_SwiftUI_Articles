//
//  CloudKitArticle.swift
//  MacOS_SwiftUI_Articles
//
//  Created by Jan Hovland on 16/04/2020.
//  Copyright © 2020 Jan Hovland. All rights reserved.
//

import CloudKit
import SwiftUI

struct CloudKitArticle {
    struct RecordType {
        static let Article = "Article"
    }
    /// MARK: - errors
    enum CloudKitHelperError: Error {
        case recordFailure
        case recordIDFailure
        case castFailure
        case cursorFailure
    }
    
    // MARK: - fetching from CloudKit
    static func fetchArticle(predicate:  NSPredicate, completion: @escaping (Result<Article, Error>) -> ()) {
        let query = CKQuery(recordType: RecordType.Article, predicate: predicate)
        let operation = CKQueryOperation(query: query)
        operation.desiredKeys = ["mainType",
                                 "subType",
                                 "title",
                                 "introduction",
                                 "url"]
        operation.resultsLimit = 50
        operation.recordFetchedBlock = { record in
            DispatchQueue.main.async {
                let recordID = record.recordID
                guard let mainType  = record["mainType"] as? String else { return }
                guard let subType  = record["subType"] as? String else { return }
                guard let title  = record["title"] as? String else { return }
                guard let introduction = record["introduction"] as? String else { return }
                guard let url = record["url"] as? String else { return }
                 
                let article = Article(recordID: recordID,
                                      mainType: mainType,
                                      subType: subType,
                                      title: title,
                                      introduction: introduction,
                                      url: url)
                completion(.success(article))
            }
        }
        operation.queryCompletionBlock = { ( _, err) in
            DispatchQueue.main.async {
                if let err = err {
                    completion(.failure(err))
                    return
                }
            }
        }
        CKContainer.default().privateCloudDatabase.add(operation)
    }
}


