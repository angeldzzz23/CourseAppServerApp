//
//  NetworkManager.swift
//  MessageBoard
//
//  Created by angel zambrano on 11/28/21.
//

import Foundation
import Alamofire



class NetworkManager {
    
    /** To receive full marks on this assignment, you must do ALL of the following
        1) Setup CocoaPods to install and import Alamofire to actually do this assignment.
        2) Fill out the function stubs provided below - leave them untouched unless otherwise instructed.
            a) Note that all completions are of type `Any` - you should change these to the correct types (and any necessary keywords..)
        3) For each function stub, make sure you go to `Post.swift` to add Codable structs as necessary
        4) After filling in a function stub, go to `ViewController.swift` and add the completion in the marked area for that function and verify that your implementation works
            a) Steps are provided to help guide you in what to do inside your completion
            b) Print statements are provided to help you debug and to hint towards which variables you will need to use the implement the completion body
        5) Don't modify any other code in this project without good reason.
            a) This includes the MARK and explanatory comments, leave them to make your graders' lives easier.
     */
    
    /** Put the provided server endpoint here. If you don't know what this is, contact course staff. */
    static let host = "http://localhost:8080/"
    
    static func getAllPosts(completion: @escaping ([Post]) -> Void) {
        let endpoint = "\(host)posts/"
        
        AF.request(endpoint, method: .get).validate().responseData { response in
            switch response.result {
            case .success(let data):
                print("here i am")
                let jsonDecoder = JSONDecoder()
                // get the userResponse
                
                if let userResponse = try? jsonDecoder.decode(Posts.self, from: data) {
                    completion(userResponse)
                    print(userResponse)
                }
                break
            case .failure(let failure):
                print("here i am too")
                break
            }
        }
        
    }
    
    static func getSpecificPost(id: Int, completion: Any) {
        
    }
    
    static func createPost(title: String, body: String, poster: String, completion: Any) {
        
    }
    
    static func updatePost(body: String, poster: String, completion: Any) {
        
    }
    
    static func deletePost(poster: String, completion: Any) {
        
    }
    
    // Extra Credit
    
    static func getPostersPosts(poster: String, completion: Any) {
        
    }
    
}
