//
//  ViewController.swift
//  MyFlickrApi
//
//  Created by Yoshito Komiya on 2017/07/07.
//  Copyright © 2017 Yoshito Komiya. All rights reserved.
//

import UIKit

class PhotosViewController: UIViewController, UICollectionViewDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    var store: PhotoStore!
    let photoDataSource = PhotoDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView.dataSource = photoDataSource
        self.collectionView.delegate = self
        
        store.fetchInterestingPhotos { (PhotosResult) in
            
            // When the task is done we will get the photosResult of [Photo]
            // async task
            switch PhotosResult {
            case let .success(photos):
                self.photoDataSource.photos = photos
                
            case let .failure(error):
                print("Error fetching interesting photos: \(error)")
                self.photoDataSource.photos.removeAll()
            }
            self.collectionView.reloadSections(IndexSet(integer:0))
        }
    }

    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        let photo = photoDataSource.photos[indexPath.row]
        // Download the image data, which could take some time.
        store.fetchImage(for: photo){ (result) in
            //The index path for the photo mignt have changed between the time
            // The request started and finshed, so we have to find the most recent indexPath
            guard let photoIndex = self.photoDataSource.photos.index(of: photo),
                case let .success(image) = result else {return}
            
            let photoIndexPath = IndexPath(item: photoIndex, section:0)
            
            if let cell = self.collectionView.cellForItem(at: photoIndexPath) as? PhotoCollectionViewCell{
                cell.update(with: image)
            }
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

