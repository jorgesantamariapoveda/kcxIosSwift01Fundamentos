//
//  FavoritesViewController.swift
//  AppOfThrones
//
//  Created by Jorge on 21/02/2020.
//  Copyright © 2020 Jorge. All rights reserved.
//

import UIKit

class FavoritesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!

    deinit {
        // Si no se hace esto puede caerse la app
        NotificationCenter.default.removeObserver(self, name: Constants.kNoteNameDidFavoritesUpdated, object: nil)
    }
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupUI()
        self.setupNotifications()
    }

    // MARK: - Setup

    func setupUI() {
        self.title = "Favorites"

        let nib = UINib(nibName: "EpisodeFavoriteTableViewCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: "EpisodeFavoriteTableViewCell")

        self.tableView.delegate = self
        self.tableView.dataSource = self

        self.tableView.separatorStyle = .none
    }

    func setupNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.didEpisodeFavoriteChanged), name: Constants.kNoteNameDidFavoritesUpdated, object: nil)
    }

    // MARK: - UITableViewDataSource

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataController.shared.numFavoriteEpisodes()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "EpisodeFavoriteTableViewCell", for: indexPath) as? EpisodeFavoriteTableViewCell {
            let episode = DataController.shared.getFavoriteEpisode(indexPath.row)
            cell.setEpisode(episode)
            return cell
        }
        fatalError("☠️ Cell-House")
    }

    // MARK: - UITableViewDelegate

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let episode = DataController.shared.getFavoriteEpisode(indexPath.row)
        let episodeDetailViewController = EpisodeDetailViewController()
        episodeDetailViewController.setEpisode(episode)
        self.navigationController?.pushViewController(episodeDetailViewController, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }

    // MARK: - FavoriteDelegate

    @objc func didEpisodeFavoriteChanged() {
        self.tableView.reloadData()
    }

}
