//
//  TabBarCoordinatorFactory.swift
//  CoordinatorPattern
//
//  Created by Denis's MacBook on 1/5/26.
//

protocol TabBarFactoryProtocol {
    func makeHomeCoordinator(router: Routable) -> Coordinatable & HomeCoordinatorOutput
    
    func makeProfileCoordinator(router: Routable) -> Coordinatable & ProfileCoordinatorOutput
    
    func makeSettingsCoordinator(router: Routable) -> Coordinatable & SettingsCoordinatorOutput
}

final class TabBarCoordinatorFactory: TabBarFactoryProtocol {
    
    private let modulesFactory: ModulesFactory
    
    init(modulesFactory: ModulesFactory) {
        self.modulesFactory = modulesFactory
    }
    
    func makeHomeCoordinator(router: Routable) -> Coordinatable & HomeCoordinatorOutput {
        HomeCoordinator(router: router, factory: modulesFactory)
    }
    
    func makeProfileCoordinator(router: Routable) -> Coordinatable & ProfileCoordinatorOutput {
        ProfileCoordinator(router: router, factory: modulesFactory)
    }
    
    func makeSettingsCoordinator(router: Routable) -> Coordinatable & SettingsCoordinatorOutput {
        SettingsCoordinator(router: router, factory: modulesFactory)
    }
}
