//
//  MenuFetchingPlaceholder.swift
//  Albertos
//
//  Created by Jungman Bae on 4/16/25.
//

import Foundation
import Combine

class MenuFetchingPlaceholder: MenuFetching {
  func fetchMenu() -> AnyPublisher<[MenuItem], Error> {
    return Future {
      // 랜덤하게 실패와 성공을 발행
      let isSuccess = Bool.random()
      if isSuccess {
        $0(.success(menu))
      } else {
        $0(.failure(NSError(domain: "API 호출에 실패 했습니다.", code: -1, userInfo: nil)))
      }
    }
      .delay(for: 0.5, scheduler: RunLoop.main)
      .eraseToAnyPublisher()
  }
}
