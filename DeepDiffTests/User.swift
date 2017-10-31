import Foundation

struct User: Equatable, Hashable {
  let name: String
  let age: Int

  var hashValue: Int {
    return name.hashValue & age.hashValue
  }
}

func == (left: User, right: User) -> Bool {
  return left.name == right.name
    && left.age == right.age
}
