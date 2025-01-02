//
//  Protocol.swift
//  
//
//  Created by Jungman Bae on 1/2/25.
//
import Foundation

public func runProtocol() {
    print("runProtocol")
    let person = Person(name: "Jungman", age: 20)
    print(person.description)

    let car = Car()
    car.move(to: CGPoint(x: 10, y: 20))
    print(car.postion)

    let person3 = Person2(name: "Jungman")
    person3.printDescription()

    print("car".makeUpperCase())
}

protocol Describable {
    var description: String { get }
}

fileprivate struct Person: Describable {
    let name: String
    let age: Int
    
    var description: String {
        return "Person: \(name), \(age)"
    }
}

protocol Movable {
    func move(to point: CGPoint)
}

class Car: Movable {
    var postion: CGPoint = CGPoint(x: 0, y: 0)
    
    func move(to point: CGPoint) {
        postion = point
        print("Car moved to \(point)")
    }
}

protocol Named {
    init(name: String)
    
    func displayName() -> String
}

extension Named {
    func printDescription() {
        print(displayName())
    }
}

extension String {
    func makeUpperCase() -> String {
        return uppercased()
    }
}

class Person2: Named {
    func displayName() -> String {
        return "Person2: \(name)"
    }
    
    let name: String
    
    required init(name: String) {
        self.name = name
    }
}

fileprivate class Friend: Person2 {
    
    required init(name: String) {
        fatalError("init(name:) has not been implemented")
    }
    
    
    let age: Int
    
}

fileprivate struct Point: Named {
    func displayName() -> String {
        return "Point: \(name)"
    }
    
    let name: String
    
    init(name: String) {
        self.name = name
    }
}
