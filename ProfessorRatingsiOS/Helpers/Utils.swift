//
//  Utils.swift
//  ProfessorRatingsiOS
//
//  Created by Hongfei Li on 9/30/16.
//  Copyright © 2016 Hongfei Li. All rights reserved.
//

import Foundation
import CryptoSwift

class Utils {
    static func encrypt(_ s:String) -> String {
        let encryptedPW: String = try! s.encrypt(cipher: AES(key: Config.encryptionKey, iv: Config.iv))
        return encryptedPW
    }
}
