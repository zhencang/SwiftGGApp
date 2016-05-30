//
//  SettingViewController.swift
//  GGQ
//
//  Created by 宋宋 on 16/4/19.
//  Copyright © 2016年 org.dianqk. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import PKHUD
import SwiftyJSON

private typealias SettingItem = (title: String, url: NSURL)

class SettingViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView!
    
    override func viewDidLoad() {
        
        
        title = "设置"
        
        let settingItems: [SettingItem] = [
//            SettingItem(title: "清理缓存", url: NSURL(string: "")),
            SettingItem(title: "反馈问题", url: GGConfig.Router.feedback()),
            SettingItem(title: "关于我们", url: GGConfig.Router.About.index())
        ]
        
        tableView.rx_modelSelected(SettingItem)
            .map { $0.url }
            .subscribeNext(RouterManager.sharedRouterManager().neverCareResultOpenURL)
            .addDisposableTo(rx_disposeBag)
        
        Observable.just(settingItems)
            .bindTo(tableView.rx_itemsWithCellFactory) { cv, i, v in
                let indexPath = NSIndexPath(forItem: i, inSection: 0)
                let cell = cv.dequeueReusableCellWithIdentifier(R.reuseIdentifier.settingTableViewCell, forIndexPath: indexPath)!
                cell.textLabel?.text = v.title
                return cell
            }
            .addDisposableTo(rx_disposeBag)
    }

    override func viewWillAppear(animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

}

extension SettingViewController: Routerable {
    var routingPattern: String {
        return GGConfig.Router.setting
    }
    
    var routingIdentifier: String? {
        return GGConfig.Router.setting
    }
    
    func get(url: NSURL, sender: JSON?) {
        guard let topRoutable = RouterManager.topRouterable() where topRoutable.routingIdentifier != routingIdentifier else { return }
        RouterManager.topViewController()?.showViewController(self, sender: nil)
    }
}