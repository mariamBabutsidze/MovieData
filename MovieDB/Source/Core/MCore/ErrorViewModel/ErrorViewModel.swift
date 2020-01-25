//
//  ErrorViewModel.swift
//  LibertyLoyalty-Development
//
//  Created by Giorgi Iashvili on 5/30/19.
//  Copyright © 2019 Giorgi Iashvili. All rights reserved.
//

import RxSwift
import RxCocoa

protocol ErrorViewModelProtocol: class {
    
    var onError: BehaviorRelay<Network.Status> { get }
    
}

extension ErrorViewModelProtocol {
    
    var standardFailBlock: Network.FailBlock
    {
        return { [weak self] status in
            self?.onError.accept(status)
        }
    }
    
}
