//
//  PYNetwork.swift
//  Teacher
//
//  Created by 周朋毅 on 2022/1/5.
//

import Foundation
import Alamofire
import Combine
import SwiftUI
import HandyJSON

public class PYNetwork {
    public static let network = PYNetwork()
    public var session: Session = Session()
    var tokens: Set<AnyCancellable> = []

    public init() {}
    func get<Model: HandyJSON>(_ path: String,
                               parameters: Parameters = [:],
                               headers: HTTPHeaders? = nil,
                               in model: Model.Type = Model.self,
                               completion: @escaping (PYResponse<Model>) -> Void) {
        request(path,
                method: .get,
                parameters: parameters,
                headers: nil,
                in: model,
                completion: completion)
    }
    func put<Model: HandyJSON>(_ path: String,
                               parameters: Parameters = [:],
                               headers: HTTPHeaders? = nil,
                               in model: Model.Type = Model.self,
                               completion: @escaping (PYResponse<Model>) -> Void) {
        request(path,
                method: .put,
                parameters: parameters,
                headers: nil,
                in: model,
                completion: completion)
    }
    func delete<Model: HandyJSON>(_ path: String,
                                  parameters: Parameters = [:],
                                  headers: HTTPHeaders? = nil,
                                  in model: Model.Type = Model.self,
                                  completion: @escaping (PYResponse<Model>) -> Void) {
        request(path,
                method: .delete,
                parameters: parameters,
                headers: nil,
                in: model,
                completion: completion)
    }

    func post<Model: HandyJSON>(_ path: String,
                                parameters: Parameters = [:],
                                headers: HTTPHeaders? = nil,
                                in model: Model.Type = Model.self,
                                completion: @escaping (PYResponse<Model>) -> Void) {
        request(path,
                method: .post,
                parameters: parameters,
                headers: headers,
                in: model,
                completion: completion)
    }
    
    private func request<Model: HandyJSON>(_ path: String,
                                           method: HTTPMethod,
                                           parameters: Parameters,
                                           headers: HTTPHeaders? = nil,
                                           in model: Model.Type = Model.self,
                                           completion: @escaping (PYResponse<Model>) -> Void) {

        session.request(path,
                        method: method,
                        parameters: parameters,
                        encoding: (method == .post || method == .put) ? JSONEncoding.default : URLEncoding.default,
                        headers: headers)
        .publishData()
        .handleEvents(receiveOutput: { res in
            print("************************")
            if let httpMethod = res.request?.httpMethod {
                print(httpMethod)
            }
            if let url = res.request?.url {
                print(url)
            }
            do {
                if let bodyData = res.request?.httpBody {
                    let object = try JSONSerialization.jsonObject(with: bodyData)
                    let data = try JSONSerialization.data(withJSONObject: object, options: .prettyPrinted)
                    if let jsonString = String(data: data, encoding: .utf8) {
                        print(jsonString)
                    }

                }

            } catch  {
                print(error)
            }
            if let data = res.data {
                do {
                    let object = try JSONSerialization.jsonObject(with: data)
                    let data = try JSONSerialization.data(withJSONObject: object, options: .prettyPrinted)
                    if let jsonString = String(data: data, encoding: .utf8) {
                        print("response:")
                        print(jsonString.replacingOccurrences(of: "\\", with: ""))
                    }
                } catch  {
                    print(error)
                }

            }
            if let error = res.error {
                print("error:")
                print(error)
            }
            print("************************")
        })
        .map({ response -> PYResponse<Model>  in
            switch response.result {
            case .failure(let error):
                return PYResponse(data: nil, code: error.responseCode, msg: error.localizedDescription)
            case .success(let data):
                if let jsonString = String(data: data, encoding: .utf8),
                   let model = PYResponse<Model>.deserialize(from: jsonString) {
                    return model
                }
                return PYResponse(data: nil, code: -1, msg: "deserialize failed")
            }
        })
        .sink(receiveValue: {
            completion($0)
        })
        .store(in: &tokens)
    }
    
}
