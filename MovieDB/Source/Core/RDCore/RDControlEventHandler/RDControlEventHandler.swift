//
//  RDControlEventHandler.swift
//  RDControlEventHandler
//
//  Created by Giorgi Iashvili on 11.01.18.
//  Copyright © 2018 Giorgi Iashvili. All rights reserved.
//

import UIKit

public struct RDControlEventHandler<GenericType> {
    
    public var genericType: GenericType
    
    public init(_ genericType: GenericType)
    {
        self.genericType = genericType
    }
    
}

public protocol RDControlEventHandlerProtocol {
    
    associatedtype GenericType
    
    var ceh : RDControlEventHandler<GenericType> { get }
    
}

public extension RDControlEventHandlerProtocol {
    
    var ceh: RDControlEventHandler<Self> { get { return RDControlEventHandler(self) } }
    
}

extension NSObject: RDControlEventHandlerProtocol {
}

public extension RDControlEventHandler where GenericType: UIControl {
    
    func controlEvent(_ events: UIControl.Event, callback: (() -> Void)?)
    {
        let action = RDControlEventHandlerAction(callback: callback)
        RDControlEventHandlerAction.actions.append(action)
        self.genericType.addTarget(action, action: #selector(action.handleAction), for: events)
    }
    
}

class RDControlEventHandlerAction: Any {
    
    fileprivate static var actions: [Any] = []
    
    var callback: (() -> Void)?
    
    init(callback: (() -> Void)?)
    {
        self.callback = callback
    }
    
    @objc func handleAction()
    {
        self.callback?()
    }
    
}
