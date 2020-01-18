//
//  GraphView.swift
//  NewGraph
//
//  Created by Matthew Delves on 18/1/20.
//  Copyright © 2020 Delightful Apps PTY LTD. All rights reserved.
//

import SwiftUI

struct LineGraphView: View {
  let points: [GraphPoint] = (0..<10000).map { xPoint in
    GraphPoint(
      x: Double(xPoint),
      y: Double.random(in: 0 ..< 100)
    )
  }

  var body: some View {
    HStack(spacing: 0.0) {
      VStack(spacing: 0.0) {
        VerticalAxisView(points: points)
          .frame(width: 100, height: 200)
        Spacer()
      }
      ScrollView(.horizontal) {
        HStack(spacing: 0) {
          ForEach(points.chunked(into: 1000), id: \.self) { segment in
            VStack(spacing: 0) {
              LineGraphBody(points: segment)
                .frame(width: 2000, height: 200)
              HorizontalAxisView(points: segment)
                .padding([.bottom], 20)
            }
          }
        }
      }
    }
  }
}

struct LineGraphBody: View {
  let points: [GraphPoint]

  var body: some View {
    ZStack {
      LineGraphPath(points: points)
        .stroke(Color.pink, lineWidth: 0.5)
      LineGraphPath(points: points)
        .fill(Color.pink.opacity(0.3))
    }
  }
}

struct GraphView_Previews: PreviewProvider {
  static var previews: some View {
    LineGraphView()
      .frame(width: 1200, height: 300)
  }
}

extension Array {
  func chunked(into size: Int) -> [[Element]] {
    return stride(from: 0, to: count, by: size).map {
      Array(self[$0 ..< Swift.min($0 + size, count)])
    }
  }
}
