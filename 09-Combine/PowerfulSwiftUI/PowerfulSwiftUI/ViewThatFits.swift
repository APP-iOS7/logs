//
//  ViewThatFits.swift
//  PowerfulSwiftUI
//
//  Created by Jungman Bae on 4/3/25.
//

import SwiftUI

struct ViewThatFitsExample: View {
  var body: some View {
    VStack {
      Text("ViewThatFits Example")
        .font(.title)
        .padding()
      ViewThatFits(in: .horizontal) {
        // First option (highest priority) - full view
        HStack {
          Image(systemName: "star.fill")
            .foregroundColor(.yellow)
          Text("This is the complete text that will be displayed if there's enough space")
          Image(systemName: "star.fill")
            .foregroundColor(.yellow)
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 10).fill(Color.blue.opacity(0.2)))

        // Second option - more compact view
        HStack {
          Image(systemName: "star.fill")
            .foregroundColor(.yellow)
          Text("Shorter text")
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 10).fill(Color.green.opacity(0.2)))

        // Third option - minimal view
        Text("Minimal")
          .padding()
          .background(RoundedRectangle(cornerRadius: 10).fill(Color.red.opacity(0.2)))
      }
      Spacer()

      Text("Try changing the screen size to see the view adapt")
        .font(.caption)
        .padding()
    }
  }
}

#Preview {
  ViewThatFitsExample()
}
