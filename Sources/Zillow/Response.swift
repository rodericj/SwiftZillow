
struct Body: Decodable {
  struct Message: Decodable {
    let text: String
    let code: Int
  }
  struct Response: Decodable {
    struct Result: Decodable {
      let result: Property
    }
    let results: Result
  }
  let message: Message
  let response: Response?
}
