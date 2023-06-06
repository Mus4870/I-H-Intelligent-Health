import Firebase

class AuthenticationManager: ObservableObject {
    static let shared = AuthenticationManager()
    @Published var usernames = [String]()
    @Published var currentUserUsername: String? // New property to store the current user's username
    
    private let databaseRef: DatabaseReference

    private init() {
        self.databaseRef = Database.database(url: "https://intelligent-health-c58f2-default-rtdb.europe-west1.firebasedatabase.app").reference()
    }
    
    func signUp(email: String, username: String, password: String, completion: @escaping (Result<String, Error>) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            if let error = error {
                completion(.failure(error))
            } else if let userId = result?.user.uid {
                self.storeUserData(userId: userId, email: email, username: username)
                self.currentUserUsername = username // Set the current user's username
                completion(.success(userId))
            } else {
                completion(.failure(NSError(domain: "AuthenticationManager", code: 0, userInfo: nil)))
            }
        }
    }
    
    private func storeUserData(userId: String, email: String, username: String) {
        let userRef = databaseRef.child("users").child(userId)
        userRef.child("email").setValue(email)
        userRef.child("username").setValue(username)
    }

    func signIn(email: String, password: String, completion: @escaping (Result<String, Error>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { [self] (result, error) in
            if let error = error {
                completion(.failure(error))
            } else if let userId = result?.user.uid {
                // Fetch the current user's username and set it
                fetchUsername(for: userId) { result in
                    switch result {
                    case .success(let username):
                        self.currentUserUsername = username
                        completion(.success(userId))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            } else {
                completion(.failure(NSError(domain: "AuthenticationManager", code: 0, userInfo: nil)))
            }
        }
    }

    func fetchUsername(for userId: String, completion: @escaping (Result<String, Error>) -> Void) {
        databaseRef.child("users").child(userId).child("username").observeSingleEvent(of: .value) { snapshot in
            if let username = snapshot.value as? String {
                completion(.success(username))
            } else {
                completion(.failure(NSError(domain: "AuthenticationManager", code: 0, userInfo: nil)))
            }
        } withCancel: { error in
            completion(.failure(error))
        }
    }

    func fetchUsernames(completion: @escaping (Result<[String], Error>) -> Void) {
        databaseRef.child("users").observeSingleEvent(of: .value) { snapshot in
            var usernames: [String] = []
            for child in snapshot.children {
                if let snapshot = child as? DataSnapshot,
                   let username = snapshot.childSnapshot(forPath: "username").value as? String {
                    usernames.append(username)
                }
            }
            completion(.success(usernames))
        } withCancel: { error in
            completion(.failure(error))
        }
    }

    func signOut() throws {
        try Auth.auth().signOut()
        currentUserUsername = nil // Clear the current user's username
    }
}
