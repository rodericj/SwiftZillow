struct Address: Decodable {
    let street: String
    let zipcode: Int
    let city: String
    let state: String
    let latitude: Double
    let longitude: Double
}
