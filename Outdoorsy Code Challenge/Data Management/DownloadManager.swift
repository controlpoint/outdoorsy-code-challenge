//
//  DownloadManager.swift
//  Outdoorsy Code Challenge
//
//  Created by Alonzo Wilkins on 6/10/20.
//  Copyright © 2020 Anchor Point. All rights reserved.
//

import UIKit

class DownloadManager: NSObject {
    
    static let shared = DownloadManager()
    
    var dataTask: URLSessionDataTask?

    func performSearch(_ search: String, completionBlock: @escaping (Error?, [ModelObject]?) -> ()) {
        
        guard let url = urlFromSearchTerm(search: search) else {
            
            let error = NSError.init(domain: "", code: 0, userInfo: nil)
            completionBlock(error, nil)
            return
        }

        dataTask = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            
            guard let strongSelf = self else { return }

            defer {
                
                strongSelf.dataTask = nil
            }
            
            var resultError: Error?
            var results: [ModelObject] = []
            
            if let error = error {
                
                resultError = error
            }
            else if let data = data {
                
                do {
                    results = try strongSelf.processJSONData(jsonData: data)
                } catch let jsonError {
                    
                    resultError = jsonError
                }
            }

            DispatchQueue.main.async {
                
                completionBlock(resultError, results)
            }
        }
        
        dataTask?.resume()
    }
}

extension DownloadManager {
    
    func objectFromDict(dict: [String : Any]) -> ModelObject? {
        
        guard let attributes = dict["attributes"] as? [String: Any] else { return nil }
        guard let name = attributes["name"] as? String else { return nil }
        
        guard let primaryImageURLString = attributes["primary_image_url"] as? String else { return nil }
        guard let primaryImageURL = URL(string: primaryImageURLString) else { return nil }

        return ModelObject(name: name, url: primaryImageURL)
    }
    
    func processJSONData(jsonData: Data) throws -> [ModelObject] {
        
        var results: [ModelObject] = []
        var json: [String : Any]?
        
        do {
            
            json = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String : Any]
        }
        catch {
            
            throw error
        }
        
        guard let dataArray = json?["data"] as? [ [String: Any] ] else  {
            
            let error = NSError.init(domain: "", code: 0, userInfo: nil)
            throw error
        }
        
        for data in dataArray {
            
            guard let result = objectFromDict(dict: data) else {
                
                print("ERROR in '\(#function) \(#line)': error processing data: \(data)")
                continue
            }
            
            results.append(result)
        }

        return results
    }
}

extension DownloadManager {
    
    func urlFromSearchTerm(search: String) -> URL? {
        
        guard let escapedSearch = search.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return nil }
        
        guard var urlComponnents = URLComponents(string: queryString) else { return nil }

        urlComponnents.queryItems = [URLQueryItem(name: "filter[keywords]", value: escapedSearch)]
        
        return urlComponnents.url
    }
}
