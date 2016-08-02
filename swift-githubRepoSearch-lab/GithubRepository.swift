//
//  GithubRepository.swift
//  swift-githubRepoSearch-lab
//
//  Created by Haaris Muneer on 7/28/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit
import SwiftyJSON

class GithubRepository {
    
    // The full name of the repository (e.g., "githubUser/nameOfRepo")
    var fullName: String
    
    // The page for the repository on Github's website
    var htmlURL: NSURL
    
    // The ID of the repository.
    var repositoryID: String
    
    // Now we need some way to turn our dictionaries into instances of GithubRepository. Let's do this by giving the class a custom initializer, init(dictionary:), that will take in a dictionary from the API and assign the properties based on the values in that dictionary. The relevant dictionary keys are "full_name", "id", and "html_url".
    init(dictionary: NSDictionary) {
        
        guard let
            
            name = dictionary["full_name"] as? String,
            
            valueAsString = dictionary["html_url"] as? String,
            
            valueAsURL = NSURL(string: valueAsString),
            
            repoID = dictionary["id"]?.stringValue
            
            else { fatalError("Could not create repository object from supplied dictionary") }
        
        htmlURL = valueAsURL
        
        fullName = name
        
        repositoryID = repoID
    }
}
