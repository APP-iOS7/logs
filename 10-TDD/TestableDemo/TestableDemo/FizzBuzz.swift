//
//  FizzBuzz.swift
//  TestableDemo
//
//  Created by Jungman Bae on 4/14/25.
//

import Foundation

func fizzBuzz(_ n: Int) -> String {
    if n % 3 == 0 && n % 5 == 0 {
        return "FizzBuzz"
    } else if n % 3 == 0 {
        return "Fizz"
    } else if n % 5 == 0 {
        return "Buzz"
    } else {
        return "\(n)"
    }
}
