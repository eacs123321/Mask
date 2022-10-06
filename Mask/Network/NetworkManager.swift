//
//  NetworkManager.swift
//  Mask
//
//  Created by 何安竺 on 2022/10/5.
//

import Foundation

class NetworkManager : NSObject{
    static let share = NetworkManager()
    
    //MARK: -口罩API資訊
    func api_get(finish: @escaping(PharmacyData?, Error?)-> Void){
        let url = URL(string: "https://raw.githubusercontent.com/kiang/pharmacies/master/json/points.json")!
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                finish(nil,error)
            } else if let response = response as? HTTPURLResponse,let data = data {
                print("Status code: \(response.statusCode)")
                // 創建 JSONDecoder 實例來解析我們的 json 檔
                let decoder = JSONDecoder()
                // decode 從 json 解碼，返回一個指定類型的值，這個類型必須符合 Decodable 協議
                if let infoData = try? decoder.decode(PharmacyData.self, from: data) {
                    finish(infoData,nil)
                }
            }
        }.resume()
    }
    
    //MARK: -解析每日一句
    func dailyData(finish: @escaping(String?, Error?)-> Void){
        if let url = URL(string: "https://tw.feature.appledaily.com/collection/dailyquote"){
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data {
                    do{
                        let contents = String(data: data, encoding: .utf8)
                        finish(contents,nil)
                    } catch {
                        print(error)
                    }
                } else {
                    print("error")
                }
            }.resume()
        }
    }
}
