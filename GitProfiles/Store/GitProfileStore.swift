//
//  GitProfileStore.swift
//  GitProfiles
//
//  Created by Nato Egnatashvili on 3/5/21.
//

import UIKit
import CoreData

//thiss protocol is because core data notify presenter that it end saving.
protocol StoreDelegate {
    func didCatchAllData()
    func didSaved()
}

class GitProfileStore {
    var cityNamesObjects: [NSManagedObject] = []
    public var profiles: [WholeProfileModel] = []
     var delegate: StoreDelegate?
    func getContext() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    func saveImage(data: Data , profile: WholeProfileModel , isLast: Bool) {
        
        let context = self.getContext()
        let entity = NSEntityDescription.entity(forEntityName: "CoreDataModel", in: context)
        let cityName = NSManagedObject(entity: entity!, insertInto: context)
        cityName.setValue(data, forKey: "image")
        cityName.setValue( profile.username, forKey: "username")
        cityName.setValue(profile.note, forKey: "note")
        cityName.setValue(profile.follwer, forKey: "follower")
        cityName.setValue(profile.following, forKey: "following")
        cityName.setValue(profile.name, forKey: "name")
        cityName.setValue(profile.company, forKey: "company")
        cityName.setValue(profile.id, forKey: "id")
        cityName.setValue(profile.blog, forKey: "blog")
        do {
            try context.save()
            self.cityNamesObjects.append(cityName)
            if isLast {
                delegate?.didSaved()
            }
        } catch let error as NSError {
            let errorDialog = UIAlertController(title: "Error!", message: "Failed to save! \(error): \(error.userInfo)", preferredStyle: .alert)
            errorDialog.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        }
    }
    
    func saveNote(note: String , for id: Int) {
        let context = self.getContext()
        do {
            for obj in cityNamesObjects {
                if let objId = obj.value(forKey: "id") as? Int , objId == id {
                    obj.setValue(note, forKey: "note")
                    do {
                        try context.save()
                        getProfiles() 
                    } catch let error as NSError {
                        let errorDialog = UIAlertController(title: "Error!", message: "Failed to save! \(error): \(error.userInfo)", preferredStyle: .alert)
                        errorDialog.addAction(UIAlertAction(title: "Cancel", style: .cancel))
                    }
                }
            }
        }
    }
    
    
    func getProfiles() {
        let context = self.getContext()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CoreDataModel")
        do {
            self.cityNamesObjects = try context.fetch(fetchRequest) as [NSManagedObject]
            self.profiles = []
            for obj in cityNamesObjects {
                let id = obj.value(forKey: "id") as? Int
                let username = obj.value(forKey: "username") as? String
                let note = obj.value(forKey: "note") as? String
                let follower = obj.value(forKey: "follower") as? String
                let following = obj.value(forKey: "following") as? String
                let name = obj.value(forKey: "name") as? String
                let image = obj.value(forKey: "image") as? Data
                let company = obj.value(forKey: "company") as? String
                let blog = obj.value(forKey: "blog") as? String
                profiles.append(WholeProfileModel(id: id ?? 0,
                                                  username: username ?? "UNKNOWN",
                                                  image: UIImage(data: image!),
                                                  note: note,
                                                  follwer: follower ?? "",
                                                  following: following ?? "",
                                                  name: name ?? "",
                                                  company: company ?? "", blog: blog ?? ""))
            }
            profiles.sort { (d1, d2) -> Bool in
                d1.id < d2.id
            }
            delegate?.didCatchAllData()
        } catch {
            print("Error while fetching the image")
        }
    }
    
}
    

