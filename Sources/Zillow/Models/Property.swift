import Foundation
struct Property: Decodable {
  let zpid: String
  let address: Address
  let zestimate: Zestimate
  let useCode: String
  let taxAssessmentYear: Int
  let taxAssessment: Double
  let yearBuilt: Int
  let lotSizeSqFt: Int
  let finishedSqFt: Int
  let bedrooms: Int
  let bathrooms: Double
  let lastSoldDate: String
  let lastSoldPrice: Int
  let links: Links
}

struct Links: Decodable {
  let homedetails: URL
  let graphsanddata: URL
  let mapthishome: URL
}

extension Property: CustomStringConvertible {
  // bedrooms, bathrooms
  var description: String {
    [
      String(bedrooms),
      String(bathrooms),
      useCode,
      address.street,
      address.city,
      String(address.zipcode),
      String(address.latitude),
      String(address.longitude),
      String(zestimate.amount),
      String(finishedSqFt),
      String(lotSizeSqFt),
      lastSoldDate,
      String(yearBuilt),
      String(lastSoldPrice),
      links.homedetails.absoluteString,
      links.graphsanddata.absoluteString,
      links.mapthishome.absoluteString,
    ]
      .joined(separator: ",")
  }
}
