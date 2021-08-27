//
//  ProductDetailViewController.swift
//  
//
//  Created by Batuhan BARAN on 22.08.2021.
//

import UIKit
import RxSwift
import RxCocoa

class ProductDetailViewController: UIViewController {
    
    @IBOutlet private weak var productIcon: UIImageView!
    @IBOutlet private weak var productPrice: UILabel!
    @IBOutlet private weak var productAmount: UILabel!
    
    var selectedProduct: Product?
    var viewModel: ProductListViewModel?
    var cartViewModel: CartViewModel? = CartViewModel()
    let disposeBag = DisposeBag()
    var value = 1
    var newPrice = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        setupBindings()
    }
    
    private func setupBindings() {
        selectedProduct?.amount.bind(onNext: { val in
            self.productAmount.text = String(val)
            guard let product = self.selectedProduct else { return }
            self.newPrice = Double(val) * product.price
            self.productPrice.text = "$" + String(format: "%.2f",  self.newPrice)
        })
        .disposed(by: disposeBag)
    }
    
    private func configureUI() {
        if let product = selectedProduct {
            self.productIcon.image = selectedProduct?.image
            self.productPrice.text = "$" + String(format: "%.2f", product.price)
        }
    }
    
    @IBAction func addToCart(_ sender: Any) {
        guard let product = selectedProduct else {
            return
        }
        cartViewModel?.addToCart(product: Product(image: product.image, name: product.name, amount: product.amount, price: newPrice))
        self.dismiss(animated: true)
    }
    
    @IBAction func increaseButtonAction(_ sender: Any) {
        value += 1
        selectedProduct?.amount.accept(value)
    }
    
    @IBAction func decreaseButtonAction(_ sender: Any) {
        if value != 1 {
            value -= 1
            selectedProduct?.amount.accept(value)
        }
    }
}
