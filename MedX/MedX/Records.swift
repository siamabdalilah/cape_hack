import Foundation

struct Record: Codable{
    let fileNumber: Int
    let fileName: fileName
}

struct fileName: Codable{
    let ACL: String
    let Address: String
    let Name: String
}

struct Records: Codable {
    let records: [Record]
}
