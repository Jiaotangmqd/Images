//
//  PhotoDetailsViewController.swift
//  Images
//
//  Created by V Lanfranchi on 15/11/2017.
//  Copyright © 2017 V Lanfranchi. All rights reserved.
//

import UIKit
import Photos

class PhotoDetailsViewController: UIViewController {
    
    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var metadataTextView: UITextView!
    
    var photo: PHAsset!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        PHImageManager.default().requestImage(for: self.photo, targetSize: self.photoView.frame.size, contentMode: .aspectFill, options: nil, resultHandler: {(result, info) in
            if result != nil {
                self.photoView.image = result
                
                let imageManager = PHImageManager.default()
                imageManager.requestImageData(for: self.photo, options: nil, resultHandler:{
                    (data, responseString, imageOriet, info) -> Void in
                    let imageData: NSData = data! as NSData
                    if let imageSource = CGImageSourceCreateWithData(imageData, nil) {
                        let imageProperties = CGImageSourceCopyPropertiesAtIndex(imageSource, 0, nil)! as NSDictionary
                        self.metadataTextView.text = imageProperties.description
                    }
                })
            }
        })
    }
    
}
