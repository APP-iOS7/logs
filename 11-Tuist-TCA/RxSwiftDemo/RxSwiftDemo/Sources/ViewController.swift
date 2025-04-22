//
//  ViewController.swift
//  RxSwiftDemo
//
//  Created by Jungman Bae on 4/22/25.
//

import UIKit
import RxSwift

class ViewController: UIViewController {

  private let disposeBag = DisposeBag()

  // 1. Observable 생성 예시
  let simpleObservable = Observable.just("Hello, RxSwift!") // 단일 값 방출
  let arrayObservable = Observable.from(["Apple", "Banana", "Orange"]) // 배열 요소 순차 방출
  let rangeObservable = Observable.range(start: 1, count: 3) // 1, 2, 3 순차 방출

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    title = "RxSwift Demo"

    // 2. Observer (구독) 예시
    print("--- simpleObservable 구독 ---")
    simpleObservable
      .subscribe(onNext: { value in
        print("Received value: \(value)")
      }, onError: { error in
        print("Error: \(error)")
      }, onCompleted: {
        print("Completed")
      }, onDisposed: {
        print("Disposed1!") // 구독 해제 시 호출
      })
      .disposed(by: disposeBag) // 생성된 구독을 DisposeBag에 추가하여 자동 관리

    print("\n--- arrayObservable 구독 ---")
    arrayObservable
      .subscribe(onNext: { fruit in
        print("Fruit: \(fruit)")
      }, onCompleted: {
        print("Fruit stream completed")
      }, onDisposed: {
        print("Disposed2!") // 구독 해제 시 호출
      })
      .disposed(by: disposeBag)

    print("\n--- rangeObservable 구독 ---")
    let subscription = rangeObservable // 구독 객체를 직접 변수에 저장
      .subscribe(onNext: { number in
        print("Number: \(number)")
      }, onDisposed: {
        print("Disposed3!") // 구독 해제 시 호출
      })

    // 3. 구독 직접 해제 (DisposeBag 사용 안 할 경우)
     subscription.dispose() // 필요 시점에 직접 해제

    // DisposeBag을 사용하면 아래 코드가 필요 없음
    // 해당 ViewController 등이 해제될 때 disposeBag이 해제되면서 자동으로 subscription도 해제됨
//    subscription.disposed(by: disposeBag) // disposeBag에 추가
  }
}
