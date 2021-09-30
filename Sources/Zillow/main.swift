import XMLCoder
import Foundation

enum CommandLineError: Error {
  case invalidInput
  case noAddress
  case unableToGenerateRequestURL
}
struct ZillowGenerator {
  static func queryURL(from input: String) throws -> URL {
    let addressComponents = input.split(separator: "-")
    let zip = addressComponents.last
    let addressWithoutZip = addressComponents.dropLast().joined(separator: "-")
    let zwsID = "MyZillowID"

    var components = URLComponents()
    components.scheme = "https"
    components.host = "www.zillow.com"
    components.path = "/webservice/GetDeepSearchResults.htm"
    components.queryItems = [
      .init(name: "address", value: addressWithoutZip),
      .init(name: "citystatezip", value: zip?.lowercased()),
      .init(name: "zws-id", value: zwsID)
    ]
    guard let url = components.url else {
      throw CommandLineError.unableToGenerateRequestURL
    }
    return url
  }
}

extension CommandLine {
  static var inputURL: URL? {
    guard let inputURL = CommandLine.arguments.dropFirst().first else {
      return nil
    }
    return URL(string: inputURL)
  }
}

func getPropertyInfo() throws {
  guard let originalURL = CommandLine.inputURL else {
    throw CommandLineError.invalidInput
  }
  guard let address = originalURL.pathComponents.dropFirst(2).first else {
    throw CommandLineError.noAddress
  }
  
  let url = try ZillowGenerator.queryURL(from: address)

  do {
    let decoder = XMLDecoder()
    decoder.shouldProcessNamespaces = true
    let data = try Data(contentsOf: url)
    let body = try decoder.decode(Body.self, from: data)
    print(body.response.results.result)
  } catch {
    print(error)
    return
  }
}

do {
  try getPropertyInfo()
} catch {
  print(error)
}
