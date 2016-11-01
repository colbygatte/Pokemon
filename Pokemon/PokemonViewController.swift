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
    var image: UIImage
    var imageURL: URL
    var latitude: Float
    var longitude: Float
    var name: String
    
    init(id: Int, name: String, imageURL: URL, image: UIImage, latitude: Float, longitude: Float) {
        self.id = id
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
        self.image = image
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
                let img = UIImage()
                
                let poke = Pokemon(id: result["id"] as! Int, name: result["name"] as! String, imageURL: URL(string: result["imageURL"] as! String)!, image: img, latitude: result["latitude"] as! Float, longitude: result["longitude"] as! Float)
                
                self.pokemon.append(poke)
                
                print("_____NON______")
            }
            
            print("--reload data 1--")
            self.tableView.reloadData()
            // where do i need to reload table data?
            DispatchQueue.main.async {
                
                for poke in self.pokemon {
                    session.dataTask(with: poke.imageURL) { (data: Data?, response: URLResponse?, error: Error?) in
                        
                        let img = UIImage(data: data!)!
                        poke.image = img
                        
                        print("_____IMAGING_____")
                        
                    }.resume()
                }
                
                print ("RELOADING DATA 2!!!!")
                self.tableView.reloadData()
            }
        }.resume()
        // ! DO ! NOT ! FORGET ! TO ! CALL ! RESUME !
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        cell?.imageView?.image = pokemon[indexPath.row].image
        
        
        return cell!
    }


}

