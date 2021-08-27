//
//  CartViewController.swift
//  Practice1
//
//  Created by Batuhan BARAN on 22.08.2021.
//

import UIKit
import RxSwift
import RxCocoa

class CartViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var totalLabel: UILabel!
    let disposeBag = DisposeBag()
    var viewModel: CartViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBindings()
    }
    
    private func setupBindings() {
        self.tableView.rowHeight = 154
        self.tableView.tableFooterView = UIView(frame: .zero)
        
        viewModel?.publishedCartItems.bind(to: tableView.rx.items(cellIdentifier: CartTableViewCell.identifier, cellType: CartTableViewCell.self)) { row, item, cell in
            cell.selectionStyle = .none
            cell.productName.text = item.name
            cell.productIcon.image = item.image
            cell.productAmount.text = String(item.amount.value)
            cell.productPrice.text = "$" + String(format: "%.2f", item.price)
            
        }.disposed(by: disposeBag)
        
        viewModel?.total.bind(onNext: { total in
            self.totalLabel.text = "Total Price " + "$" + String(format: "%.2f", total)
        })
        .disposed(by: disposeBag)
        
        tableView.rx.itemDeleted
            .subscribe { [unowned self] indexPath in
                self.viewModel?.removeItem(at: indexPath.row)
            }
            .disposed(by: disposeBag)

        
        viewModel?.fetchCartItems()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

}
