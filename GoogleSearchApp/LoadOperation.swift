//
//  LoadOperation.swift
//  GoogleSearchApp
//
//  Created by Yura on 11/12/18.
//  Copyright © 2018 Yuriy Kudreika. All rights reserved.
//

import Foundation

protocol DataPass {
    var data: Data? { get }
}

extension LoadOperation: DataPass {
    var data: Data? {
        return outputData
    }
}

class LoadOperation: AsyncOperation {
    
    // MARK: - Properties

    private let request: URLRequest
    var outputData: Data?
    
    // MARK: - Creation

    init(request: URLRequest) {
        self.request = request
        super.init()
    }
    
    override func main() {
        guard self.state != .finished else { return }
        asyncLoadWith(request: request) { (data) in
            guard self.state != .finished else { return }
            self.outputData = data
            self.state = .finished
        }
    }
    
    // MARK: - Help methods
    
    func asyncLoadWith(request: URLRequest, complition: @escaping((Data?) -> ())) {
        let task = URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
            if let data = data {
                complition(data)
            }
        }
        task.resume()
    }
}
