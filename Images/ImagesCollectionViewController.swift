//
//  ImagesCollectionViewController.swift
//  Images
//
//  Created by V Lanfranchi on 15/11/2017.
//  Copyright © 2017 V Lanfranchi. All rights reserved.
//


import UIKit
import Photos

class ImagesCollectionViewController: UICollectionViewController, UIImagePickerControllerDelegate {
    
    var cameraRoll: PHAssetCollection!
    var photoAssets: PHFetchResult<AnyObject>!
    var assetThumbnailSize: CGSize!
    var selectedPhoto: PHAsset!
    var imagePickerController : UIImagePickerController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
     //        self.collectionView?.register(UINib(nibName: "PhotoCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "photoCell")
        
        //Load the camera roll album into memory
        let collection = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumUserLibrary, options: nil)
        if let first_Obj:AnyObject = collection.firstObject{
            self.cameraRoll = first_Obj as! PHAssetCollection
        }
        
    }
    
    @IBAction func takePhoto(_ sender: UIBarButtonItem) {
        
        imagePickerController = UIImagePickerController()
        
        //imagePickerController.delegate = self as! UIImagePickerControllerDelegate & UINavigationControllerDelegate
        
        if !UIImagePickerController.isSourceTypeAvailable(.camera){
            
            let alertController = UIAlertController.init(title: nil, message: "Sorry, your device does not have a camera.", preferredStyle: .alert)
            
            let okAction = UIAlertAction.init(title: "OK", style: .default, handler: {(alert: UIAlertAction!) in
            })
            
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
            
        }
        else{
            imagePickerController.sourceType = .camera
            present(imagePickerController, animated: true, completion: nil)
        }

    }
    override func viewWillAppear(_ animated: Bool) {
        // Get size of the collectionView cell for thumbnail
        if let layout = self.collectionView!.collectionViewLayout as? UICollectionViewFlowLayout{
            let cellSize = layout.itemSize
            self.assetThumbnailSize = CGSize(width: cellSize.width, height: cellSize.height)
        }
        let photoAuth = PHPhotoLibrary.authorizationStatus()
        if photoAuth == .notDetermined {
            PHPhotoLibrary.requestAuthorization({status in
                if status == .authorized {
                    self.loadPhotos()
                }
            })
        }
        else if photoAuth == .authorized {
            self.loadPhotos()
        }
    }
    
    private func loadPhotos() {
        self.photoAssets = (PHAsset.fetchAssets(in: self.cameraRoll, options: nil) as AnyObject!) as! PHFetchResult<AnyObject>!
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (self.photoAssets != nil){
            return self.photoAssets.count
        }
        return 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath as IndexPath) as! PhotoCollectionViewCell
        let asset: PHAsset = self.photoAssets[indexPath.item] as! PHAsset
        
        PHImageManager.default().requestImage(for: asset, targetSize: self.assetThumbnailSize, contentMode: .aspectFill, options: nil, resultHandler: {(result, info) in
            if result != nil {
                cell.photoView.image = result
            }
        })
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedPhoto = self.photoAssets[indexPath.item] as! PHAsset
        self.performSegue(withIdentifier: "photoDetails", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "photoDetails" {
            if let nextVC = segue.destination as? PhotoDetailsViewController {
                nextVC.photo = self.selectedPhoto
            }
        }
    }
    
}

