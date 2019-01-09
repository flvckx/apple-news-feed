//
//  DatabaseServiceMock.swift
//  NewsFeedTests
//
//  Created by Serhii Palash on 26/11/2018.
//  Copyright © 2018 Serhii Palash. All rights reserved.
//

@testable import NewsFeed
import PromiseKit
import RealmSwift

class DatabaseServiceMock: DatabaseService {
    
    let updateCall = FunctionCall<Object, Promise<Object>>()
    func update<T>(object: T, _ block: @escaping (T) -> Void) -> Promise<T> where T : Object {
        return stubCall(updateCall, argument: (object)) as! Promise<T>
    }
    
    let loadCall = FunctionNoArgsCall<Promise<[Object]>>()
    func load<T>() -> Promise<[T]> where T : Object {
        return stubCall(loadCall) as! Promise<[T]>
    }
    
    let loadWithPredicateCall = FunctionCall<NSPredicate, Promise<[Object]>>()
    func load<T>(predicate: NSPredicate) -> Promise<[T]> where T : Object {
        return stubCall(loadWithPredicateCall, argument: predicate) as! Promise<[T]>
    }
    
    let loadFirstOccurrenceCall = FunctionCall<NSPredicate, Promise<Object>>()
    func loadFirstOccurrence<T>(predicate: NSPredicate) -> Promise<T> where T : Object {
        return stubCall(loadFirstOccurrenceCall, argument: predicate) as! Promise<T>
    }
    
    let loadWithPrimaryKeyCall = FunctionCall<PrimaryKey, Promise<Object>>()
    func load<T>(primaryKey: PrimaryKey) -> Promise<T> where T : Object {
        return stubCall(loadWithPrimaryKeyCall, argument: primaryKey) as! Promise<T>
    }
    
    let addObjectCall = FunctionCall<Object, Promise<Object>>()
    func add<T>(object: T) -> Promise<T> where T : Object {
        return stubCall(addObjectCall, argument: object) as! Promise<T>
    }
    
    let addObjectsCall = FunctionCall<[Object], Promise<[Object]>>()
    func add<T>(objects: [T]) -> Promise<[T]> where T : Object {
        return stubCall(addObjectsCall, argument: objects) as! Promise<[T]>
    }
    
    let deleteObjectCall = FunctionCall<Object, Promise<Void>>()
    func delete(object: Object) -> Promise<Void> {
        return stubCall(deleteObjectCall, argument: object)
    }
    
    let deleteObjectsCall = FunctionCall<[Object], Promise<Void>>()
    func delete(objects: [Object]) -> Promise<Void> {
        return stubCall(deleteObjectsCall, argument: objects)
    }
    
    let clearDatabaseCall = FunctionNoArgsCall<Promise<Void>>()
    func clearDatabase() -> Promise<Void> {
        return stubCall(clearDatabaseCall)
    }
}
