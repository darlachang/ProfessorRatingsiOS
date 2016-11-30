import Alamofire

class User {
    var id:String?
    var name:String?
    var email:String
    var password:String
    var major:String?
    var yearOfGraduation:String?
    var status:String?
    init() {
        email = ""
        password = ""
    }
    init(name:String, email:String, password:String){
        self.name = name
        self.email = email
        self.password = password
    }
}
