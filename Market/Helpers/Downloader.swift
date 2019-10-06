//
//  Downloader.swift
//  Market
//
//  Created by jorge on 10/5/19.
//  Copyright © 2019 Administrador. All rights reserved.
//

import Foundation
import FirebaseStorage

let storage = Storage.storage()
var reachability : Reachability!

func uploadImages(images: [UIImage?], itemId: String, completion : @escaping(_ imagelinks: [String]) ->Void){
    
    reachability = try? Reachability.init()
    if reachability.connection != .unavailable {
        
        var uploadedImagesCount = 0
        var imagesLinkArray: [String] = []
        var nameSuffix = 0
        
        for image in images{
            
            let fileName = "ItemImages/" + itemId + "/" + "\(nameSuffix)"+".jpg"
            let imageData = image!.jpegData(compressionQuality: 0.5)
        
            saveImageInFirebase(imageData: imageData!, fileName: fileName) { (imageLink) in
                
                if imageLink != nil{
                    imagesLinkArray.append(imageLink!)
                    uploadedImagesCount += 1
                    
                    if uploadedImagesCount == images.count{
                        completion(imagesLinkArray)
                    }
                    
                }
            }
        }
        nameSuffix += 1
    }else{
        print("No internet connection")
    }
}

func saveImageInFirebase(imageData : Data, fileName: String, completion: @escaping(_ imageLink: String?) -> Void){
    
    var task: StorageUploadTask!
    let storageRef = storage.reference(forURL: kFILEREFERENCE).child(fileName)
    task = storageRef.putData(imageData, metadata: nil, completion: { (metadata, error) in
        
        task.removeAllObservers()
        
        if error != nil{
            print("Error uploading image",error!.localizedDescription)
            completion(nil)
            return
        }
        storageRef.downloadURL { (url, error) in
            guard let downloadUrl = url else{
                completion(nil)
              return
            }
            completion(downloadUrl.absoluteString)
        }
        
    })
    
}


func downloadImages(imageUrls : [String], completion: @escaping(_ images: [UIImage?]) -> Void){
    
    var imageArray: [UIImage] = []
    var downloadCounter = 0
    
    for link in imageUrls{
        let url = NSURL(string: link)
        let downloadQueue = DispatchQueue(label: "imageDownloadQueue")
        downloadQueue.async {
            downloadCounter += 1
            let data = NSData(contentsOf: url! as URL)
            if data != nil {
                imageArray.append(UIImage(data: data! as Data)!)
                if downloadCounter == imageArray.count{
                    DispatchQueue.main.async {
                         completion(imageArray)
                    }
                 }
                
            }else{
                print("No data images")
                completion(imageArray)
            }
        }
    }
    
}
