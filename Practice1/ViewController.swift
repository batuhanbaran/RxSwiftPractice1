//
//  ViewController.swift
//  Practice1
//
//  Created by Batuhan BARAN on 19.08.2021.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var totalLabel: UILabel!
    private var viewModel: ProductListViewModel? = ProductListViewModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavBar()
        setupBindings()
    }
    
    private func setupBindings() {
        self.tableView.rowHeight = 154
        self.tableView.tableFooterView = UIView(frame: .zero)
        
        viewModel?.publishedProducts.bind(to: tableView.rx.items(cellIdentifier: CustomTableViewCell.identifier, cellType: CustomTableViewCell.self)) { row, item, cell in
            cell.selectionStyle = .none
            cell.productName.text = item.name
            cell.productIcon.image = item.image
            cell.productPrice.text = "Unit price is " + String(item.price).replacingOccurrences(of: ".", with: ",") + " ₺"
            cell.delegate = self
            cell.index = row
            item.amount.bind { val in
                cell.productAmount.text = String(val)
            }.disposed(by: self.disposeBag)
            
        }.disposed(by: disposeBag)
        
        viewModel?.totalAmount.bind(onNext: { total in
            if total != 0.0 {
                self.totalLabel.text = "Total price is \(String(format: "%.2f", total).replacingOccurrences(of: ".", with: ",")) ₺"
            }else {
                self.totalLabel.text = ""
            }
        })
        .disposed(by: disposeBag)
        
        viewModel?.fetchProducts()
        viewModel?.calculateTotalAmount()
    }
    
    private func configureNavBar() {
        self.title = "Cart"
        let barButton = UIBarButtonItem(image: UIImage(systemName: "trash"), style: .plain, target: self, action: #selector(barButtonAction))
        self.navigationItem.rightBarButtonItem = barButton
        viewModel?.trashButtonState.bind(to: barButton.rx.isEnabled)
            .disposed(by: disposeBag)
    }
    
    @objc func barButtonAction() {
        viewModel?.publishedProducts.onNext([])
        viewModel?.totalAmount.accept(0.0)
        viewModel?.trashButtonState.accept(false)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.viewModel?.fetchProducts()
            self.viewModel?.calculateTotalAmount()
            self.viewModel?.trashButtonState.accept(true)
        }
    }
}

extension ViewController: CustomTableViewCellOutputDelegate {
    func didTapIncreaseButton(amount: String, index: Int) {
        var value = 0
        value += 1
        if let viewModel = viewModel {
            viewModel.products[index].amount.accept(viewModel.products[index].amount.value + value)
            viewModel.total += Double(viewModel.products[index].price)
            viewModel.totalAmount.accept(viewModel.total)
        }
    }
    
    func didTapDecreaseButton(amount: String, index: Int) {
        var value = 0
        value += 1
        if let viewModel = viewModel {
            if viewModel.products[index].amount.value != 1 {
                viewModel.products[index].amount.accept(viewModel.products[index].amount.value - value)
                viewModel.total -= Double(viewModel.products[index].price)
                viewModel.totalAmount.accept(viewModel.total)
            }
        }
    }
}
