//
//  FizzBuzz.swift
//  HelloWorld
//
//  Created by Jungman Bae on 4/14/25.
//

func fizzBuzz(_ number: Int) -> String {
  if number % 3 == 0 && number % 5 == 0 {
    return "fizz-buzz"
  } else if number % 3 == 0 {
    return "fizz"
  } else if number % 5 == 0 {
    return "buzz"
  } else {
    return "\(number)"
  }
}
