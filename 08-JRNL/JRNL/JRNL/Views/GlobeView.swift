//
//  GlobeView.swift
//  JRNL
//
//  Created by Jungman Bae on 4/2/25.
//

import SwiftUI
import RealityKit

struct GlobeView: View {
  var body: some View {
    #if os(xrOS)
    VStack {
      Model3D(named: "globe") { model in
        model
          .resizable()
          .aspectRatio(contentMode: .fit)
      } placeholder: {
        ProgressView()
      }
    }
    #endif
  }
}
