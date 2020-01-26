//
//  FilterTableViewCell.swift
//  MovieDB
//
//  Created by Maar Babu on 1/26/20.
//  Copyright © 2020 Maar Babu. All rights reserved.
//

import UIKit

protocol FilterTableViewCellDelegate: class{
    func buttonSelected(type: Filter)
}

class FilterTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var button: UIButton!
    
    weak var delegate: FilterTableViewCellDelegate?
    
    private var type: Filter?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        button.setTitleColor(UIColor.white, for: .normal)
        button.setTitleColor(UIColor.black, for: .selected)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func fill(with type: Filter, title: String){
        self.type = type
        button.setTitle(title, for: .normal)
    }
    
    @IBAction private func selectButton(_ sender: Any) {
        button.isSelected.toggle()
        button.backgroundColor = button.isSelected ? UIColor.systemYellow : UIColor.clear
        guard let type = type else{ return }
        delegate?.buttonSelected(type: type)
    }
}
