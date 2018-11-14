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
        guard self.state != .finished else { print("LoadOperation cancel"); return }
        var tempArray = [String]()
//        self.completionBlock = {
//            print("asdfvdfvdfvdf")
//            
//        }
        if let data = inputData {
            do {
                if let jsonResult = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
                    guard self.state != .finished else { print("LoadOperation cancel"); return }
                    let items = jsonResult["items"] as! [[String: AnyObject]]
                    for item in items {
                        print(item["link"]!)
                        guard !isCancelled else { return }
                        tempArray.append(item["link"] as! String)
                    }
                    self.linkArray = tempArray
                    self.state = .finished
                }
            } catch {
                print(error.localizedDescription)
            }
        }
        
    }
}
