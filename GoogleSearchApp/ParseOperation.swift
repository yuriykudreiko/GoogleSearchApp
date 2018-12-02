//
//  ParseOperation.swift
//  GoogleSearchApp
//
//  Created by Yura on 11/12/18.
//  Copyright © 2018 Yuriy Kudreika. All rights reserved.
//

import Foundation

class ParseOperation: AsyncOperation {
    
    var linkArray: [String]?
    private let _inputData: Data?
    
    init(_ data: Data?) {
        _inputData = data
        super.init()
    }
    
    var inputData: Data? {
        var data: Data?
        if let inputData = _inputData {
            data = inputData
        } else if let dataProvider = dependencies.filter({ $0 is DataPass}).first as? DataPass {
            data = dataProvider.data
        }
        return data
    }
    
    override func main() {
        guard self.state != .finished else { return }
        var tempArray = [String]()
        if let data = inputData {
            do {
                let result = try JSONDecoder().decode(SearchResult.self, from: data)
                print(result.searchInformation)
                if let count = Int(result.searchInformation.totalResults) {
                    if count > 0 {
                        if let results = result.items {
                            for res in results {
                                guard !isCancelled else { return }
                                tempArray.append(res.link)
                            }
                            self.linkArray = tempArray
                            self.state = .finished
                        }
                    } else {
                        self.state = .finished
                    }
                }
            } catch {
                print(error)
            }
        }
    }
}
