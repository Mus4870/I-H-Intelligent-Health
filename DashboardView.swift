import SwiftUI

struct DashboardView: View {
    @StateObject var networkManager = NetworkManager()
    @ObservedObject var authManager = AuthenticationManager.shared
    @State private var userProfileImage: Image? = Image("userProfileImage")
    @State private var calories = 2000 // Defualt Calorie total
    @State private var isShowingSearchSheet = false
    @State private var searchText = ""
    @State private var progress: CGFloat = 0.0
    @State private var totalCalories = 0 // variable to track total calories
    @State private var isLoggedIn = true // state variable to track login state(true by defualt)

    var body: some View {
        NavigationView {
            if isLoggedIn {
                ScrollView {
                    ZStack {
                        Color.mint
                            .ignoresSafeArea()
                        VStack {
                            Spacer()

                            if let profileImage = userProfileImage {
                                profileImage
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 400, height: 300)
                            } else {
                                Image(systemName: "person.circle")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 600, height: 400)
                                    .foregroundColor(.gray)
                            }
                            Text(authManager.currentUserUsername ?? "")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .padding(.top, 6)

                            Button(action: {
                                calories = 2000
                            }) {
                                Text("2000 Kcal (Default)")
                                    .foregroundColor(.white)
                                    .frame(width: 1000, height: 40)
                                    .background(Color.green)
                                    .cornerRadius(8)
                            }

                            Button(action: {
                                calories = 2500
                            }) {
                                Text("2500 Kcal")
                                    .foregroundColor(.white)
                                    .frame(width: 1000, height: 40)
                                    .background(Color.green)
                                    .cornerRadius(8)
                            }

                            Button(action: {
                                calories = 1500
                            }) {
                                Text("1500 Kcal")
                                    .foregroundColor(.white)
                                    .frame(width: 1000, height: 40)
                                    .background(Color.green)
                                    .cornerRadius(8)
                            }

                            Text("Progress Bar")
                                .font(.title2)
                                .fontWeight(.bold)
                                .padding(.top, 6)

                            ProgressView(value: progress)
                                .padding(.top, 1)

                            HStack {
                                Text("\(totalCalories)/\(calories)Kcal") // Updated placeholder value
                                    .font(.largeTitle)
                                    .fontWeight(.bold)
                                    .padding()

                                Button(action: {
                                    totalCalories = 0 // Reset total calories to 0
                                }) {
                                    Text("Reset")
                                        .foregroundColor(.white)
                                        .frame(width: 80, height: 40)
                                        .background(Color.blue)
                                        .cornerRadius(8)
                                }
                            }

                            VStack {
                                Text("Leader-Board")
                                    .font(.title)
                                ForEach(authManager.usernames, id: \.self) { username in
                                    if let currentUserUsername = authManager.currentUserUsername, username != currentUserUsername {
                                        Text(username)
                                            .padding(.vertical, 2)
                                    }
                                }
                            }
                        }
                        .padding()
                        .onChange(of: calories) { newValue in
                            updateProgress()
                        }

                        VStack {
                            Spacer()
                            HStack {
                                Spacer()
                                Image(systemName: "magnifyingglass")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 30, height: 30)
                                    .padding(.bottom, 16)
                                    .padding(.trailing, 16)
                                    .onTapGesture {
                                        isShowingSearchSheet = true
                                    }
                            }
                        }
                    }
                }
                .navigationBarHidden(false)
                .sheet(isPresented: $isShowingSearchSheet) {
                    VStack {
                        Text("Search for your food here")
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding(.top, 32)

                        TextField("Search", text: $searchText)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal)
                            .padding(.bottom, 32)

                        Button(action: {
                            networkManager.getFoodData(for: searchText)
                        }) {
                            Text("Search")
                                .foregroundColor(.white)
                                .frame(width: 100, height: 50)
                                .background(Color.blue)
                                .cornerRadius(8)
                        }
                        .padding(.bottom, 32)

                        if let foodSearchResult = networkManager.foodSearchResult {
                            ScrollView {
                                VStack {
                                    ForEach(foodSearchResult.hints, id: \.food.label) { hint in
                                        HStack {
                                            Text("\(hint.food.label)")
                                                .font(.title)
                                                .padding(.bottom, 32)
                                            Spacer()
                                            if let calories = hint.food.nutrients["ENERC_KCAL"] {
                                                Text("\(calories) calories")
                                                    .font(.title)
                                                    .padding(.bottom, 32)
                                            }
                                        }
                                        .onTapGesture {
                                            if let calories = hint.food.nutrients["ENERC_KCAL"] {
                                                selectFood(calories: calories)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: {
                            isShowingSearchSheet = true // Show the sheet when the button is pressed
                        }) {
                            Image(systemName: "magnifyingglass")
                        }
                    }
                }
                .navigationBarItems(trailing: Button(action: {
                    do {
                        try authManager.signOut()
                        isLoggedIn = false // Set isLoggedIn to false to navigate back to the login page
                    } catch {
                        print("Error signing out: \(error.localizedDescription)")
                    }
                }) {
                    Text("Logout")
                })
            } else {
                LoginView()
            }
        }
    }

    func updateProgress() {
        progress = CGFloat(totalCalories) / CGFloat(calories) // Updated progress calculation
    }

    func selectFood(calories: Double) {
        totalCalories += Int(calories) // Add calories to the total
    }
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
    }
}
