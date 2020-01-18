//
//  HorizontalAxisView.swift
//  NewGraph
//
//  Created by Matthew Delves on 18/1/20.
//  Copyright © 2020 Delightful Apps PTY LTD. All rights reserved.
//

import SwiftUI

struct HorizontalAxisView: View {
  let points: [GraphPoint]
  let callouts: Int = 10

  static let numberFormatter: NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    formatter.maximumFractionDigits = 2

    return formatter
  }()

  var body: some View {
    let sortedPoints = points.sorted { $0.x < $1.x }
    let minX: CGFloat = CGFloat(sortedPoints.first?.x ?? 0.0)
    let maxX: CGFloat = CGFloat(sortedPoints.last?.x ?? 0.0)

    let calloutValueDifference = (maxX - minX) / CGFloat(callouts)
    let calloutValues: [String] = (1...self.callouts).map { index in
      HorizontalAxisView.numberFormatter.string(from: NSNumber(value: Double(minX) + Double(calloutValueDifference) * Double(index))) ?? "..."
    }

    return GeometryReader { proxy -> AnyView in
      let spacing = proxy.size.width / CGFloat(self.callouts)

      return AnyView(VStack(spacing: 0) {
        HorizontalAxisPath(points: self.points, callouts: self.callouts)
          .stroke(Color.black, lineWidth: 2.0)
        ZStack {
          ForEach((1...self.callouts), id: \.self) { index in
            return Text(calloutValues[index - 1])
                .position(CGPoint(x: CGFloat(index) * spacing, y: 10))
          }
        }
      })
    }
  }
}

struct HorizontalAxisPath: Shape {
  let points: [GraphPoint]
  let callouts: Int

  func path(in rect: CGRect) -> Path {
    var path: Path = Path()

    path.move(to: CGPoint(x: 0, y: 0))
    path.addLine(to: CGPoint(x: rect.width, y: 0))

    let spacing = rect.width / CGFloat(callouts)

    (1...callouts).forEach { index in
      let xPoint = spacing * CGFloat(index)
      path.move(to: CGPoint(x: xPoint, y: 0))
      path.addLine(to: CGPoint(x: xPoint, y: 10))
    }

    return path
  }
}

struct HorizontalAxisView_Previews: PreviewProvider {
  static var previews: some View {
    let points: [GraphPoint] = (0..<100).map { xPoint in
      GraphPoint(
        x: Double(xPoint),
        y: Double.random(in: 0 ..< 100)
      )
    }

    return HorizontalAxisView(points: points)
      .frame(width: 800, height: 40)
  }
}
