//
//  NetworkManager.swift
//  I-H final
//
//  Created by mustafa farah on 24/05/2023.
//
import Combine
import Foundation

struct FoodSearchResult: Decodable {
    let text: String
    let hints: [Hint]
}

struct Hint: Decodable {
    let food: FoodDetails
}

struct FoodDetails: Decodable {
    let label: String
    let nutrients: [String: Double]
}

class NetworkManager: ObservableObject {
    @Published var foodSearchResult: FoodSearchResult?
    var cancellationToken: AnyCancellable?

    func getFoodData(for foodName: String) {
        let urlString = "https://api.edamam.com/api/food-database/v2/parser?ingr=\(foodName)&app_id=5954e932&app_key=97614bde3bad75b1f4517aefbf17d227"
        
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        
        cancellationToken = URLSession.shared.dataTaskPublisher(for: createRequest(with: url))
            .map(\.data)
            .decode(type: FoodSearchResult.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in },
                  receiveValue: { [weak self] in self?.foodSearchResult = $0 })

    }
    
    func createRequest(with url: URL) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        return request
    }
}

