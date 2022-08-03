//
//  FKNetwork.swift
//  Teacher
//
//  Created by 周朋毅 on 2022/1/5.
//

import Foundation
import Alamofire
import Combine

public class PYNetwork {
    public static let network = PYNetwork()
    public var session: Session = Session()
    var tokens: Set<AnyCancellable> = []

    public init() {}
    func get<Model: Decodable>(_ path: URLConvertible,
                               parameters: Parameters = [:],
                               in model: Model.Type = Model.self,
                               completion: @escaping (PYResponse<Model>) -> Void) {
        request(path,
                method: .get,
                parameters: parameters,
                in: model,
                completion: completion)
    }
    func put<Model: Decodable>(_ path: URLConvertible,
                               parameters: Parameters = [:],
                                      in model: Model.Type = Model.self,
                               completion: @escaping (PYResponse<Model>) -> Void) {
        request(path,
                method: .put,
                parameters: parameters,
                in: model,
                completion: completion)
    }
    func delete<Model: Decodable>(_ path: URLConvertible,
                                  parameters: Parameters = [:],
                                  in model: Model.Type = Model.self,
                                  completion: @escaping (PYResponse<Model>) -> Void) {
        request(path,
                method: .delete,
                parameters: parameters,
                in: model,
                completion: completion)
    }

    func post<Model: Decodable>(_ path: URLConvertible,
                                parameters: Parameters = [:],
                                in model: Model.Type = Model.self,
                                completion: @escaping (PYResponse<Model>) -> Void) {
        request(path,
                method: .post,
                parameters: parameters,
                in: model,
                completion: completion)
    }
    
    private func request<Model: Decodable>(_ path: URLConvertible,
                                           method: HTTPMethod,
                                           parameters: Parameters,
                                           in model: Model.Type = Model.self,
                                           completion: @escaping (PYResponse<Model>) -> Void) {
        
        session.request(path,
                        method: method,
                        parameters: parameters,
                        encoding: (method == .post || method == .put) ? JSONEncoding.default : URLEncoding.default,
                        headers: nil)
        .publishDecodable(type: PYResponse<Model>.self, preprocessor: FKDataPreprocessor(), decoder: self.decoder)
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
            .map({ response -> PYResponse<Model> in
                switch response.result {
                case .success(let value):
                    switch value.code {
                    case 0:
                        return value
                    default:
                        return value
                    }
//                    if 0 == value.code {
//                        switch fk_error.code {
//                        case .authorizedFailed,
//                                .logInElsewhere,
//                                .authorizedError: //授权失败 在别处登录， 授权错误， 则提醒并清空个人信息
////                            if Account.current.user != nil {
////                                FKMessage.showAlert(fk_error.description)
////                                Account.current.user = nil
////                                Account.current.save()
////                            }
//                            break
//
//                        case .unauthorized: //未登录 弹出登录页面
////                            LoginRegistView.show()
//                            break
//                        default:
//                            FKMessage.showMSG(fk_error.description)
//                        }
//                    }
                case .failure(let error):
                    return PYResponse(data: nil, code: error.asAFError?.responseCode, msg: error.asAFError?.errorDescription)
                }
            })
            .sink(receiveValue: {
                completion($0)
            })
            .store(in: &tokens)
    }
    
    lazy var decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .millisecondsSince1970
        return decoder
    }()
}
protocol FKURLProcesser {
    func process(url: URLConvertible ) -> URLConvertible
}


struct FKDataPreprocessor: DataPreprocessor {
    public init() {}

    public func preprocess(_ data: Data) throws -> Data {
        return data
    }
}


struct FKNetworkDefalutHeaders {
    
}
