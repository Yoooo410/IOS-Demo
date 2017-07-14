//
//  Photo.swift
//  MyFlickrApi
//
//  Created by Yoshito Komiya on 2017/07/09.
//  Copyright © 2017 Yoshito Komiya. All rights reserved.
//

import Foundation


class Photo {
    
    let title:String
    let photoID: String
    let remoteURL: URL
    let dateTaken: Date
    
    init(title: String, photoID: String, remoteURL: URL, dateTaken: Date) {
        self.title = title
        self.photoID = photoID
        self.remoteURL = remoteURL
        self.dateTaken = dateTaken
    }
}

extension Photo: Equatable {
    public static func == (lhs: Photo, rhs: Photo) -> Bool {
        return lhs.photoID == rhs.photoID
    }
}
