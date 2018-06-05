//: Playground - noun: a place where people can play

import UIKit

//Swift extensions are the smart way to add functionality to existing types, and you're going to meet them time and time again – and hopefully write quite a few of
//your own too. They aren't all-encompassing, because they don't let you add properties to a class whereas a full subclass would, but they are easy to use and easy
//to share so I'm sure you'll use them frequently.

extension Int {
	mutating func plusOne() {
		self += 1
	}
}

extension Int {
	func squared() -> Int {
		return self * self
	}
}

extension BinaryInteger {
	func squared() -> Self {
		return self * self
	}
}


let i: Int = 8
print(i.squared())

var myInt = 10
myInt.plusOne()



