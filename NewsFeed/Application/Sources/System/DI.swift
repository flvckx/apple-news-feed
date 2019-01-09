//
//  DI.swift
//  NewsFeed
//
//  Created by Serhii Palash on 10/11/2018.
//  Copyright © 2018 Serhii Palash. All rights reserved.
//

import Moya
import Reachability
import RealmSwift
import Swinject

var container: Container = .init {
    $0.register(DatabaseService.self) { _ in
        var configuration = Realm.Configuration()
        configuration.deleteRealmIfMigrationNeeded = true
        return DatabaseServiceImpl(realm: try? Realm(configuration: configuration))
    }.inObjectScope(.container)
    $0.register(MoyaProvider<NewsNetworkService>.self) { _ in
        MoyaProvider<NewsNetworkService>()
    }.inObjectScope(.container)
    $0.register(NewsLoadingService.self) { _ in
        NewsLoadingServiceImpl()
    }.inObjectScope(.transient)
}

func resolve() -> DatabaseService { return resolve(DatabaseService.self) }
func resolve() -> MoyaProvider<NewsNetworkService> { return resolve(MoyaProvider<NewsNetworkService>.self) }
func resolve() -> NewsLoadingService { return resolve(NewsLoadingService.self) }

private func resolve<T>(_ type: T.Type) -> T {
    guard let resolved = container.resolve(type) else {
        fatalError("Couldn't resolve dependency of type \(type)")
    }
    return resolved
}
