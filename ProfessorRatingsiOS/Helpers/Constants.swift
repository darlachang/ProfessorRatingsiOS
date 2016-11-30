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
}

struct PR_Colors {
    static let lightGreen = UIColor(red:0.31, green:0.89, blue:0.76, alpha:1.00)
    static let brightOrange = UIColor(red:1.00, green:0.54, blue:0.29, alpha:1.00)
}

let majorPickerData: [String] = ["Applied Economics & Management","Architecture","Art","Biological & Environmental Engineering","Biomedical Sciences","Civil & Environmental Engineering","Chemistry","Computer Science","Electrical & Computer Engineering", "Economics", "Food Science", "Hotel Administration","History","Information Science","Jewish Studies","Latin American Studies","Mechanical & Aerospace Engineering","Mathematics","Materials Science & Engineering","Music","Graduate Management Business Admin","Nutritional Science","Operations Research & Information Engineering","Philosophy","Physics","Plant Biology","Psychology","Sociology","Statistical Science","Veterinary Medicine Molecular Medicine"]
let yearPickerData: [String] = ["2010","2011","2012","2013","2014","2015","2016","2017","2018", "2019", "2020"]
