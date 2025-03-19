//
//  TabBarController.swift
//  TabDemo
//
//  Created by Jungman Bae on 3/19/25.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.tintColor = .systemGreen
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

#Preview {
  UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()!
}
