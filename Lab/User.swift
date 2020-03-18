//
//  User.swift
//  Lab
//
//  Created by Mateus Rodrigues on 17/03/20.
//  Copyright © 2020 Mateus Rodrigues. All rights reserved.
//

import UIKit
import CloudKit

enum Role: String {
    case student
    case teacher
}

extension Role {

    init(_ value: CKRecordValue) {
        self = Role(rawValue: value as! String)!
    }

    var value: CKRecordValue {
        return self.rawValue as CKRecordValue
    }

}

extension UIImage {
    
    convenience init?(_ value: CKRecordValue) {
        guard let asset = value as? CKAsset, let data = asset.data else { return nil }
        self.init(data: data)
    }
    
    var asset: CKAsset {
        return CKAsset(fileURL: self.url!)
    }
    
}

class User: CKModel {
    
    var record: CKRecord
    
    @CKField(key: "name")
    var name: String?

    @CKField(key: "photo", get: { UIImage($0) }, set: { $0!.asset })
    var image: UIImage?
    
    @CKField(key: "role", get: { Role($0) }, set: { $0.value })
    var role: Role
        
    var photo: UIImage? {
        get {
            if let photo = loadedPhoto {
                return photo
            } else {
                let photo = (record["photo"] as? CKAsset)?.image
                self.loadedPhoto = photo
                return photo
            }
        }
        set {
            guard let image = newValue, let url = image.url else { return }
            record["photo"] = CKAsset(fileURL: url)
            loadedPhoto = image
        }
    }
    
    var loadedPhoto: UIImage?
    
    init(record: CKRecord) {
        self.record = record
    }
    
}
