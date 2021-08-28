//
//  CartTableViewCell.swift
//  Practice1
//
//  Created by Batuhan BARAN on 22.08.2021.
//

import UIKit
import RxSwift
import RxCocoa

protocol CartTableViewCellOutputDelegate: AnyObject {
    func didTapIncreaseButton(amount: Int, index: Int)
    func didTapDecreaseButton(amount: Int, index: Int)
}

class CartTableViewCell: UITableViewCell {

    static let identifier = "cartCell"
    
    @IBOutlet weak var productIcon: UIImageView!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productAmount: UILabel!
    
    weak var delegate: CartTableViewCellOutputDelegate?
    var disposeBag = DisposeBag()
    lazy var index = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(with product: Product, at index: Int) {
        self.index = index
        self.productName.text = product.name
        self.productIcon.image = product.image
        product.amount.asObservable()
            .bind { newAmount in
                self.productAmount.text = String(newAmount)
                self.productPrice.text = "$" + String(format: "%.2f", product.price * Double(product.amount.value))
            }
            .disposed(by: disposeBag)
        self.productPrice.text = "$" + String(format: "%.2f", product.price * Double(product.amount.value))
    }
    
    
    @IBAction func increaseTapped(_ sender: Any) {
        guard let amountText = productAmount.text else {
            return
        }
        var newAmount =  Int(amountText) ?? 0
        newAmount += 1
        delegate?.didTapIncreaseButton(amount: newAmount, index: index)
    }
    
    @IBAction func decreaseTapped(_ sender: Any) {
        guard let amountText = productAmount.text else {
            return
        }
        var newAmount =  Int(amountText) ?? 0
        if newAmount != 1 {
            newAmount -= 1
        }
        delegate?.didTapDecreaseButton(amount: newAmount, index: index)
    }

}
