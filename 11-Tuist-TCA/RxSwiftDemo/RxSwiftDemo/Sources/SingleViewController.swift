//
//  SingleViewController.swift
//  RxSwiftDemo
//
//  Created by Jungman Bae on 4/22/25.
//

import UIKit
import RxSwift

enum MyError: Error {
  case operationFailed, noDataFound
}

class SingleViewController: UIViewController {

  let disposeBag = DisposeBag()

  override func viewDidLoad() {
    super.viewDidLoad()
    // Single 예제
    fetchDataFromServer()
      .subscribe(onSuccess: { data in
        print("Received data: \(data)")
      }, onFailure: { error in
        print("Error occurred: \(error)")
      }, onDisposed: {
        print("Disposed!") // 구독 해제 시 호출
      })
      .disposed(by: disposeBag)

    // Completable 예제 실행
    saveDataToServer()
      .subscribe(onCompleted: {
        print("Data saved successfully!")
      }, onError: { error in
        print("Error occurred while saving data: \(error)")
      }, onDisposed: {
        print("Disposed!") // 구독 해제 시 호출
      })
      .disposed(by: disposeBag)

    // Maybe 예제 실행
    findDataInCache()
      .subscribe(
        onSuccess: { data in print("Maybe 결과: \(data)") },
        onError: { error in print("Maybe 에러: \(error)") },
        onCompleted: { print("Maybe: 데이터 없이 완료됨") }
      )
      .disposed(by: disposeBag)
  }

  // Single 예제
  func fetchDataFromServer() -> Single<String> {
    return Single<String>.create { single in
      // Simulate network operation
      DispatchQueue.global().asyncAfter(deadline: .now() + 2) {
        let success = Bool.random()
        if success {
          single(.success("Data fetched successfully!"))
        } else {
          single(.failure(MyError.operationFailed))
        }
      }
      return Disposables.create()
    }
  }

  // --- Completable 예제 ---
  func saveDataToServer() -> Completable {
    return Completable.create { completable in
      print("Completable: 서버에 데이터 저장 중...")
      DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
        let success = Bool.random()
        if success {
          completable(.completed)
        } else {
          completable(.error(MyError.operationFailed))
        }
      }
      return Disposables.create()
    }
  }

  // --- Maybe 예제 ---
  func findDataInCache() -> Maybe<String> {
    return Maybe<String>.create { maybe in
      print("Maybe: 캐시에서 데이터 찾는 중...")
      DispatchQueue.global().asyncAfter(deadline: .now() + 0.5) {
        let cacheHit = Bool.random()
        let hasData = Bool.random()

        if cacheHit && hasData {
          maybe(.success("캐시 데이터 찾음!"))
        } else if cacheHit && !hasData {
          maybe(.completed) // 캐시는 찾았지만 데이터 없음
        } else {
          maybe(.error(MyError.noDataFound)) // 캐시에서 못 찾음 (에러 처리)
                                             // 또는 maybe(.completed) // 캐시 미스도 completed로 처리 가능
        }
      }
      return Disposables.create()
    }
  }



}
