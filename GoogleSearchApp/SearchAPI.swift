//
//  SearchAPI.swift
//  GoogleSearchApp
//
//  Created by Yura on 11/12/18.
//  Copyright © 2018 Yuriy Kudreika. All rights reserved.
//

import Foundation

class SearchAPI {

    // MARK: - Properties

    let queue = OperationQueue()
    
    // MARK: - SearchAPI
    
    func operationStartWith(searchText: String, complition: @escaping ([String]?) -> ()) {
        let request = returnURLRequest(searchText: searchText)
        
        let loadOperation = LoadOperation(request: request)
        let parseOperation = ParseOperation(nil)
        parseOperation.addDependency(loadOperation)
        
        let block = BlockOperation {
            complition(parseOperation.linkArray)
        }
        block.addDependency(parseOperation)
        queue.addOperations([loadOperation, parseOperation, block], waitUntilFinished: false)
    }
    
    func operationCancel() {
        queue.cancelAllOperations()
        print("================================== Cancel all =========================================")
    }
    
    // MARK: - Help methods

    func returnURLRequest(searchText: String) -> URLRequest {
        var urlString: String = searchText
        let startIndex = 1
        
        // FIXME: идентификатор проекта: skilled-tiger-221019
        // FIXME: идентификатор поисковой системы: 005505095743673218968:ploiaiqzo0c
        // FIXME: Ключи API: AIzaSyB_tedj2v_efYUD4xZ4XYjVoehNs7G2CrM
        
        urlString = urlString.replacingOccurrences(of: " ", with: "+")
        let apiKey = "AIzaSyB_tedj2v_efYUD4xZ4XYjVoehNs7G2CrM"
        let bundleId = "com.skilled-tiger-221019"
        let searchEngineId = "005505095743673218968:ploiaiqzo0c"
        let serverAddress = String(format: "https://www.googleapis.com/customsearch/v1?key=%@&cx=%@&q=%@&start=%d", apiKey, searchEngineId, urlString, startIndex)
        let url = serverAddress.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let finalUrl = URL(string: url!)!
        var request = URLRequest(url: finalUrl, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10)
        request.httpMethod = "GET"
        request.setValue(bundleId, forHTTPHeaderField: "X-Ios-Bundle-Identifier")
        return request
    }
}
