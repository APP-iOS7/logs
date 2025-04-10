//
//  Schduler.swift
//  SchedulerDemo
//
//  Created by Jungman Bae on 4/10/25.
//
import Combine

public protocol Scheduler {
  /// 이 스케줄러의 시간 순간을 설명합니다.
  associatedtype SchedulerTimeType : Strideable where
  Self.SchedulerTimeType.Stride : SchedulerTimeIntervalConvertible

  /// 스케줄러가 받아들이는 옵션을 정의하는 타입입니다.
  ///
  /// 이 타입은 각 `Scheduler`에 의해 자유롭게 정의될 수 있습니다.
  /// 일반적으로 `Scheduler` 매개변수를 받는 연산은
  /// `SchedulerOptions`도 받습니다.
  associatedtype SchedulerOptions

  /// 이 스케줄러의 현재 시간 순간에 대한 정의입니다.
  var now: Self.SchedulerTimeType { get }

  /// 스케줄러가 허용하는 최소 허용 오차입니다.
  var minimumTolerance: Self.SchedulerTimeType.Stride { get }

  /// 다음 가능한 기회에 액션을 수행합니다.
  func schedule(options: Self.SchedulerOptions?,
                _ action: @escaping () -> Void)

  /// 지정된 날짜 이후의 어느 시점에 액션을 수행합니다.
  func schedule(after date: Self.SchedulerTimeType,
                tolerance: Self.SchedulerTimeType.Stride,
                options: Self.SchedulerOptions?,
                _ action: @escaping () -> Void)

  /// 지정된 날짜 이후의 어느 시점에, 지정된 빈도로,
  /// 가능한 경우 허용 오차를 고려하여 액션을 수행합니다.
  func schedule(after date: Self.SchedulerTimeType,
                interval: Self.SchedulerTimeType.Stride,
                tolerance: Self.SchedulerTimeType.Stride,
                options: Self.SchedulerOptions?,
                _ action: @escaping () -> Void) -> Cancellable
}
