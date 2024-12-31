//
//  Struct.swift
//  
//
//  Created by Jungman Bae on 12/31/24.
//
import Foundation

/// 구조체를 사용하는 경우
///  - 간단한 값을 캡슐화 할때
///  - 복사본이 원본과 독립적이어야 할 때
///  - 상속이 불가능
public struct Point {
    public var x: Int
    var y: Int
    
    public init(x: Int, y: Int) {
        self.x = x
        self.y = y
    }
        
    func distanceFromOrigin() -> Double {
        return sqrt(Double(x * x + y * y))
    }
    
    mutating func moveBy(x deltaX: Int, y deltaY: Int) {
        self.x += deltaX
        self.y += deltaY
    }
}

struct Circle {
    var radius: Double
    
    // computed property
    var area: Double {
        return radius * radius * Double.pi
    }
    
    func areaFunction() -> Double {
        return radius * radius * Double.pi
    }
}

public func runStruct() {
    var point = Point(x: 1, y: 1)
    print(point.x)
    //point.y = 10
    print(point.y)

    print(point.distanceFromOrigin())

    point.moveBy(x: 2, y: 3)
    print(point.distanceFromOrigin())

    let circle = Circle(radius: 10)
    print(circle.area)
    print(circle.areaFunction())
    
    // 값의 복사는 독립적으로 이루어짐 ( 다른 공간에 할당 )
    let circleCopy = circle
    print(circleCopy.area)
}