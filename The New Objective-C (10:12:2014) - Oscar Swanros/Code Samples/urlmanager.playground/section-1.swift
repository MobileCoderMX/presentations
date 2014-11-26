// Playground - noun: a place where people can play

import Cocoa

var APIBase = "http://evilplaninc.com/api/admin/v1/"

enum AdminEndpoint: String {
    case Users = "users"
    case Notes = "notes"
    
    
    func URL() -> NSURL {
        switch self {
        case .Users:
            return NSURL(string: APIBase + self.rawValue)!
            
        case .Notes :
            return NSURL(string: APIBase + self.rawValue)!
        }
    }
}

var usersEndpoint = AdminEndpoint.Users.URL()
var notesEndpoint = AdminEndpoint.Notes.URL()