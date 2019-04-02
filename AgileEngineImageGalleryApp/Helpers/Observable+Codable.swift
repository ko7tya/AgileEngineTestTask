//
//  Observable+Codable.swift
//  Sample
//
//  Created by Kostyantin Ischenko on 1/24/19.
//  Copyright © 2019 Kostyantin Ischenko. All rights reserved.
//

import Foundation
import Moya
import RxSwift
import Result

extension Observable {
    
    typealias Dictionary = [String: AnyObject]
    typealias RequestResult = Result<Data, APIError>
    
    /// Get given JSONified data, pass back objects
    func mapTo<B: Codable>(object classType: B.Type) -> Observable<Result<B, APIError>> {
        return self.map { response in
            guard let result = response as? RequestResult else {
                return .failure(APIError.couldNotParseJSON(info: "Wrong convertation into data"))
            }
            switch result {
            case .success(let data):
                do {
                    let value = try JSONDecoder().decode(B.self, from: data)
                    return .success(value)
                } catch {
                    return .failure(APIError.couldNotParseJSON(info: "\(error)"))
                }
            case .failure(let error):
                return .failure(error)
            }
        }
    }
    
    /// Get given JSONified data, pass back objects as an array
    func mapTo<B: Codable>(arrayOf classType: B.Type) -> Observable<Result<[B], APIError>> {
        return self.map { response in
            guard let result = response as? RequestResult else {
                return .failure(APIError.couldNotParseJSON(info: "Wrong convertation into data"))
            }
            switch result {
            case .success(let data):
                do {
                    let values = try JSONDecoder().decode([B].self, from: data)
                    return .success(values)
                } catch {
                    return .failure(APIError.couldNotParseJSON(info: "\(error)"))
                }
            case .failure(let error):
                return .failure(error)
            }
        }
    }
    
    func mapToEmpty() -> Observable<Result<Void, APIError>> {
        return self.map { response in
            guard let result = response as? RequestResult else {
                return .failure(APIError.couldNotParseJSON(info: "Wrong convertation into data"))
            }
            switch result {
            case .success(_):
                return .success(())
            case .failure(let error):
                return .failure(error)
            }
        }
        
    }
}
