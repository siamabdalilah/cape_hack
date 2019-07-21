import Foundation

struct Record: Codable{
    let Name: String
    let Meta: String
}

struct Records: Codable {
    let records: [Record]
}
