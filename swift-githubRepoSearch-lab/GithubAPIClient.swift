//
//  GithubAPIClient.swift
//  swift-githubRepoSearch-lab
//
//  Created by Haaris Muneer on 7/28/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class GithubAPIClient {
    
    // The job of this function is to fetch all the repositories from the Github API, and pass that array of dictionaries on to its completion closure.
    //  How does this method get those objects back to the person who called it? It should take its own closure as an argument, which accepts the array of dictionaries as a parameter and returns nothing.
    class func getRepositoriesWithCompletion(completion: (NSArray) -> ()) {
        
        let urlString = "\(Secrets.githubAPIURL)/repositories?client_id=\(Secrets.githubClientID)&client_secret=\(Secrets.githubClientSecret)"
        
        Alamofire.Manager.sharedInstance.request(.GET, urlString).responseJSON { (response) in
            
          if let jsonResponseArray = response.result.value as? NSArray {
                
              //print(jsonResponseArray)
              completion(jsonResponseArray)
          }
        }
    }
    
    // Searches a repository from the text provided in the alert controller (which you will create).
    class func searchRepositoryWithCompletion(searchText: String, completion:(NSArray) -> ()) {
        
        let urlString = "\(Secrets.githubSearchRepository)\(searchText)"
        
        let authorizationHeaders = ["Authorization":"\(Secrets.authorizationAccessToken)"]
        
        Alamofire.Manager.sharedInstance.request(.GET, urlString, parameters: nil, encoding: ParameterEncoding.JSON, headers: authorizationHeaders).validate().responseJSON { (response) in
            
            if let jsonResponseDict = response.result.value as? NSDictionary, jsonResponseArray = jsonResponseDict["items"] as? NSArray {
                
                print(jsonResponseArray)
                
                completion(jsonResponseArray)
            }
        }
    }
    
    // Method accepts a repo full name (e.g. githubUser/repoName) and checks to see if it is currently starred. The completion closure should take a boolean (true for starred, false otherwise).
    // Ask yourself: If some wants you to check if a repository is starred, then you have to provide them a YES or NO answer. Hence the Bool in the completion.
    class func checkIfRepositoryIsStarred(fullName: String,  completion: (Bool) ->()) {
        
        let urlString = "\(Secrets.githubStarRepositoryURL)\(fullName)"
        
        let authorizationHeaders = ["Authorization":"\(Secrets.authorizationAccessToken)"]
        
        Alamofire.Manager.sharedInstance.request(.GET, urlString, parameters: nil, encoding: ParameterEncoding.JSON, headers: authorizationHeaders).validate().responseJSON { (response) in
            
            switch response.result {
            
            case .Success:
                completion(true)
            case .Failure(let error):
                print(error)
                completion(false)
            }
        }
    }
    
    // Method stars a repository given its full name.
    // Ask yourself: If some wants you to star a repository, you don't have to give them an answer...you just do it. Hence nothing in the completion.
    class func starRepository(fullName: String, completion:() -> ()) {
        
        let urlString = "\(Secrets.githubStarRepositoryURL)\(fullName)"
        
        let authorizationHeaders = ["Authorization":"\(Secrets.authorizationAccessToken)"]
        
        Alamofire.Manager.sharedInstance.request(.PUT, urlString, parameters: nil, encoding: ParameterEncoding.JSON, headers: authorizationHeaders).validate().responseJSON { (response) in
            
            switch response.result {
                
            case .Success:
                completion()
            case .Failure(let error):
                print(error)
                assertionFailure("Error in starring repository \(response.result.value?.integerValue)")
            
            }
        }
    }
    
    // Method unstars a repository given its full name.
    // Ask yourself: If some wants you to un-star a repository, you don't have to give them an answer...you just do it. Hence nothing in the completion.
    class func unstarRepository(fullName: String, completion:() -> ()) {
        
        let urlString = "\(Secrets.githubStarRepositoryURL)\(fullName)"
        
        let authorizationHeaders = ["Authorization":"\(Secrets.authorizationAccessToken)"]
        
        Alamofire.Manager.sharedInstance.request(.DELETE, urlString, parameters: nil, encoding: ParameterEncoding.JSON, headers: authorizationHeaders).validate().responseJSON { (response) in

            switch response.result {
                
            case .Success:
                completion()
            case .Failure(let error):
                print(error)
                assertionFailure("Error in unstarring repository \(response.result.value?.integerValue)")
            }
        }
    }
}