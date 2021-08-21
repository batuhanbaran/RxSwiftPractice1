//
//  CustomTableViewCell.swift
//  Practice1
//
//  Created by Batuhan BARAN on 20.08.2021.
//

import UIKit
import RxSwift

protocol CustomTableViewCellOutputDelegate: AnyObject {
    func didTapIncreaseButton(amount: String, index: Int)
    func didTapDecreaseButton(amount: String, index: Int)
}

class CustomTableViewCell: UITableViewCell {
    
    static let identifier = "customCell"
    
    @IBOutlet weak var productIcon: UIImageView!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productAmount: UILabel!

    weak var delegate: CustomTableViewCellOutputDelegate?
    var disposeBag = DisposeBag()
    lazy var index = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    @IBAction func increaseTapped(_ sender: Any) {
        delegate?.didTapIncreaseButton(amount: productAmount.text ?? "", index: index)
    }
    
    @IBAction func decreaseTapped(_ sender: Any) {
        delegate?.didTapDecreaseButton(amount: productAmount.text ?? "", index: index)
    }
}
