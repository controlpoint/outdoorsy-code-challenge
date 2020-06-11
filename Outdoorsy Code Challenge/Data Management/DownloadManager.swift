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
    
    private var dataTask: URLSessionDataTask?
}

// MARK: - Public methods
extension DownloadManager {
    
    func performSearch(_ search: String, completionBlock: @escaping (Error?, [ModelObject]?) -> ()) {
        
        // we're not implementing pagination right now since the count of results seems to be reasonable, but we would want to implement that for a shipping product
        // FIXME: implement pagination and count limits
        guard let url = urlFromSearchTerm(search: search, queryName: filterQueryParameter) else {
            
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
    
    func downloadImage(from url: URL, completion: @escaping (Error?, UIImage?) -> ()) {
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            
            var result: UIImage?
            var resultError: Error?
            
            if let error = error {
                
                resultError = error
            }
            
            if let httpURLResponse = response as? HTTPURLResponse,
                httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType,
                mimeType.hasPrefix("image") {
                
                if let data = data, let image = UIImage(data: data) {
                    
                    result = image.ofSize(CGSize(width: maxImageDimension, height: maxImageDimension))
                }
            }
            
            DispatchQueue.main.async {
            
                completion(resultError, result)
            }
        }.resume()
    }
}

// MARK: Data Processing
extension DownloadManager {
    
    func objectFromDict(dict: [String : Any]) -> ModelObject? {
        
        guard let attributes = dict["attributes"] as? [String: Any] else { return nil }
        guard let name = attributes["name"] as? String else { return nil }
        
        guard let primaryImageURLString = attributes["primary_image_url"] as? String else { return nil }
        guard let primaryImageURL = URL(string: primaryImageURLString) else { return nil }

        return ModelObject(name: name, imageURL: primaryImageURL)
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

// MARK: - Utilities
extension DownloadManager {
    
    func urlFromSearchTerm(search: String, queryName: String) -> URL? {
        
        guard let escapedSearch = search.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return nil }
        guard var urlComponnents = URLComponents(string: queryString) else { return nil }

        urlComponnents.queryItems = [URLQueryItem(name: queryName, value: escapedSearch)]
        
        return urlComponnents.url
    }
}
