import Foundation

struct User: Equatable {
  let name: String
  let age: Int
}

func == (left: User, right: User) -> Bool {
  return left.name == right.name
    && left.age == right.age
}
