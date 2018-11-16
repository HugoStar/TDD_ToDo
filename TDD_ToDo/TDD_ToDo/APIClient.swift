//
//  APIClient.swift
//  TDD_ToDo
//
//  Created by Мишустин Сергеевич on 16/11/2018.
//  Copyright © 2018 LTD Zebka. All rights reserved.
//

import Foundation

protocol SessionProtocol {
  func dataTask( with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
}


class APIClient {
  
  lazy var session: SessionProtocol = URLSession.shared
  
  func loginUser(withName username: String, password: String, completion: @escaping (Token? , Error?) -> Void) {
    let query = "username=\(username.percentEncoded)&password=\(password.percentEncoded)"
    guard let url = URL(string: "https://awesometodos.com/login?\(query)") else { fatalError() }
    session.dataTask(with: url) { (data, responce, error) in
      guard let data = data else { return }
      let dict = try! JSONSerialization.jsonObject( with: data, options: []) as? [String:String]
      let token: Token?
      if let tokenString = dict?["token"] {
        token = Token(id: tokenString)
      } else { token = nil }
      completion(token, nil)
    }.resume()
  }
}

extension URLSession: SessionProtocol {}

extension String {
  var percentEncoded: String {
    let allowedCharacters = CharacterSet(charactersIn:"/%&=?$#+-~@<>|\\*,.()[]{}^!").inverted
    guard let encoded = self.addingPercentEncoding( withAllowedCharacters: allowedCharacters) else { fatalError() }
    return encoded
  }
}
