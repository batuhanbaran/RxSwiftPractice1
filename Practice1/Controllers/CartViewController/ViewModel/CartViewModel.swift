//
//  CartViewModel.swift
//  
//
//  Created by Batuhan BARAN on 22.08.2021.
//

import Foundation
import RxSwift
import RxCocoa

final class CartViewModel {
    
    var publishedCartItems = PublishSubject<[Product]>()
    var products: [Product] = []
    var totalPrice = 0.0
    var total = BehaviorRelay<Double>(value: 0.0)
    
    func addToCart(product: Product) {
        products.append(product)
        totalPrice += product.price
        publishedCartItems.onNext(products)
        total.accept(totalPrice)
    }
    
    func fetchCartItems() {
        publishedCartItems.onNext(products)
    }
    
    func removeItem(at index: Int) {
        totalPrice -= self.products[index].price
        products.remove(at: index)
        total.accept(totalPrice)
        publishedCartItems.onNext(products)
    }
}
