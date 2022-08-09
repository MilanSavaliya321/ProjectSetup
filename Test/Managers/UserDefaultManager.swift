//
//  UserDefaultManager.swift
//  Test
//
//  Created by PC on 02/07/22.
//

import Foundation

final class UserDefaultManager {
    
    static let share = UserDefaultManager()
    
    let defaults = UserDefaults.standard
    
    ///   this func for store userDefault Value
    func setStringUserDefaultValue(value : String , key : UserDefaultKeys){
        UserDefaults.standard.setValue(value, forKey: key.rawValue)
    }
    ///   this func for get userDefault Value
    func getStringUserDefaultValue(key : UserDefaultKeys) -> String{
        return UserDefaults.standard.string(forKey: key.rawValue) ?? ""
    }
    ///   this func for store Int userDefault Value
    func setIntegerUserDefaultValue(value : Int , key : UserDefaultKeys){
        UserDefaults.standard.setValue(value, forKey: key.rawValue)
    }
    ///   this func for get Int userDefault Value
    func getIntegerUserDefaultValue(key : UserDefaultKeys) -> Int{
        return UserDefaults.standard.integer(forKey: key.rawValue)
    }
    ///   this func for store Boolean userDefault Value
    func setBoolUserDefaultValue(value : Bool , key : UserDefaultKeys){
        UserDefaults.standard.setValue(value, forKey: key.rawValue)
    }
    ///   this func for get Boolean userDefault Value
    func getBoolUserDefaultValue(key : UserDefaultKeys) -> Bool{
        return UserDefaults.standard.bool(forKey: key.rawValue)
    }
    ///   this func for store userDefault Value
    func setDoubleUserDefaultValue(value : Double , key : UserDefaultKeys){
        UserDefaults.standard.setValue(value, forKey: key.rawValue)
    }
    ///   this func for get userDefault Value
    func getDoubleUserDefaultValue(key : UserDefaultKeys) -> Double{
        return UserDefaults.standard.double(forKey: key.rawValue)
    }
    func valueExists(forKey key: UserDefaultKeys) -> Bool {
        return UserDefaults.standard.value(forKey: key.rawValue) != nil
    }
    
    func storeModelToUserDefault<T>(userData : T , key : UserDefaultModelKeys) where T: Codable{
        defaults.set(try? JSONEncoder().encode(userData) , forKey: key.rawValue)
    }
    
    func getModelDataFromUserDefults<T : Codable>(userData : T.Type ,key : UserDefaultModelKeys) -> T? {
        print(userData)
        guard let data = defaults.data(forKey: key.rawValue) else {
            return nil
        }
        guard let value = try? JSONDecoder().decode(T.self, from: data) else {
            fatalError("unable to decode this data")
        }
        return value
    }
    
    func clearAllUserDataAndModel(){
        removeUserDefualtsModels(key: .storeRegisterModel)
        removeUserDefualtsModels(key: .storeLoginModel)
    }
    
    func removeUserdefultsKey(key : UserDefaultKeys){
        defaults.removeObject(forKey: key.rawValue)
    }
    
    func removeUserDefualtsModels(key : UserDefaultModelKeys){
        defaults.removeObject(forKey: key.rawValue)
    }
}

enum UserDefaultModelKeys: String {
    case storeLoginModel                                               = "StoreLoginModel"
    case storeRegisterModel                                            = "StoreRegisterModel"
}

enum UserDefaultKeys: String {
    case isUserLogin                                                   = "isUserLogin"
    case appToken                                                      = "AppToken"
    case fbLoginID                                                     = "fbLoginID"
    case fbName                                                        = "fbName"
    case fbEmail                                                       = "fbEmail"
    case isFbLogin                                                     = "isFbLogin"
    case isVersionUpadted                                              = "isVersionUpdated"
}
