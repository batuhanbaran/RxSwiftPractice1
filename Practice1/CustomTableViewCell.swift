//
//  CustomTableViewCell.swift
//  Practice1
//
//  Created by Batuhan BARAN on 20.08.2021.
//

import UIKit
import RxSwift

class CustomTableViewCell: UITableViewCell {
    
    static let identifier = "customCell"
    
    @IBOutlet weak var productIcon: UIImageView!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var productName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
}
