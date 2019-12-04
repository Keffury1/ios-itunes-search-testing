//
//  NetworkDownloaderProtocol.swift
//  iTunes Search
//
//  Created by Bobby Keffury on 12/4/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation

protocol NetworkDownloaderProtocol {
    func executeRequestAsynchronously(request: URLRequest, completion: @escaping (Data?, Error?) -> Void)
}


extension URLSession: NetworkDownloaderProtocol {
    func executeRequestAsynchronously(request: URLRequest, completion: @escaping (Data?, Error?) -> Void) {
        let dataTask = URLSession.shared.dataTask(with: request) { (data, _, error) in
            completion(data, error)
        }
        dataTask.resume()
    }
}

class NetworkMockDownloader: NetworkDownloaderProtocol {
    
    var data: Data?
    
    func executeRequestAsynchronously(request: URLRequest, completion: @escaping (Data?, Error?) -> Void) {
        DispatchQueue.global().async {
            completion(self.data,nil)
        }
    }
}
