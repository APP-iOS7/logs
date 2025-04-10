//
//  SubscriptionDemoView.swift
//  SchedulerDemo
//
//  Created by Jungman Bae on 4/10/25.
//

import SwiftUI

struct SubscriptionDemoView: View {
  @StateObject var viewModel = SubscribeOnViewModel()

  var body: some View {
    VStack(spacing: 20) {
      Text("Times: \(viewModel.times)")
        .font(.headline)

      Button("Start Background Work") {
        viewModel.start()
      }
      .buttonStyle(.borderedProminent)

      Text("콘솔을 확인하여 스레드 실행 상태를 확인하세요")
        .font(.caption)
        .foregroundColor(.secondary)
    }
    .padding()
  }
}

#Preview {
  SubscriptionDemoView()
}
