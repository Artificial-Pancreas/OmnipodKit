import Foundation
import os.log

protocol MessageLogger: AnyObject {
    // Comms logging
    func didSend(_ message: Data)
    func didReceive(_ message: Data)
    func didError(_ message: String)
}
