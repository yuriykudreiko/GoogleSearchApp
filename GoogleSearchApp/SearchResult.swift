//
//  SearchResult.swift
//  GoogleSearchApp
//
//  Created by Yura on 12/2/18.
//  Copyright © 2018 Yuriy Kudreika. All rights reserved.
//

import Foundation

struct SearchResult: Decodable {
    var items: [Items]?
    var searchInformation: SearchInformation
}

struct Items: Decodable {
    var displayLink: String
    var formattedUrl: String
    var htmlFormattedUrl: String
    var htmlSnippet: String
    var htmlTitle: String
    var kind: String
    var link: String
    var snippet: String
    var title: String
}

struct SearchInformation: Decodable {
    var formattedSearchTime: String
    var formattedTotalResults: String
    var searchTime: Double
    var totalResults: String
}
