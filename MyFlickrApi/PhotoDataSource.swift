//
//  PhotoDataSource.swift
//  MyFlickrApi
//
//  Created by Yoshito Komiya on 2017/07/09.
//  Copyright © 2017 Yoshito Komiya. All rights reserved.
//

import UIKit


class PhotoDataSource: NSObject, UICollectionViewDataSource {
    
    var photos = [Photo]()
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let identifier = "collectionViewCell"
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! PhotoCollectionViewCell
            return cell
    }
}
