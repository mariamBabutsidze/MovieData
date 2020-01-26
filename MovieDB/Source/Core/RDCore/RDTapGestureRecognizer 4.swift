//
//  RDTapGestureRecognizer.swift
//
//  Created by Giorgi Iashvili on 23.12.15.
//  Copyright © 2015 Giorgi Iashvili. All rights reserved.
//

import UIKit

class RDTapGestureRecognizer : UITapGestureRecognizer {
    
    var callBack : ((_ sender: RDTapGestureRecognizer) -> Void)?
    
    convenience init(delegate: UIGestureRecognizerDelegate? = nil, callBack: @escaping ((_ sender: RDTapGestureRecognizer) -> Void))
    {
        self.init()
        
        self.delegate = delegate
        self.callBack = callBack
        
        self.addTarget(self, action: #selector(self.tapRecognized(sender:)))
    }
    
    // MARK: Delegates
    
    @objc func tapRecognized(sender: UITapGestureRecognizer)
    {
        self.callBack?(self)
    }
    
}
