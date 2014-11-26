// Playground - noun: a place where people can play

import Cocoa

var APIBase = "http://evilplaninc.com/api/v1/"

enum CollectionEndpoint {
    case Friends(userId: Int)
    case Notes(userId: Int)
    
    func URL() -> NSURL {
        switch self {
        case .Notes(let userId):
            return NSURL(string: APIBase + "notes?user_id=\(userId)")!
            
        case .Friends(let userId):
            return NSURL(string: APIBase + "friends?user_id=\(userId)")!
        }
    }
}

let notesURL = CollectionEndpoint.Notes(userId: 5).URL()
let friendsURL = CollectionEndpoint.Friends(userId: 5).URL()
