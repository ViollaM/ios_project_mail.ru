//
//  ImageLoaderService.swift
//  StepperApp
//
//  Created by Стас Чебыкин on 02.12.2021.
//

import Foundation
import FirebaseStorage
import UIKit

enum imageError: Error {
    case networkProblem
}

protocol ImageLoaderService {
    func upload(image: UIImage, completion: @escaping (Result<String, Error>) -> Void)
    func getImage(with name: String, completion: @escaping (UIImage?) -> Void)
}

final class ImageLoaderServiceImplementation: ImageLoaderService {
    
    let storage = Storage.storage().reference()
    var cache: [String: UIImage] = [:]
    
    func getImage(with name: String, completion: @escaping (UIImage?) -> Void) {
        if let image = cache[name]{
            completion(image)
            return
        }
        
        storage.child(name).getData(maxSize: 15 * 1024 * 1024) { data, error in
            if let data = data, let image = UIImage(data: data) {
                self.cache[name] = image
                completion(UIImage(data: data))
            } else {
                completion(nil)
            }
        }
    }
    
   
    func upload(image: UIImage, completion: @escaping (Result<String, Error>) -> Void) {
        guard let data = image.jpegData(compressionQuality: 0.5) else {
            completion(.failure(imageError.networkProblem))
            return
        }
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        let randomName = UUID().uuidString
        
        storage.child(randomName).putData(data, metadata: metadata) { metadata, error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(randomName))
            }
        }
    }
    

    
}


//var imageId: String = ""
//imageLoaderService.upload(usimage: image) { [weak self] result in
//    guard self != nil else {
//        return
//    }
//    switch result{
//    case .success(let Id):
//        imageId = Id
//    case.failure(let error):
//        completion(error)
//        return
//    }
//}
