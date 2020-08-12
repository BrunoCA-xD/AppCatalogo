//
//  FileDM.swift
//  TudoNosso
//
//  Created by Bruno Cardoso Ambrosio on 19/11/19.
//  Copyright © 2019 Joao Flores. All rights reserved.
//

import Foundation
import FirebaseStorage
import SDWebImage

protocol StorageAccessor {
    var storageName: String {get}
    var storage: Storage { get }
    func recoverImage(imageFile: String?, imagePlaceholder: String, completion: @escaping (UIImage?,Error?) ->())
}

extension StorageAccessor {
    var storage: Storage { Storage.storage() }
    
    func recoverImage(imageFile: String?, imagePlaceholder: String, completion: @escaping (UIImage?,Error?) ->()) {
        
        let placeholderImage = UIImage(named: imagePlaceholder)
        guard let imageFile = imageFile else {
            completion(placeholderImage, nil)
            return
        }
        storage.reference().child("\(storageName)/\(imageFile)").downloadURL { (imageUrl, err) in
            if let err = err {
                print(err.localizedDescription)
                completion(nil,err)
            }else {
                do {
                    let imageView = UIImageView()
                    
                    imageView.sd_setImage(with: imageUrl,
                                          placeholderImage: placeholderImage,
                                          options: .highPriority,
                                          context: nil,
                                          progress: nil) { (image, error, cacheType, urlImage) in
                                            completion(image,nil)
                    }
                } catch {
                    print("erro na imagem")
                }
            }
        }
    }
}
