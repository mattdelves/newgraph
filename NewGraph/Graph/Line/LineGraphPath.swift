//
//  LineGraphPath.swift
//  NewGraph
//
//  Created by Matthew Delves on 18/1/20.
//  Copyright © 2020 Delightful Apps PTY LTD. All rights reserved.
//

import SwiftUI

struct LineGraphPath: Shape {
  let points: [GraphPoint]

  func path(in rect: CGRect) -> Path {
    var path: Path = Path()
    let sortedPoints = points.sorted { $0.x < $1.x }
    let minX: CGFloat = CGFloat(sortedPoints.first?.x ?? 0.0)
    let maxX: CGFloat = CGFloat(sortedPoints.last?.x ?? 0.0)
    let maxY: CGFloat = CGFloat(points.reduce(0) { currentMax, point -> Double in
      return max(currentMax, point.y)
    })

    let widthRatio = rect.width / (maxX - minX)
    let heightRatio = rect.height / maxY

    let points: [CGPoint] = sortedPoints.map { point in
      let relativeX = CGFloat(point.x) - minX
      return CGPoint(
        x: relativeX * widthRatio,
        y: rect.height - (CGFloat(point.y) * heightRatio)
      )
    }

    let startPoint = CGPoint(x: 0, y: rect.height)
    path.move(to: startPoint)
    path.addLines(points)
    path.addLine(to: CGPoint(x: rect.width, y: rect.height))
    path.addLine(to: startPoint)

    return path
  }
}

#if DEBUG
struct LineGraphPath_Previews: PreviewProvider {

  static var previews: some View {
    let points: [GraphPoint] = (0..<100).map { xPoint in
      GraphPoint(
        x: Double(xPoint),
        y: Double.random(in: 0 ..< 100)
      )
    }

    return LineGraphPath(points: points)
      .fill(Color.red)
      .frame(width: 300, height: 100)
  }
}
#endif
