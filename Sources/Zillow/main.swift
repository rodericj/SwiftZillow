import XMLCoder
import Foundation

enum CommandLineError: Error {
  case invalidInput
  case noAddress
  case unableToGenerateRequestURL
  case noZWID
}
struct ZillowGenerator {
  let zwsID: String
  init(zwsID: String) {
      self.zwsID = zwsID
  }

  func queryURL(from input: String) throws -> URL {
    let addressComponents = input.split(separator: "-")
    let zip = addressComponents.last
    let addressWithoutZip = addressComponents.dropLast().joined(separator: "-")

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

  static func zwid() throws -> String {
    guard let index = CommandLine.arguments.firstIndex(of: "-zwid") else {
      throw CommandLineError.noZWID
    }
    guard CommandLine.arguments.count > index else {
      throw CommandLineError.noZWID
    }
    return CommandLine.arguments[index + 1]
  }
}

func getPropertyInfo() throws {
  guard let originalURL = CommandLine.inputURL else {
    throw CommandLineError.invalidInput
  }
  guard let address = originalURL.pathComponents.dropFirst(2).first else {
    throw CommandLineError.noAddress
  }

  let zwid = try CommandLine.zwid()
  
  let generator = ZillowGenerator(zwsID: zwid)
  let url = try generator.queryURL(from: address)

  do {
    let decoder = XMLDecoder()
    decoder.shouldProcessNamespaces = true
    let data = try Data(contentsOf: url)
    let body = try decoder.decode(Body.self, from: data)
    if body.message.code == 0, let response = body.response {
      print(response.results.result)
    } else {
      print(body.message.text)
    }
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
