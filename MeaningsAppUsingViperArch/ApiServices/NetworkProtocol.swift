//
//  NetworkProtocol.swift
//  Meanings
//
//  Created by 1964058 on 02/06/22.
//

import Foundation

protocol NetworkSession {
    typealias Handler = (Data?, URLResponse?, Error?) -> Void
    func dataTask(with request: URLRequest, completionHandler:@escaping Handler) -> URLSessionDataTaskProtocol
}

extension URLSession:NetworkSession {
    typealias Handler = NetworkSession.Handler
    
    func dataTask(with request: URLRequest, completionHandler: @escaping Handler) -> URLSessionDataTaskProtocol {
        return dataTask(with: request, completionHandler: completionHandler) as URLSessionDataTask
    }
}

protocol URLSessionDataTaskProtocol {
    func resume()
}

extension URLSessionDataTask: URLSessionDataTaskProtocol {}


