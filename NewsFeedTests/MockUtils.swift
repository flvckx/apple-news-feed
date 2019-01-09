//
//  MockUtils.swift
//  NewsFeedTests
//
//  Created by Serhii Palash on 26/11/2018.
//  Copyright © 2018 Serhii Palash. All rights reserved.
//

import Foundation

open class FunctionCall<Arg, Value> {
    
    fileprivate(set) var callsCount: Int = 0
    fileprivate(set) var stubbedValue: Value?
    fileprivate(set) var stubbedBlock: ((Arg) -> Value)?
    fileprivate(set) var capturedArguments: [Arg] = []
    fileprivate var stubbedBlocks: [ReturnStub<Arg, Value>] = []
    
    public init() {}
    
    open var called: Bool {
        return callsCount > 0
    }
    
    open func returns(_ value: Value) {
        stubbedValue = value
    }
    
    open func performs(_ block: @escaping (Arg) -> Value) {
        stubbedBlock = block
    }
    
    open var capturedArgument: Arg? {
        return capturedArguments.last
    }
    
    open func on(_ filter: @escaping (Arg) -> Bool) -> ReturnContext<Arg, Value> {
        let stub = ReturnStub<Arg, Value>(filter: filter)
        stubbedBlocks += [stub]
        return ReturnContext(call: self, stub: stub)
    }
    
    func capture(_ argument: Arg) {
        callsCount += 1
        capturedArguments += [argument]
    }
}

public func stubCall<Arg, Value>(_ call: FunctionCall<Arg, Value>,
                                 argument: Arg, defaultValue: Value? = nil) -> Value {
    call.capture(argument)
    
    for stub in call.stubbedBlocks {
        if stub.filter(argument) {
            if case let .some(stubbedBlock) = stub.stubbedBlock {
                return stubbedBlock(argument)
            }
            
            if case let .some(stubbedValue) = stub.stubbedValue {
                return stubbedValue
            }
        }
    }
    
    if case let .some(stubbedBlock) = call.stubbedBlock {
        return stubbedBlock(argument)
    }
    
    if case let .some(stubbedValue) = call.stubbedValue {
        return stubbedValue
    }
    
    if case let .some(defaultValue) = defaultValue {
        return defaultValue
    }
    
    fatalError("Cannot get a value to return")
}

open class ReturnContext<Arg, Value> {
    
    let call: FunctionCall<Arg, Value>
    let stub: ReturnStub<Arg, Value>
    
    init(call: FunctionCall<Arg, Value>, stub: ReturnStub<Arg, Value>) {
        self.call = call
        self.stub = stub
    }
    
    @discardableResult
    open func returns(_ value: Value) -> FunctionCall<Arg, Value> {
        stub.stubbedValue = value
        return call
    }
    
    @discardableResult
    open func performs(_ block: @escaping ((Arg) -> Value)) -> FunctionCall<Arg, Value> {
        stub.stubbedBlock = block
        return call
    }
}

open class ReturnStub<Arg, Value> {
    
    let filter: (Arg) -> Bool
    fileprivate(set) var stubbedValue: Value?
    fileprivate(set) var stubbedBlock: ((Arg) -> Value)?
    
    init(filter: @escaping (Arg) -> Bool) {
        self.filter = filter
    }
}

open class FunctionNoArgsCall<Value>: FunctionCall<Void, Value> {
    
    public override init() {
        super.init()
    }
}

public func stubCall<Value>(_ call: FunctionNoArgsCall<Value>, defaultValue: Value? = nil) -> Value {
    return stubCall(call, argument: (), defaultValue: defaultValue)
}

open class FunctionVoidCall<Arg>: FunctionCall<Arg, Void> {
    
    public override init() {
        super.init()
    }
}

public func stubCall<Arg>(_ call: FunctionVoidCall<Arg>, argument: Arg) {
    stubCall(call, argument: argument, defaultValue: ())
}

open class FunctionVoidNoArgsCall: FunctionCall<Void, Void> {
    
    public override init() {
        super.init()
    }
}

public func stubCall(_ call: FunctionVoidNoArgsCall) {
    stubCall(call, argument: (), defaultValue: ())
}

