//
//  FilterViewModel.swift
//  MovieDB
//
//  Created by Maar Babu on 1/26/20.
//  Copyright © 2020 Maar Babu. All rights reserved.
//

import Foundation

protocol FilterViewModelType {
    
    var inputs: FilterViewModelInputs { get }
    var outputs: FilterViewModelOutputs { get }
    
}

protocol FilterViewModelInputs {
    
}

protocol FilterViewModelOutputs{
    func numberOfItems() -> Int
    func itemAt(index: IndexPath) -> String
}

class FilterViewModel {
    private var filters: [String] = []
    
    init()
    {
        filters.append(LocalString("FilterTopRated"))
        filters.append(LocalString("FilterPopular"))
        filters.append(LocalString("FilterFavourite"))
    }
    
}

// MARK: - FilterViewModelInputs
extension FilterViewModel: FilterViewModelInputs {
   
}

// MARK: - FilterViewModelOutputs
extension FilterViewModel: FilterViewModelOutputs {
    func numberOfItems() -> Int{
        return filters.count
    }
    
    func itemAt(index: IndexPath) -> String{
        return filters[index.row]
    }
    
}

// MARK: - FilterViewModelType
extension FilterViewModel: FilterViewModelType {
    
    var inputs: FilterViewModelInputs { get { return self } }
    var outputs: FilterViewModelOutputs { get { return self } }
    
}

