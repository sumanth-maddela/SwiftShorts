//
//  HomeViewModel.swift
//  SwiftShorts
//
//  Created by Sumanth Maddela on 24/07/25.
//

class HomeViewModel {
    var videoFiles: [VideoFile] = []

    func fetchVideos(page: Int, completion: @escaping () -> Void) {
        let requestBuilder = Request(page: page)

        if let request = requestBuilder.urlRequest {
            NetworkManager.shared.performRequest(request) { (result: Result<VideoModel, Error>) in
                switch result {
                case .success(let response):
                    // 🔑 Keep only ONE file per video
                    self.videoFiles = response.videos.compactMap { video in
                        video.videoFiles.first { $0.quality == "hd" } ?? video.videoFiles.first
                    }
                    completion()
                case .failure(let error):
                    print("Error:", error)
                }
            }
        } else {
            print("Failed to build request.")
        }
    }
}
