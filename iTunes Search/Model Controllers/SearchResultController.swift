//
//  SearchResultController.swift
//  iTunes Search
//
//  Created by Spencer Curtis on 8/5/18.
//  Copyright © 2018 Lambda School. All rights reserved.
//

import Foundation

class SearchResultController {
    
    func performSearch(baseURL: URL, for searchTerm: String, resultType: ResultType, networkDownloader: NetworkDownloaderProtocol, completion: @escaping () -> Void) {
        
        // Creating URL components.
        var urlComponents = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
        let parameters = ["term": searchTerm,
                          "entity": resultType.rawValue]
        let queryItems = parameters.compactMap { URLQueryItem(name: $0.key, value: $0.value) }
        urlComponents?.queryItems = queryItems
        
        guard let requestURL = urlComponents?.url else { return }

        // Creating URL request using the url components.
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.get.rawValue
        
        networkDownloader.executeRequestAsynchronously(request: request) { (possibleData, possibleError) in
            // Validate accurate information.
                if let error = possibleError { NSLog("Error fetching data: \(error)") }
                guard let data = possibleData else { completion(); return }
                
                do {
                    // Parse Data
                    let jsonDecoder = JSONDecoder()
                    let searchResults = try jsonDecoder.decode(SearchResults.self, from: data)
                    
                    // Save Data
                    self.searchResults = searchResults.results
                } catch {
                    print("Unable to decode data into object of type [SearchResult]: \(error)")
                }
                
                // Notify the caller that we're done
                completion()
            }
        }
        
        
    
    let baseURL = URL(string: "https://itunes.apple.com/search")!
    var searchResults: [SearchResult] = []
}
