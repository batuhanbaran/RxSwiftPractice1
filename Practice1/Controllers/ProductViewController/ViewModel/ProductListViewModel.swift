//
//  ProductListViewModel.swift
//  Practice1
//
//  Created by Batuhan BARAN on 20.08.2021.
//

import Foundation
import RxSwift
import RxCocoa

final class ProductListViewModel {
    
    var publishedProducts = PublishSubject<[Product]>()
    var totalAmount = BehaviorRelay<Double>(value: 0.0)
    var trashButtonState = BehaviorRelay<Bool>(value: true)
    var total = 0.0
    
    var products = [
        Product(image: UIImage(named: "cookie")!, name: "Chocolate Cookie", amount: BehaviorRelay<Int>.init(value: 1), price: 18.25),
        Product(image: UIImage(named: "water")!, name: "Water", amount: BehaviorRelay<Int>.init(value: 1), price: 4.99),
        Product(image: UIImage(named: "coffee-cup")!, name: "Ice-Latte", amount: BehaviorRelay<Int>.init(value: 1), price: 16.99),
        Product(image: UIImage(named: "coffee-cup")!, name: "Mocha", amount: BehaviorRelay<Int>.init(value: 1), price: 15.55),
        Product(image: UIImage(named: "cake")!, name: "Lemon Cheesecake", amount: BehaviorRelay<Int>.init(value: 1), price: 25.35),
        Product(image: UIImage(named: "coffee-cup")!, name: "Caramel Frappuccino", amount: BehaviorRelay<Int>.init(value: 1), price: 22.65),
        Product(image: UIImage(named: "cake")!, name: "Chocolate Cake", amount: BehaviorRelay<Int>.init(value: 1), price: 14.75),
    ]
    
    func fetchProducts() {
        publishedProducts.onNext(products)
    }
    
    func calculateTotalAmount() {
        total = 0.0
        for product in products {
            total += Double(product.price) * Double(product.amount.value)
            totalAmount.accept(total)
        }
    }
}
