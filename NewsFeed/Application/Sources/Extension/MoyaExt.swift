//
//  MoyaExt.swift
//  NewsFeed
//
//  Created by Serhii Palash on 11/11/2018.
//  Copyright © 2018 Serhii Palash. All rights reserved.
//

import Alamofire
import Moya
import PromiseKit
import RealmSwift

typealias PendingRequestPromise = (promise: Promise<Response>, cancellable: Cancellable?)

extension MoyaProvider {
    
    public func requestDecodable<T: Object & Decodable>(_ target: Target,
                                                        callbackQueue: DispatchQueue? = nil,
                                                        progress: ProgressBlock? = nil) -> Promise<T> {
        return request(target, callbackQueue: callbackQueue, progress: progress)
            .then { $0.decodeData() }
            .recover(decodeError)
    }
    
    public func request(_ target: Target,
                        callbackQueue: DispatchQueue? = nil,
                        progress: ProgressBlock? = nil) -> Promise<Response> {
        return requestCancellable(target, callbackQueue: callbackQueue, progress: progress).promise
    }
    
    func requestCancellable(_ target: Target,
                            callbackQueue: DispatchQueue?,
                            progress: ProgressBlock? = nil) -> PendingRequestPromise {
        guard NetworkReachabilityManager()?.isReachable ?? false else {
            let networkError = NetworkServiceError.noInternetConnection(
                error: "Request failed",
                message: "No network connection available"
            )
            return (.init(error: networkError), nil)
        }
        
        let pending = Promise<Response>.pending()
        let completion = makePromiseCompletion(fulfill: pending.resolver.fulfill, reject: pending.resolver.reject)
        let cancellable = request(target, callbackQueue: callbackQueue, progress: progress, completion: completion)
        
        return (pending.promise, cancellable)
    }
    
    private func makePromiseCompletion(fulfill: @escaping (Response) -> Void,
                                       reject: @escaping (Error) -> Void) -> Completion {
        return { result in
            switch result {
            case let .success(response):
                do {
                    fulfill(try response.filterSuccessfulStatusCodes())
                } catch {
                    reject(error)
                }
            case let .failure(error):
                reject(error)
            }
        }
    }
    
    private func decodeError<T: Decodable>(_ error: Error) -> Promise<T> {
        if let handledNetworkError = NetworkError(moyaError: error) {
            return .init(error: handledNetworkError)
        }
        return .init(error: error)
    }
}

extension Response {
    
    func decodeData<T: Decodable>(atKeyPath keyPath: String? = nil) -> Promise<T> {
        do {
            return .value(try map(T.self, atKeyPath: keyPath))
        } catch {
            return .init(error: NetworkServiceError.unwrapFailed(
                "\(error.localizedDescription) - \(String(describing: T.self))")
            )
        }
    }
    
    func decodeArrayData<T: Decodable>(atKeyPath keyPath: String? = nil) -> Promise<[T]> {
        do {
            return .value(try map([T].self, atKeyPath: keyPath))
        } catch {
            return .init(error: NetworkServiceError.unwrapFailed(
                "\(error.localizedDescription) - \(String(describing: T.self))")
            )
        }
    }
}

