//
//  APIServices.swift
//  example-neversitup2
//
//  Created by Sakolrat on 10/28/22.
//

import Foundation

class APIServices: NSObject {
    static let MAINURL = "https://api.coindesk.com"
    
    static func request<T: Decodable>(
        method: String,
        parameter: Any?,
        path: String,
        type: T.Type,
        onSuccess: @escaping (_ success: Bool, _ result: T?, _ errors: String?,_ statusCode: Int?) -> ()) {
        let urlString = String(format: "%@%@", MAINURL,path)
        
        guard let url = URL(string: urlString) else {
            return
        }
        var request = URLRequest(url: url)
        
        request.httpMethod = method
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if parameter != nil {
            guard let httpBody = try? JSONSerialization.data(withJSONObject: parameter!, options: []) else { return }
            request.httpBody = httpBody
        }
            let task = URLSession.shared.dataTask(with: request) {data, response, error in
                DispatchQueue.main.async {
                    guard let data = data,
                          let response = response as? HTTPURLResponse,
                          error == nil else {
                        let httpResponse = response as? HTTPURLResponse
                        onSuccess(false, nil,"Unexpected error: \(String(describing: error)).", httpResponse?.statusCode)
                        return
                    }
                    
                    if let resString = String(data: data, encoding: .utf8) {
                        let decoder = JSONDecoder()
                        let jsonData : Data = Data(resString.data(using: .utf8) ?? Data())
                        do {
                            let data = try decoder.decode(T.self, from: jsonData)
                            onSuccess(true,data, nil, response.statusCode)
                        }catch {
                            onSuccess(false, nil, "Unexpected error: \(error).", response.statusCode)
                        }
                    }
                }
            }
            task.resume()
    }
    
    
}
