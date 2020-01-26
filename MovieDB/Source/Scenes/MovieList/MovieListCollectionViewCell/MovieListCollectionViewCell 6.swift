//
//  MovieListCollectionViewCell.swift
//  MovieDB
//
//  Created by Maar Babu on 1/25/20.
//  Copyright © 2020 Maar Babu. All rights reserved.
//

import UIKit

class MovieListCollectionViewCell: UICollectionViewCell, Reusable {

    @IBOutlet private weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func fill(with item: Movie){
        imageView.sd_setImage(with: item.iconUrl)
    }
}
