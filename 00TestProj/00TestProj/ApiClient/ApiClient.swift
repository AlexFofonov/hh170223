//
//  ApiClient.swift
//  00TestProj
//
//  Created by Александр Фофонов on 03.02.2023.
//

import Foundation

class ApiClient {
    
    init(decoder: JSONDecoder) {
        self.decoder = decoder
    }
    
    private let decoder: JSONDecoder
    enum ApiClientError: Error {
        case callerDestroyed
        case urlNotFound
        case dataInitFail
        case decodingFail
    }
    
    func get<ResponseData: Decodable>(_ type: ResponseData.Type, completion: @escaping (Result<ResponseBody<ResponseData>, ApiClientError>?) -> Void) {
        DispatchQueue.global(qos: .userInteractive).async { [weak self] in
            guard let self = self else {
                completion(.failure(.callerDestroyed))
                return
            }
            
            guard let url = Bundle.main.url(forResource: "Profile", withExtension: "json") else {
                completion(.failure(.urlNotFound))
                return
            }
            
            guard let data = try? Data.init(contentsOf: url) else {
                completion(.failure(.dataInitFail))
                return
            }
            
            self.decoder.keyDecodingStrategy = .convertFromSnakeCase
            self.decoder.dateDecodingStrategy = .formatted(Assembly().dateFormatter(format: .kebab_yyyyMMdd) as! DateFormatter)
            
            guard let responseBody = try? self.decoder.decode(ResponseBody<ResponseData>.self, from: data) else {
                completion(.failure(.decodingFail))
                return
            }
            
            DispatchQueue.main.async {
                completion(.success(responseBody))
            }
        }
    }
    
}
