//
//  ViewController.swift
//  TableViewDemo
//
//  Created by Jungman Bae on 3/19/25.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let tableView = UITableView(frame: view.bounds, style: .plain)
    
    // 테이블 뷰의 데이터 소스를 현재 뷰 컨트롤러로 설정
    tableView.dataSource = self
    tableView.delegate = self
    
    view.addSubview(tableView)
  }
  
  // MARK: - UITableViewDataSource
  // 섹션에 포함된 행의 개수를 반환하는 메서드
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 100
  }
  
  // 셀을 생성하고 구성하는 메서드
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    var cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
    
    if cell == nil {
      cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
    }
    cell?.textLabel?.text = "Row \(indexPath.row)"
    return cell!
  }
  
  // MARK: - UITableViewDelegate
  // 행이 선택되었을 때 호출
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    print("선택된 행: \(indexPath.row)")
  }
  
  // 행의 높이를 반환
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    if indexPath.row % 2 == 0 {
      return 100
    }
    return 60
  }
  
  // 행이 그려지기 직전에 호출
  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    cell.backgroundColor = indexPath.row % 2 == 0 ? .systemBackground : .secondarySystemBackground
  }
}

#Preview {
  UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()!
}
