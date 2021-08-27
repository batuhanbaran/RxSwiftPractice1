//
//  CartTableViewCell.swift
//  Practice1
//
//  Created by Batuhan BARAN on 22.08.2021.
//

import UIKit

protocol CustomTableViewCellOutputDelegate: AnyObject {
    func didTapIncreaseButton(amount: String, index: Int)
    func didTapDecreaseButton(amount: String, index: Int)
}

class CartTableViewCell: UITableViewCell {

    static let identifier = "cartCell"
    
    @IBOutlet weak var productIcon: UIImageView!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productAmount: UILabel!
    
    weak var delegate: CustomTableViewCellOutputDelegate?
    lazy var index = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func decreaseTapped(_ sender: Any) {
    
    }
    
    @IBAction func increaseTapped(_ sender: Any) {
    
    }
    

}
