//
//  SubscribeOnViewModel.swift
//  SchedulerDemo
//
//  Created by Jungman Bae on 4/10/25.
//
import Foundation
import Combine

class SubscribeOnViewModel: ObservableObject {
  @Published var times = 0
  private var cancellables = Set<AnyCancellable>()

  func start() {
    print("[start:at beginning] isMainThread: \(Thread.isMainThread)")
    self.performWork()
      .handleEvents(receiveSubscription: { sub in
        print("[receiveSubscription] isMainThread: \(Thread.isMainThread)")
      }, receiveOutput: { value in
        print("[receiveOutput] isMainThread: \(Thread.isMainThread)")
      }, receiveCompletion: { completion in
        print("[receiveCompletion] isMainThread: \(Thread.isMainThread)")
      }, receiveCancel: {
        print("[receiveCancel] isMainThread: \(Thread.isMainThread)")
      }, receiveRequest: { demand in
        print("[receiveRequest] isMainThread: \(Thread.isMainThread)")
      })
      .map { value -> Bool in
        print("[map 1] isMainThread: \(Thread.isMainThread)")
        return value
      }
      // main thread 로 변경하면 Publisher가 메인 스레드에서 실행됨
      .subscribe(on: DispatchQueue.global(qos: .background))
      .receive(on: DispatchQueue.main)
      .map { value -> Int in
        print("[map 2] isMainThread: \(Thread.isMainThread)")
        return self.times + 1
      }
      .sink { value in
        print("[sink] isMainThread: \(Thread.isMainThread)")
        self.times = value
      }
      .store(in: &self.cancellables)
    print("[start:at end] isMainThread: \(Thread.isMainThread)")
  }


  func performWork() -> AnyPublisher<Bool, Never> {
    print("[performWork:start] isMainThread: \(Thread.isMainThread)")
    return Deferred {
      Future { promise in
        print("[performWork:Future:start] isMainThread: \(Thread.isMainThread)")
        sleep(5)  // 5초간 실행을 블록하여 장시간 작업 시뮬레이션
        print("[performWork:Future:finished] isMainThread: \(Thread.isMainThread)")
        promise(.success(true))
      }
    }
    .eraseToAnyPublisher()
  }
}
