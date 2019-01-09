//
//  DatabaseService.swift
//  NewsFeed
//
//  Created by Serhii Palash on 11/11/2018.
//  Copyright © 2018 Serhii Palash. All rights reserved.
//

import PromiseKit
import RealmSwift

protocol PrimaryKey { }
extension Int: PrimaryKey { }
extension String: PrimaryKey { }

protocol DatabaseService: Service {
    
    func update<T: Object>(object: T, _ block: @escaping (T) -> Void) -> Promise<T>
    func load<T: Object>() -> Promise<[T]>
    func load<T: Object>(predicate: NSPredicate) -> Promise<[T]>
    func loadFirstOccurrence<T: Object>(predicate: NSPredicate) -> Promise<T>
    func load<T: Object>(primaryKey: PrimaryKey) -> Promise<T>
    func add<T: Object>(object: T) -> Promise<T>
    func add<T: Object>(objects: [T]) -> Promise<[T]>
    func delete(object: Object) -> Promise<Void>
    func delete(objects: [Object]) -> Promise<Void>
    
    func clearDatabase() -> Promise<Void>
}

enum RealmError: Error, LocalizedError {
    case realmCannotBeLoaded
    case dataCannotBeLoaded
    
    var errorDescription: String? {
        return "Failed to load data."
    }
}

class DatabaseServiceImpl: DatabaseService {
    
    fileprivate var realm: Realm?
    
    init(realm: Realm?) {
        self.realm = realm
    }
    
    // MARK: General functions
    
    func update<T: Object>(object: T, _ block: @escaping (T) -> Void) -> Promise<T> {
        return Promise { update(object: object, block, completion: $0.resolve) }
    }
    
    func update<T: Object>(object: T, _ block: @escaping (T) -> Void, completion: @escaping (T?, Error?) -> Void) {
        do {
            try execute {
                block(object)
                completion(object, nil)
            }
        } catch {
            completion(nil, error)
        }
    }
    
    func load<T: Object>() -> Promise<[T]> {
        return Promise { resolver in
            guard let objects = realm?.objects(T.self) else {
                return resolver.reject(RealmError.dataCannotBeLoaded)
            }
            resolver.fulfill(Array(objects))
        }
    }
    
    func load<T: Object>(primaryKey: PrimaryKey) -> Promise<T> {
        return Promise { resolver in
            guard let object = realm?.object(ofType: T.self, forPrimaryKey: primaryKey) else {
                return resolver.reject(RealmError.dataCannotBeLoaded)
            }
            resolver.fulfill(object)
        }
    }
    
    func load<T: Object>(predicate: NSPredicate) -> Promise<[T]> {
        return Promise { resolver in
            guard let objects = realm?.objects(T.self).filter(predicate) else {
                return resolver.reject(RealmError.dataCannotBeLoaded)
            }
            resolver.fulfill(Array(objects))
        }
    }
    
    func loadFirstOccurrence<T: Object>(predicate: NSPredicate) -> Promise<T> {
        let promise: Promise<[T]> = load(predicate: predicate)
        
        return promise.compactMap { $0.first }
    }
    
    private func add<T: Object>(object: T, completion: (T?, Error?) -> Void) {
        do {
            try execute {
                realm?.add(object, update: true)
                completion(object, nil)
            }
        } catch {
            completion(nil, error)
        }
    }
    
    func add<T: Object>(object: T) -> Promise<T> {
        return Promise(resolver: { resolver in
            add(object: object, completion: resolver.resolve)
        })
    }
    
    private func add<T: Object>(objects: [T], completion: (([T]?, Error?) -> Void)) {
        do {
            try execute {
                realm?.add(objects, update: true)
                completion(objects, nil)
            }
        } catch {
            completion(nil, error)
        }
    }
    
    func add<T: Object>(objects: [T]) -> Promise<[T]> {
        return Promise { add(objects: objects, completion: $0.resolve) }
    }
    
    private func delete(object: Object, completion: ((Void?, Error?) -> Void)) {
        do {
            try execute {
                realm?.delete(object)
                completion((), nil)
            }
        } catch {
            completion(nil, error)
        }
    }
    
    func delete(object: Object) -> Promise<Void> {
        return Promise { delete(object: object, completion: $0.resolve) }
    }
    
    private func delete(objects: [Object], completion: ((Void?, Error?) -> Void)) {
        do {
            try execute {
                realm?.delete(objects)
                completion((), nil)
            }
        } catch {
            completion(nil, error)
        }
    }
    
    func delete(objects: [Object]) -> Promise<Void> {
        return Promise { delete(objects: objects, completion: $0.resolve) }
    }
    
    func clearDatabase() -> Promise<Void> {
        return Promise { clearDatabase(completion: $0.resolve) }
    }
    
    private func clearDatabase(completion: ((Void?, Error?) -> Void)) {
        do {
            try execute {
                realm?.deleteAll()
                completion((), nil)
            }
        } catch {
            completion(nil, error)
        }
    }
    
    private func execute(job: () -> Void) throws {
        guard let realm = realm else {
            throw RealmError.realmCannotBeLoaded
        }
        if realm.isInWriteTransaction {
            job()
        } else {
            try realm.write(job)
        }
    }
}
