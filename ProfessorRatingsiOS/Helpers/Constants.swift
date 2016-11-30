import Alamofire
import UIKit

struct Config {
    static let encryptionKey = "rateMyProfessor"
    static let iv = "0127367878682345"
    static let baseURL =  "http://mive.us"
    static let registrationURL = "\(baseURL)/users"
    static let loginURL = "\(baseURL)/login"
    static let searchURL = "\(baseURL)/search"
    static let reviewURL = "\(baseURL)/reviews"
    static let courseURL = "\(baseURL)/courses"
    static let likeURL = "\(baseURL)/likes"
    static let suggestionURL = "\(baseURL)/suggestions"
}

struct PR_Colors {
    static let lightGreen = UIColor(red:0.31, green:0.89, blue:0.76, alpha:1.00)
    static let brightOrange = UIColor(red:1.00, green:0.54, blue:0.29, alpha:1.00)
}
