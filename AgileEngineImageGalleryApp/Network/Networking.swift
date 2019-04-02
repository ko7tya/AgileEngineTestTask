//
//  Networking.swift
//  Shupperz
//
//  Created by Kostya on 03.07.2018.
//

import Foundation
import Moya
import RxSwift
import Result

class OnlineProvider<Target> where Target: Moya.TargetType {
    
    fileprivate let provider: MoyaProvider<Target>
    init(endpointClosure: @escaping MoyaProvider<Target>.EndpointClosure = MoyaProvider<Target>.defaultEndpointMapping,
         requestClosure: @escaping MoyaProvider<Target>.RequestClosure = MoyaProvider<Target>.defaultRequestMapping,
         stubClosure: @escaping MoyaProvider<Target>.StubClosure = MoyaProvider.neverStub,
         manager: Manager = MoyaProvider<Target>.defaultAlamofireManager(),
         plugins: [PluginType] = [NetworkLoggerPlugin(verbose: true, cURL: true)],
         trackInflights: Bool = false) {
        
        self.provider = MoyaProvider(endpointClosure: endpointClosure,
                                     requestClosure: requestClosure,
                                     stubClosure: stubClosure,
                                     manager: manager,
                                     plugins: plugins,
                                     trackInflights: trackInflights)
    }
    
    func request(_ token: Target) -> Observable<Result<Data, APIError>> {
        return provider.rx
            .request(token)
            .asObservable()
            .filterSuccess()
    }
}

// swiftlint:disable type_name
protocol NetworkingType {
    associatedtype T: TargetType, APIType
    var provider: OnlineProvider<T> { get }
}

struct Networking: NetworkingType {
    typealias T = API
    let provider: OnlineProvider<API>
}

// swiftlint:enable type_name

// Static methods
extension NetworkingType {
    
    static func newNetworking() -> Networking {
        let provider = OnlineProvider(endpointClosure: endpointsClosure(),
                                      requestClosure: MoyaProvider<API>.defaultRequestMapping,
                                      stubClosure: MoyaProvider<API>.neverStub,
                                      manager: MoyaProvider<API>.defaultAlamofireManager(),
                                      plugins: [NetworkLoggerPlugin(verbose: true, cURL: true)],
                                      trackInflights: false)
        return Networking(provider: provider)
    }

    static func endpointsClosure<T>() -> (T) -> Endpoint where T: TargetType, T: APIType {
        return { target in
            let endpoint: Endpoint = Endpoint(url: target.baseURL.absoluteString + target.path,
                                              sampleResponseClosure: {.networkResponse(200, target.sampleData)},
                                              method: target.method,
                                              task: target.task,
                                              httpHeaderFields: target.headers)
            
            return endpoint
        }
    }
    
    // (Endpoint, NSURLRequest -> Void) -> Void
    static func endpointResolver() -> MoyaProvider<T>.RequestClosure {
        return { (endpoint, closure) in
            do {
                var request = try endpoint.urlRequest()
                request.httpShouldHandleCookies = false
                closure(.success(request))
            } catch let error {
                closure(.failure(MoyaError.underlying(error, nil)))
            }
        }
    }
}

extension ObservableType where E == Moya.Response {
    func filterSuccess() -> Observable<Result<Data, APIError>> {
        return map { (response) -> Result<Data, APIError> in
            
            if 200 ... 399 ~= response.statusCode {
                return .success(response.data)
            }
            
            if response.statusCode == 400 {
                return .failure(APIError.invalidAPICall(info: "Error"))
            }
            
            if response.statusCode == 401 {
                 return .failure(APIError.tokenError(info: "Token error"))
            }
            
            // Its an error and can't decode error details from server, push generic message
            let genericError = APIError.unknown(info: "Unknown error")
            return .failure(genericError)
        }
    }
}
