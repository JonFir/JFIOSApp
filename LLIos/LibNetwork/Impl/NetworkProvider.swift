import Alamofire

final class NetworkProvider: Sendable {

    let authorisedSession: Session
    let anonymousSession: Session

    init () {
        self.authorisedSession = Self.makeSession()
        self.anonymousSession = Self.makeSession()
    }

    static func makeSession() -> Session {
        Session()
    }

}
