//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Victoria Isaeva on 06.07.2023.
//

import Foundation

final class OAuth2Service {
    static let shared = OAuth2Service()
    private let urlSession = URLSession.shared
    
    func fetchOAuthToken( _ code: String,
                          completion: @escaping (Result<String, Error>) -> Void) {
        let request = authTokenRequest(code: code)
        let task = urlSession.data (for: request) { result in
            switch result {
            case .success(let data):
                do {
                    let decoder = JSONDecoder()
                    let responseObject = try decoder.decode(OAuthTokenResponseBody.self, from: data)
                    let authToken = responseObject.accessToken
                    OAuth2TokenStorage.shared.token = authToken
                    completion(.success(authToken))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
        task.resume()
    }
}

extension URLSession {
    func data(
        for request: URLRequest,
        completion: @escaping (Result<Data, Error>) -> Void) -> URLSessionTask {
            let fulfillCompletion: (Result<Data, Error>) -> Void = { result in
                DispatchQueue.main.async {
                    completion(result)
                }
            }
            let task = dataTask(with: request, completionHandler: { data, response, error in
                if let data = data,
                   let response = response,
                   let statusCode = (response as? HTTPURLResponse)?.statusCode {
                    if 200 ..< 300 ~= statusCode {
                        fulfillCompletion(.success(data))
                    } else {
                        fulfillCompletion(.failure(OAuth2Error.httpStatusCode(statusCode)))
                    }
                } else if let error = error {
                    fulfillCompletion(.failure(OAuth2Error.urlRequestError(error)))
                } else {
                    fulfillCompletion(.failure(OAuth2Error.urlSessionError))
                }
            })
            return task
        }
}

extension OAuth2Service {
    private func authTokenRequest(code: String) -> URLRequest {
        var urlComponents = URLComponents(string: "https://unsplash.com/oauth/token")!
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: AccessKey),
            URLQueryItem(name:"client_secret", value: SecretKey),
            URLQueryItem(name: "redirect_uri", value: RedirectURI),
            URLQueryItem(name:"code", value: code),
            URLQueryItem(name:"grant_type", value:"authorization_code")
        ]
        let url = urlComponents.url!
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        return request
    }
    
    private struct OAuthTokenResponseBody: Decodable {
        let accessToken: String
        let tokenType: String
        let scope: String
        let createdAt: Int
        
        enum CodingKeys: String, CodingKey {
            case accessToken = "access_token"
            case tokenType = "token_type"
            case scope
            case createdAt = "created_at"
        }
    }
    
}

enum OAuth2Error: Error {
    case httpStatusCode(Int)
    case urlRequestError(Error)
    case urlSessionError
}
