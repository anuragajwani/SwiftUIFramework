//
//  RatingsView.swift
//  MySwiftUIFramework
//
//  Created by Anurag Ajwani on 03/02/2021.
//

import SwiftUI

public struct RatingsView: View {
    
    public typealias UserRatingHandler = ((Int) -> ())
    var onDidRate: UserRatingHandler?
    
    @Binding var rating: CGFloat
    
    public init(onDidRate: UserRatingHandler? = nil, rating: Binding<CGFloat>) {
        self.onDidRate = onDidRate
        self._rating = rating
    }
    
    public var body: some View {
        HStack {
            StarView(fillAmount: self.getFillAmount(forIndex: 1)).onTapGesture(count: 1, perform: {
                self.didRate(1)
            })
            StarView(fillAmount: self.getFillAmount(forIndex: 2)).onTapGesture(count: 1, perform: {
                self.didRate(2)
            })
            StarView(fillAmount: self.getFillAmount(forIndex: 3)).onTapGesture(count: 1, perform: {
                self.didRate(3)
            })
            StarView(fillAmount: self.getFillAmount(forIndex: 4)).onTapGesture(count: 1, perform: {
                self.didRate(4)
            })
            StarView(fillAmount: self.getFillAmount(forIndex: 5)).onTapGesture(count: 1, perform: {
                self.didRate(5)
            })
        }
    }
    
    private func didRate(_ rate: Int) {
        guard let onDidRate = self.onDidRate else { return }
        self.rating = CGFloat(rate)
        onDidRate(rate)
    }
    
    private func getFillAmount(forIndex index: Int) -> CGFloat {
        let calc = self.rating - CGFloat(index)
        if calc >= 0.0 {
            return 1.0
        } else if calc <= 0.0 && calc > -1.0 {
            return self.rating - CGFloat(index - 1)
        } else {
            return 0.0
        }
    }
}

struct StarView: View {
    
    let fillAmount: CGFloat
    
    var body: some View {
            ZStack {
                Rectangle()
                    .fill(Color.gray)
                GeometryReader { geometry in
                    Rectangle()
                        .fill(Color.red)
                        .frame(width: geometry.size.width * fillAmount, height: geometry.size.height, alignment: .leading)
                }
            }
            .mask(Star())
    }
}

struct Star: Shape {
    
    let sides: Int = 5
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let startAngle = CGFloat(-1*(360/sides/4))
        let adjustment = startAngle + CGFloat(360/sides/2)
        let center = CGPoint(x: rect.width/2, y: rect.height/2)
        let innerPolygon = polygonPointArray(sides: self.sides,
                                             x: center.x,
                                             y: center.y,
                                             radius: rect.width/5,
                                             adjustment: startAngle)
        let outerPolygon = polygonPointArray(sides: self.sides,
                                             x: center.x,
                                             y: center.y,
                                             radius: rect.width/2,
                                             adjustment: adjustment)
        let points = zip(innerPolygon, outerPolygon)
        path.move(to: innerPolygon[0])
        points.forEach({ (innerPoint, outerPoint) in
            path.addLine(to: innerPoint)
            path.addLine(to: outerPoint)
        })
        path.closeSubpath()
        return path
    }
}

func degree2Radian(_ degree: CGFloat) -> CGFloat {
    return CGFloat.pi * degree/180
}

func polygonPointArray(sides: Int,
                       x: CGFloat,
                       y: CGFloat,
                       radius: CGFloat,
                       adjustment: CGFloat = 0) -> [CGPoint] {
    let angle = degree2Radian(360/CGFloat(sides))
    return Array(0...sides).map({ side -> CGPoint in
        let adjustedAngle: CGFloat = angle * CGFloat(side) + degree2Radian(adjustment)
        let xpo = x - radius * cos(adjustedAngle)
        let ypo = y - radius * sin(adjustedAngle)
        return CGPoint(x: xpo, y: ypo)
    })
}
