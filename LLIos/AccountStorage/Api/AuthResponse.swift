/// Server response for authentication and validation requests.
public struct AuthResponse: Decodable, Sendable {
    public let token: String?
    public let record: UserDTO?

    public init(
        token: String?,
        record: UserDTO?
    ) {
        self.token = token
        self.record = record
    }

    public func convertToAccount() throws -> Account? {
        guard
            let id = record?.id,
            let token = token,
            let exp = try decodeJWTPayload(token).exp
        else {
            return nil
        }

        let account = Account(
            id: id,
            email: record?.email,
            name: record?.name,
            token: token,
            expiration: exp
        )

        return account
    }
}

/// User record information containing profile and account details.
public struct UserDTO: Decodable, Sendable {
    public let collectionId: String?
    public let collectionName: String?
    public let id: String?
    public let email: String?
    public let emailVisibility: Bool?
    public let verified: Bool?
    public let name: String?
    public let avatar: String?
    public let created: String?
    public let updated: String?

    public init(
        collectionId: String?,
        collectionName: String?,
        id: String?,
        email: String?,
        emailVisibility: Bool?,
        verified: Bool?,
        name: String?,
        avatar: String?,
        created: String?,
        updated: String?
    ) {
        self.collectionId = collectionId
        self.collectionName = collectionName
        self.id = id
        self.email = email
        self.emailVisibility = emailVisibility
        self.verified = verified
        self.name = name
        self.avatar = avatar
        self.created = created
        self.updated = updated
    }
}
