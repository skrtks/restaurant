//
//  MenuController.swift
//  Restaurant
//
//  Created by Sam Kortekaas on 28/11/2017.
//  Copyright © 2017 Kortekaas. All rights reserved.
//

import Foundation

let baseURL = URL(string: "http://localhost:8090/")!

class MenuController {
    //let baseURL = URL(string: "http://localhost:8090/")!
}

func fetchCatagories(completion: @escaping ([String]?) -> Void) {
    let categoryURL = baseURL.appendingPathComponent("catagories")
    
    let task = URLSession.shared.dataTask(with: categoryURL) { (data, response, error) in
        if let data = data, let jsonDictionary = try? JSONSerialization.jsonObject(with: data) as? [String: Any], let categories = jsonDictionary?["catagories"] as? [String] {
            completion(categories)
        }
        else {
            completion(nil)
        }
    }
    task.resume()
    
}

func fetchMenuItems(catagoryName: String, completion: @escaping ([MenuItem]?) -> Void) {
    let initialMenuURL = baseURL.appendingPathComponent("menu")
    var components = URLComponents(url: initialMenuURL, resolvingAgainstBaseURL: true)!
    components.queryItems = [URLQueryItem(name: "category", value: catagoryName)]
    let menuURL = components.url!
    
    let task = URLSession.shared.dataTask(with: menuURL) { (data, response, error) in
        let jsonDecoder = JSONDecoder()
        if let data = data, let menuItems = try? jsonDecoder.decode(MenuItems.self, from: data) {
            completion(menuItems.items)
        } else {
            completion(nil)
        }
    }
    task.resume()
}

func submitOrder(menuIds: [Int], completion: @escaping (Int?) -> Void) {
    
    let orderURL = baseURL.appendingPathComponent("order")
    
    var request = URLRequest(url: orderURL)
    request.httpMethod = "post"
    request.setValue("application/json", forHTTPHeaderField: "Content-type")
    let data: [String: Any] = ["menuIds": menuIds]
    let jsonEncoder = JSONEncoder()
    let jsonData = try? jsonEncoder.encode(data)
    request.httpBody = jsonData
    let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
        let jsonDecoder = JSONDecoder()
        if let data = data,
        let preparationTime = try?
        jsonDecoder.decode(PreparationTime.self, from: data) {
            completion(preparationTime.prepTime)
        } else {
            completion(nil)
        }
    }
    task.resume()
}
