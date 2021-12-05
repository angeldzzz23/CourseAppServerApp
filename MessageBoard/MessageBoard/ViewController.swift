//
//  ViewController.swift
//  MessageBoard
//
//  Created by angel zambrano on 11/28/21.
//

import UIKit

class ViewController: UIViewController {


    // MARK: UI Elements
    let postTableView = UITableView()
    let filterPostButton = UIBarButtonItem()
    let addPostButton = UIBarButtonItem()
    let postReuseIdentifier = "postReuseIdentifier"
    
    // Learn how to setup a refreshControl here https://cocoacasts.com/how-to-add-pull-to-refresh-to-a-table-view-or-collection-view
    let refreshControl = UIRefreshControl()
    
    // Learn how to setup UIAlertControllers here https://learnappmaking.com/uialertcontroller-alerts-swift-how-to/
    let createAlert = UIAlertController(title: "Add new post", message: nil, preferredStyle: .alert)
    let filterAlert = UIAlertController(title: "Filter poster's posts", message: nil, preferredStyle: .alert)
    let updateAlert = UIAlertController(title: "Update your post", message: nil, preferredStyle: .alert)
    
    // MARK: Data
    var postData: [Post] = []
    var shownPostData: [Post] = [] // Unlike in lecture, it would be a good idea to leave this here because we filter and so we need to maintain our original data in postData
    
    // MARK: Variables
    var currentIndexPathToUpdate: IndexPath? // We use this for updating and deleting
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        title = "Message Board"
        view.backgroundColor = .white
        
        // gets all posts
        // user
        NetworkManager.getAllPosts { posts in
            self.postData = posts
            self.sortPostData()
            self.shownPostData = posts
            self.postTableView.reloadData()
        }
        
        setupViews()
        setupConstraints()
        
        shownPostData = postData
      
        NetworkManager.createPost(title: "monster", body: "a nice energy drink!!!", poster: "m1chip") { post in
            print(post)
        }
        
        
    }
    
    /// Order `postData` in order of newest to oldest.
    /// PRECONDITION: Post ids are ordered where the lowest is the oldest and the highest is the newest. */
    func sortPostData() {
        postData.sort { (leftPost, rightPost) -> Bool in
            return leftPost.id > rightPost.id
        }
    }
    
    func createDummyData() {
        // MARK: Use getAllPosts
        /**
         We want to retrieve data from the server here upon refresh. Make sure to
         1) Sort the posts with `sortPostData`
         2) Update `postData` & `shownPostData` and reload `postTableView`
         */
        let post1 = Post(id: 0, title: "Hello world", body: "I'm hungry", hashedPoster: "abc123", timestamp: "2021-04-11T01:29:25.068500639Z")
        let post2 = Post(id: 1, title: "Hello hungry", body: "I'm world", hashedPoster: "def456", timestamp: "2021-04-11T03:39:35.068500639Z")
        let post3 = Post(id: 2, title: "Really?", body: "That's not what I meant", hashedPoster: "abc123", timestamp: "2021-04-12T01:29:54.068500639Z")
        let post4 = Post(id: 3, title: "spamz", body: String(repeating: "spam", count: 100), hashedPoster: "troll", timestamp: "2021-04-12T01:30:56.068500639Z")
        let post5 = Post(id: 4, title: "Oh", body: "Sorry", hashedPoster: "def456", timestamp: "2021-04-12T04:19:45.068500639Z")
        postData = [post1, post2, post3, post4, post5]
        sortPostData()
        shownPostData = postData
    }
    
    func setupViews() {
        postTableView.translatesAutoresizingMaskIntoConstraints = false
        postTableView.delegate = self
        postTableView.dataSource = self
        postTableView.register(PostTableViewCell.self, forCellReuseIdentifier: postReuseIdentifier)
        view.addSubview(postTableView)
        
        if #available(iOS 10.0, *) {
            postTableView.refreshControl = refreshControl
        } else {
            postTableView.addSubview(refreshControl)
        }
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        
        filterPostButton.title = "Filter"
        filterPostButton.target = self
        filterPostButton.action = #selector(prepareFilteringAction)
        navigationItem.leftBarButtonItem = filterPostButton
        
        addPostButton.title = "Add"
        addPostButton.target = self
        addPostButton.action = #selector(presentCreateAlert)
        navigationItem.rightBarButtonItem = addPostButton
        
        createAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        createAlert.addTextField(configurationHandler: { textField in
            textField.placeholder = "Input the title name here..."
        })
        createAlert.addTextField(configurationHandler: { textField in
            textField.placeholder = "Input the body name here..."
        })
        createAlert.addTextField(configurationHandler: { textField in
            textField.placeholder = "Input the UNHASHED poster here..."
        })
        createAlert.addAction(UIAlertAction(title: "Create", style: .default, handler: { action in
            if let textFields = self.createAlert.textFields,
               let title = textFields[0].text?.trimmingCharacters(in: .whitespacesAndNewlines),
               let body = textFields[1].text?.trimmingCharacters(in: .whitespacesAndNewlines),
               let poster = textFields[2].text?.trimmingCharacters(in: .whitespacesAndNewlines),
               title != "", body != "", poster != "" {
                // MARK: Use createPost
                /**
                We want to create data onto the server here upon pressing `Create` with the appropriate title and body. Make sure to
                1) Update `postData` & `shownPostData` and reload `postTableView`
                 
                 DO NOT CALL `getAllPosts`
                */
                print("\(title) \(body) \(poster)")
            }
        }))
        
        filterAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        filterAlert.addTextField(configurationHandler: { textField in
            textField.placeholder = "Filter by ID here..."
        })
        filterAlert.addTextField(configurationHandler: { textField in
            textField.placeholder = "or alternatively UNHASHED poster here..."
        })
        filterAlert.addAction(UIAlertAction(title: "Filter", style: .default, handler: { action in
            if let id = self.filterAlert.textFields?[0].text?.trimmingCharacters(in: .whitespacesAndNewlines), let integerID = Int(id) {
                // MARK: Use getSpecificPost
                /**
                We want to retrieve a single piece of data from the server here upon pressing `Filter` with the appropriate id. Make sure to
                 1) Update `shownPostData` and reload `postTableView`
                 
                 DO NOT UPDATE `postData`
                 This is why we use `shownPostData` in addition to `postData`. When you press Cancel, verify that the data is set back to the original (this is already done for you, just check that it still works)
                 
                 DO NOT CALL `getAllPosts`
                */
                print(integerID)
                self.filterPostButton.title = "Cancel"
            } else if let unhashedPoster = self.filterAlert.textFields?[1].text?.trimmingCharacters(in: .whitespacesAndNewlines),
               unhashedPoster != "" { // NOTE this will not run unless you clear the ID textfield.
                // MARK: Use getPostersPosts
                /**
                We want to retrieve data from the server here upon pressing `Filter` with the appropriate poster. Make sure to
                 1) Sort the posts with `sortPostData`
                 2) Update `shownPostData` and reload `postTableView`
                 
                 DO NOT UPDATE `postData`
                 This is why we use `shownPostData` in addition to `postData`. When you press Cancel, verify that the data is set back to the original (this is already done for you, just check that it still works)
                 
                 DO NOT CALL `getAllPosts`
                */
                print(unhashedPoster)
                self.filterPostButton.title = "Cancel"
            }
        }))
        
        updateAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        updateAlert.addTextField(configurationHandler: { textField in
            textField.placeholder = "Update the post body here..."
        })
        updateAlert.addTextField(configurationHandler: { textField in
            textField.placeholder = "Provide the UNHASHED poster here..."
        })
        updateAlert.addAction(UIAlertAction(title: "Update", style: .default, handler: { action in
            if let textFields = self.updateAlert.textFields,
               let body = textFields[0].text?.trimmingCharacters(in: .whitespacesAndNewlines),
               let poster = textFields[1].text?.trimmingCharacters(in: .whitespacesAndNewlines),
               let indexPath = self.currentIndexPathToUpdate,
               body != "", poster != "" {
                // MARK: Use updatePost
                /**
                We want to update data from the server here upon pressing `Update` with the appropriate poster and a body. Make sure to
                1) Update `postData` & `shownPostData` and reload `postTableView`
                 
                 Note we can only update a post's body if we created. We want to use our UNHASHED (original) poster name, which acts as a password, to guarantee this.
                 
                 DO NOT CALL `getAllPosts`
                */
                print("\(indexPath) \(body) \(poster)")
            }
        }))
        updateAlert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { action in
            if let textFields = self.updateAlert.textFields,
               let poster = textFields[1].text?.trimmingCharacters(in: .whitespacesAndNewlines),
               let indexPath = self.currentIndexPathToUpdate {
                // MARK: Use deletePost
                /**
                We want to delete data from the server here upon pressing `Delete` with the appropriate poster. Make sure to
                1) Update `postData` & `shownPostData` and reload `postTableView`
                 
                 Note we can only delete posts that we created. We want to use our UNHASHED (original) poster name, which acts as a password, to guarantee this.
                 
                 DO NOT CALL `getAllPosts`
                */
                print("\(indexPath) \(poster)")
            }
        }))
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            postTableView.topAnchor.constraint(equalTo: view.topAnchor),
            postTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            postTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            postTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    @objc func refreshData() {
        // MARK: Use getAllPosts
        
        
        
        /**
         We want to retrieve data from the server here upon refresh. Make sure to
         1) Sort the posts with `sortPostData`
         2) Update `postData` & `shownPostData` and reload `postTableView`
         3) End the refreshing on `refreshControl`
         ddd
         DO NOT USE `DispatchQueue.main.asyncAfter` as currently is - just use `getAllPosts`
         */
        
        NetworkManager.getAllPosts { posts in
            self.postData = posts
            self.sortPostData()
            self.shownPostData = posts
            self.postTableView.reloadData()
            self.refreshControl.endRefreshing()
        }
        
    
    }
    
    @objc func prepareFilteringAction() {
        if filterPostButton.title == "Filter" {
            present(filterAlert, animated: true)
        } else {
            filterPostButton.title = "Filter"
            shownPostData = postData
        }
    }
    
    @objc func presentCreateAlert() {
        present(createAlert, animated: true)
    }
    

}


extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        updateAlert.textFields?[0].text = postData[indexPath.row].body
        currentIndexPathToUpdate = indexPath
        present(updateAlert, animated: true)
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shownPostData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: postReuseIdentifier, for: indexPath) as! PostTableViewCell
        let postObject = shownPostData[indexPath.row]
        cell.configure(with: postObject)
        return cell
    }
}
