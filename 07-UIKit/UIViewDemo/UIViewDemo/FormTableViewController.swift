//
//  FormTableViewController.swift
//  UIViewDemo
//
//  Created by Jungman Bae on 3/13/25.
//

import UIKit

class FormTableViewController: UITableViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    self.tableView.separatorColor = .black
  }

  // MARK: - Table view data source
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 4
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    // #warning Incomplete implementation, return the number of rows
    switch section {
    case 0:
      return 1
    case 3:
      return 3
    default:
      return 2
    }
  }


  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    // 테이블 뷰 셀을 재사용 하거나 새로 생성
    let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")

    // Configure the cell...
    var config = UIListContentConfiguration.subtitleCell()
    config.text = "Section: \(indexPath.section), Row: \(indexPath.row)"
    cell.contentConfiguration = config

    return cell
  }

  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    switch indexPath.section {
    case 0:
      return 100
    case 1:
      return 200
    default:
      return 50
    }

  }

}

#Preview {
  FormTableViewController(style: .insetGrouped)
}
