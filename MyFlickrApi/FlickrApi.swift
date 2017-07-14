//
//  FlickrApi.swift
//  MyFlickrApi
//
//  Created by Yoshito Komiya on 2017/07/07.
//  Copyright © 2017 Yoshito Komiya. All rights reserved.
//

import Foundation

enum Method: String {
    case interestingPhotos = "flickr.interestingnesss.getList"
    case recentPhotos = "flickr.photos.getRecent"
}

enum FlickrError: Error {
    case invalidJSONData
}

struct FlickrAPI {
    
    private static let baseURLString = "https://api.flickr.com/services/rest"
    private static let apiKey = "4988de768f357258c5e071ff41525a68"
    
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter
    }()
    
    
    // create URL
    static var interestingPhotosURL: URL {
        return flickrURL(method: .interestingPhotos, parameters: ["extras": "url_s,date_taken"])
    }
    
    private static func flickrURL(method: Method, parameters: [String: String]?) -> URL {
        var components = URLComponents(string: baseURLString)!
        var queryItems = [URLQueryItem]()
        //  var queryItems: [URLQueryItem] = []

        let baseParams = [
            "method": method.rawValue,
            "format": "json",
            "api_key": apiKey,
            "nojsoncallback": "1"
        ]
        
        for (key, value) in baseParams {
            let item = URLQueryItem(name: key, value: value)
            queryItems.append(item)
        }
        
//        if let additinalParams = parameters {
//            for (key, value) in additinalParams {
//                let item = URLQueryItem(name: key, value: value)
//                queryItems.append(item)
//            }
//        }
        components.queryItems = queryItems
        return components.url!
    }
    
    
    
    private static func photo(fromJSON json: [String : Any]) -> Photo? {
        guard let photoID = json["id"] as? String,
              let title = json["title"] as? String,
              let photoURLString = json["url_s"] as? String,
              let url = URL(string: photoURLString),
              let dateString = json["datetaken"] as? String,
              let dateTaken = dateFormatter.date(from: dateString) else {
                
                // Don't have enough info to create a photo
                return nil
        }
        return Photo(title: title, photoID: photoID, remoteURL: url, dateTaken: dateTaken)
    }
    
    
    
    static func photos(fromJSON data: Data) -> PhotosResult {
        do{
            let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
            
            guard let jsonDictionary = jsonObject as? [AnyHashable : Any],
                  let photos = jsonDictionary["photos"] as? [String : Any],
            let photoArray = photos["photo"] as? [[String : Any]] else {
                    // the json structure doesn't match out expectation
                    return .failure(FlickrError.invalidJSONData)
            }
            
            var finalPhotos = [Photo]()
            for photoJSON in photoArray {
                if let photo = photo(fromJSON: photoJSON) {
                    finalPhotos.append(photo)
                }
            }
            if finalPhotos.isEmpty && !photoArray.isEmpty {
                return .failure(FlickrError.invalidJSONData)
            }
            return .success(finalPhotos)
        } catch let error {
            return .failure(error)
        }
    }
}
