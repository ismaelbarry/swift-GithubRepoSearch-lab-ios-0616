//
//  ReposDataStore.swift
//  swift-githubRepoSearch-lab
//
//  Created by Haaris Muneer on 7/28/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit

class ReposDataStore {
    
    static let sharedInstance = ReposDataStore()
    
    private init() {}
    
    var repositories:[GithubRepository] = []
    
    func getRepositoriesWithCompletion(completion: () -> ()) {
        
        GithubAPIClient.getRepositoriesWithCompletion { (reposArray) in
            
            self.repositories.removeAll()
            
            for dictionary in reposArray {
                
                guard let repoDictionary = dictionary as? NSDictionary else { fatalError("Object in reposArray is of non-dictionary type") }
                
                let repository = GithubRepository(dictionary: repoDictionary)
                
                self.repositories.append(repository)
            }
            completion()
        }
    }
    
    func getSearchRepositoriesWithCompletion(searchString: String, completion:() ->()) {
    
        GithubAPIClient.searchRepositoryWithCompletion(searchString) { (searchReposArray) in
        
            self.repositories.removeAll()
            
            for dictionary in searchReposArray {
                
                guard let searchReposDictionary = dictionary as? NSDictionary else { fatalError("Object in reposSearchArray is of non-dictionary type") }
                
                let repository = GithubRepository(dictionary: searchReposDictionary)
                
                self.repositories.append(repository)
            }
            completion()
        }
    }
    
    // Given a GithubRepository object, checks to see if it's starred or not and then either stars or unstars the repo. That is, it should toggle the star on a given repository. In the completion closure, there should be a Bool parameter called starred that is true if the repo was just starred, and false if it was just unstarred.
    func toggleStarStatusForRepository(repository: GithubRepository, completion:(Bool) -> ()) {
        
        // Ask yourself: The person has not come to you to ask you if a repository is starred, you now have to give them an asnwer. Good thing you wrote the "checkIfRepositoryIsStarred" function to have a Bool in its completion.
        GithubAPIClient.checkIfRepositoryIsStarred(repository.fullName) { (starred) in
            
            // If repository is starred, then we unstar it.
            if starred == true {
                
                GithubAPIClient.unstarRepository(repository.fullName, completion: {
                    
                    print("unstarring repository")
                    
                    completion(true)
                })
                
                // If repository is unstarred, then we star it.
            } else {
                
                GithubAPIClient.starRepository(repository.fullName, completion: {
                    
                    print("starring repository")
                    
                    completion(false)
                })
            }
        }
    }
}