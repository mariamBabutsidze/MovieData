//
//  MovieDetailsCollectionViewCell.swift
//  MovieDB
//
//  Created by Maar Babu on 1/26/20.
//  Copyright © 2020 Maar Babu. All rights reserved.
//

import UIKit

class MovieDetailsCollectionViewCell: UICollectionViewCell, Reusable {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func fill(withUrl url: URL?) {
        self.contentView.backgroundColor = .white
        self.imageView.image = nil
        self.activityIndicator.isHidden = false
        self.activityIndicator.startAnimating()
        self.imageView.sd_setImage(with: url) { (image, _, _, _) in
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
            if(image != nil)
            {
                self.contentView.backgroundColor = .black
            }
        }
    }

}
