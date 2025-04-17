//
//  MenuFetcher.swift
//  Albertos
//
//  Created by Jungman Bae on 4/17/25.
//

import Foundation
import Combine

class MenuFetcher: MenuFetching {
  let networkFetching: NetworkFetching

  init(networkFetching: NetworkFetching = URLSession.shared) {
    self.networkFetching = networkFetching
  }

  func fetchMenu() -> AnyPublisher<[MenuItem], Error> {
    let url = URL(string:
                    "https://raw.githubusercontent.com/mokagio/tddinswift_fake_api/trunk/menu_response.json")!
    return networkFetching
      .load(URLRequest(url: url))
      .decode(type: [MenuItem].self, decoder: JSONDecoder())
      .eraseToAnyPublisher()
  }
}
