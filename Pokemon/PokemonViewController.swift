//
//  ViewController.swift
//  Pokemon
//
//  Created by Colby Gatte on 10/31/16.
//  Copyright © 2016 colbyg. All rights reserved.
//

import UIKit


class Pokemon {
    var id: Int
    var imageURL: URL
    var latitude: Float
    var longitude: Float
    var name: String
    
    init(id: Int, name: String, imageURL: URL, latitude: Float, longitude: Float) {
        self.id = id
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
        self.imageURL = imageURL
    }
}

class PokemonViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var apiURL = URL(string: "https://still-wave-26435.herokuapp.com/pokemon/all")
    
    var pokemon = [Pokemon]()
    
    @IBOutlet var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let session = URLSession.shared
        
        session.dataTask(with: self.apiURL!) { (data: Data?, response: URLResponse?, error: Error?) in
            let json = try! JSONSerialization.jsonObject(with: data!, options: []) as! [[String:Any]]
            
            for result in json {
                
                let poke = Pokemon(id: result["id"] as! Int, name: result["name"] as! String, imageURL: URL(string: result["imageURL"] as! String)!, latitude: result["latitude"] as! Float, longitude: result["longitude"] as! Float)
                
                self.pokemon.append(poke)
                
                print("_____ADDED______")
            }
            
            print("----------reload data 1--")
            self.tableView.reloadData()
            
            
        }.resume()
        // ! DO ! NOT ! FORGET ! TO ! CALL ! RESUME !
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pokemon.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell")
        
        
        cell?.textLabel?.text = pokemon[indexPath.row].name
        
        URLSession.shared.dataTask(with: pokemon[indexPath.row].imageURL) { (data: Data?, response: URLResponse?, error: Error?) in
            print("in block")
            let img = UIImage(data: data!)
            cell?.imageView?.image = img
            
            
            self.tableView.reloadData()
            
           
        }.resume()
        // do not forget RESUME!!!!!!!
        
        
        return cell!
    }


}

