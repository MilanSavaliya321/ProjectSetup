import UIKit
import Foundation


extension Dictionary where Key == String, Value == Any {

    func prettyPrint() {
        print(self.prettify())
    }
    
    func prettify() -> String {
        var string: String = ""
        if let data = try? JSONSerialization.data(withJSONObject: self, options: .prettyPrinted){
            if let nstr = NSString(data: data, encoding: String.Encoding.utf8.rawValue){
                string = nstr as String
            }
        }
        return string
    }
}

struct TestModel: Codable {
    var webPages: [String]?
    var stateProvince: String?
    var alphaTwoCode: String?
    var domains: [String]?
    var country: String?
    var name: String?
    
    enum CodingKeys: String, CodingKey {
        case webPages
        case stateProvince
        case alphaTwoCode
        case domains, country, name
    }
}

extension URL {
    
    func appending(_ urlQueryItems: [URLQueryItem]) -> URL {
        guard var urlComponents = URLComponents(string: absoluteString) else { return absoluteURL }
        var queryItems: [URLQueryItem] = urlComponents.queryItems ??  []
        for item in urlQueryItems {
            queryItems.append(item)
        }
        urlComponents.queryItems = queryItems
        return urlComponents.url!
    }
    
}

func apiCall(countryName: String,comp :@escaping (([TestModel])->())) {
    let url = URL(string: "http://universities.hipolabs.com/search")?.appending([URLQueryItem(name: "country", value: countryName)])
    print(url!)
    URLSession.shared.dataTask(with: url!) { data, response, error in
        if let error = error {
            print("HTTP Request Failed \(error)")
            comp([])
        }
        if let data = data {
            let decoder = JSONDecoder()
            let arr = try? decoder.decode([TestModel].self, from: data)
            comp(arr ?? [])
        } else {
            comp([])
        }
    }.resume()
}

apiCall(countryName: "India") { arr in
    
    print(arr)
//    var disct = [String: [TestModel]]()
//    for (index, value) in arr.enumerated() {
//
//        if index == 11 {
//            break
//        }
//
//        if let country = value.country {
//            let new = arr.filter {TestModel in
//                return TestModel.country ?? ""  == country
//            }
//            disct["\(country)"] = new
//        }
//    }
//
//    print(disct)
}
