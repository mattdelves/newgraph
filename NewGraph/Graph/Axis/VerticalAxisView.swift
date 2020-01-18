//
//  VerticalAxisView.swift
//  NewGraph
//
//  Created by Matthew Delves on 18/1/20.
//  Copyright © 2020 Delightful Apps PTY LTD. All rights reserved.
//

import SwiftUI

struct VerticalAxisView: View {
  let points: [GraphPoint]
  let callouts: Int = 5

  static let numberFormatter: NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    formatter.maximumFractionDigits = 2

    return formatter
  }()

  var body: some View {
    let maxY: CGFloat = points.reduce(CGFloat.zero) { currentMax, point in
      return max(currentMax, CGFloat(point.y))
    }
    let minY: CGFloat = points.reduce(CGFloat.greatestFiniteMagnitude) { currentMin, point in
      return min(currentMin, CGFloat(point.y))
    }

    let calloutValueDifference = (maxY - minY) / CGFloat(callouts)
    let numbers = (1...callouts).map { index -> String in
      VerticalAxisView.numberFormatter.string(from: NSNumber(value: Double(calloutValueDifference) * Double(index))) ?? "..."
    }

    return GeometryReader { proxy -> AnyView in
      let spacing = proxy.size.height / CGFloat(self.callouts)

      return AnyView(HStack(spacing: 4) {
        HStack(spacing: 0) {
          ZStack {
            ForEach((0..<self.callouts)) { index in
              Text(numbers[self.callouts - index - 1])
                .position(x: 10, y: spacing * CGFloat(index))
            }
          }
          .padding([.leading], 6)
          VerticalAxisPath(points: self.points, callouts: 5)
            .stroke(Color.black, lineWidth: 2.0)
        }
      })
    }
  }
}

struct VerticalAxisPath: Shape {
  let points: [GraphPoint]
  let callouts: Int

  func path(in rect: CGRect) -> Path {
    var path = Path()
    path.move(to: CGPoint(x: rect.width, y: 0))
    path.addLine(to: CGPoint(x: rect.width, y: rect.height))

    let spacing = rect.height / CGFloat(callouts)

    (0..<callouts).forEach { index in
      let yPoint = spacing * CGFloat(index)
      path.move(to: CGPoint(x: rect.width - 10, y: yPoint))
      path.addLine(to: CGPoint(x: rect.width, y: yPoint))
    }

    return path
  }
}

#if DEBUG
struct VerticalAxisView_Previews: PreviewProvider {
  static var previews: some View {
    let points: [GraphPoint] = (0..<100).map { xPoint in
      GraphPoint(
        x: Double(xPoint),
        y: Double.random(in: 0 ..< 100)
      )
    }

    return VerticalAxisView(points: points)
      .frame(width: 100, height: 500)
  }
}
#endif
