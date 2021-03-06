//
//  ServiceCall.swift
//  GitProfiles
//
//  Created by Nato Egnatashvili on 3/4/21.
//

import UIKit

//This is main file for service calls . this two structs are object , which is from git service. They are decodables , and because i need it to
//fill model , that has extension to make model.

struct UserDescription {
    let login: String?
    let id: Int?
    let node_id: String?
    let avatar_url: String?
    let gravatar_id: String?
    let url: String?
    let html_url: String?
    let followers_url: String?
    let following_url: String?
    let gists_url: String?
    let starred_url:  String?
    let subscriptions_url: String?
    let organizations_url: String?
    let repos_url: String?
    let events_url: String?
    let received_events_url: String?
    let type: String?
    let site_admin: Bool?
    let name: String?
    let company: String?
    let blog: String?
    let location: String?
    let email: String?
    let hireable: String?
    let bio: String?
    let twitter_username: String?
    let public_repos: Int?
    let public_gists: Int?
    let followers: Int?
    let following: Int?
    let created_at: String?
    let updated_at: String?
}

extension UserDescription: Decodable {
    enum CodingKeys: String , CodingKey {
        case login
        case id
        case node_id
        case avatar_url
        case gravatar_id
        case url
        case html_url
        case followers_url
        case following_url
        case gists_url
        case starred_url
        case subscriptions_url
        case organizations_url
        case repos_url
        case events_url
        case received_events_url
        case type
        case site_admin
        case name
        case company
        case blog
        case location
        case email
        case hireable
        case bio
        case twitter_username
        case public_repos
        case public_gists
        case followers
        case following
        case created_at
        case updated_at
    }
}

extension UserDescription {
    func makeFollowerFollowingModel(img: UIImage? ) -> UserDetailsCellModel{
        UserDetailsCellModel(image: img, follower: self.followers?.description ?? "0", following: self.following?.description ?? "0")
    }
    
    func makeBio() -> BioCellModel{
        BioCellModel(bios: [BioKeyValue.init(key: "name", value: self.name ?? "") ,
                            BioKeyValue.init(key: "compay", value: self.company ?? "") ,
                            BioKeyValue.init(key: "blog", value: self.blog ?? "") ])
    }
}


struct GitProfiles {
    let login: String?
    let id: Int?
    let node_id: String?
    let avatar_url: String?
    let gravatar_id: String?
    let url: String?
    let html_url: String?
    let followers_url: String?
    let following_url: String?
    let gists_url: String?
    let starred_url:  String?
    let subscriptions_url: String?
    let organizations_url: String?
    let repos_url: String?
    let events_url: String?
    let received_events_url: String?
    let type: String?
    let site_admin: Bool?
    }

extension GitProfiles: Decodable {
    enum CodingKeys: String , CodingKey {
        case login
        case id
        case node_id
        case avatar_url
        case gravatar_id
        case url
        case html_url
        case followers_url
        case following_url
        case gists_url
        case starred_url
        case subscriptions_url
        case organizations_url
        case repos_url
        case events_url
        case received_events_url
        case type
        case site_admin
    }
}

extension GitProfiles {
    func makeProfileModel(img: UIImage?)-> GithubProfileCellModel {
        GithubProfileCellModel(image: img, username: self.login ?? "NOT_KNOWN", needNote: false, animate: false, colorInverted: (self.id ?? 0) % 4 == 0)
    }
    
}
//This is main status for service call. If response is good it must be success , and it is generic. if not it would be error wuth it's type
//if internet connection is bad there is internetConnection case , and if service data not wrapped it has notHaveData.

enum Status <T>{
    case success(T)
    case fail(ErrorType)
}

enum ErrorType {
    case internetConnection
    case notHaveData
}

class Service {
  
    func get(_ url: URL, withCompletion completion: @escaping (Status<Any>) -> Void) {
        let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
             
                if error != nil || response == nil {
                    completion(Status.fail(ErrorType.internetConnection))
                    return
                }
                guard let data = data else {
                    completion(Status.fail(ErrorType.internetConnection))
                    return
                }
                let wrapper = try? JSONDecoder().decode([GitProfiles].self
                                                        , from: data)
                if let wrapper = wrapper {
                    completion(Status.success(wrapper))
                }else{
                    completion(Status.fail(ErrorType.notHaveData))
                }
                } )
            task.resume()
    }
    
    func getUserDescription(_ url: URL, withCompletion completion: @escaping (Status<Any>) -> Void) {
        let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
             
                if error != nil || response == nil {
                    completion(Status.fail(ErrorType.internetConnection))
                    return
                }
                guard let data = data else {
                    completion(Status.fail(ErrorType.internetConnection))
                    return
                }
                let wrapper = try? JSONDecoder().decode(UserDescription.self
                                                        , from: data)
                if let wrapper = wrapper {
                    completion(Status.success(wrapper))
                }else{
                    completion(Status.fail(ErrorType.notHaveData))
                }
                } )
            task.resume()
    }

}

