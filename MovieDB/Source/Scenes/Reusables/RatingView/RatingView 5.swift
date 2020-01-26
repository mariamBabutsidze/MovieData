//
//  RatingView.swift
//  Biliki-Development
//
//  Created by Mariam Babutsidze on 7/31/19.
//  Copyright © 2019 Giorgi Iashvili. All rights reserved.
//

import UIKit

class RatingView: UIView {
    
    @IBOutlet private var stars: [UIButton]!
    @IBOutlet private weak var ratingLabel: UILabel!
    @IBOutlet private weak var numberLabel: UILabel!
    private var starSelected : String = .empty
    private var star : String = .empty
    private var rate : Int = .zero
    @IBOutlet var starsTrailingSpace: NSLayoutConstraint!
    @IBOutlet private weak var starsStackView: UIStackView!
    
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        initialize()
    }
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        initialize()
    }
    
    private func initialize(){
        for i in 0..<stars.count {
            stars[i].imageView?.image = UIImage(named: "star")
        }
    }
    
    func setRating(rating: Double, numberOfRates: Int){
        starsStackView.distribution = UIStackView.Distribution.fillEqually
        starsTrailingSpace.isActive = !(numberOfRates == .zero)
        starSelected = "star_selected"
        star = "star"
        stars.forEach({ $0.isUserInteractionEnabled = false })
        numberLabel.text = "(\(numberOfRates))"
        ratingLabel.text = rating.toString
        let rate = rating.rounded().toInt
        for i in 0..<rate {
            let image = UIImage(named: starSelected)
            stars[i].setImage(image)
        }
        if rate < stars.count{
            for j in rate..<stars.count{
                let image = UIImage(named: star)
                stars[j].setImage(image)
            }
        }
        numberLabel.isHidden = numberOfRates == .zero
        ratingLabel.isHidden = numberOfRates == .zero
        self.rate = rate
    }
    
    func getRate() -> Double{
        return Double(rate)
    }
    
}
