//
//  VideoModel.swift
//  SwiftShorts
//
//  Created by Sumanth Maddela on 23/07/25.
//

import Foundation

struct VideoModel: Decodable {
    let videos: [Video]

    struct Video: Decodable {
        let videoFiles: [VideoFile]

        enum CodingKeys: String, CodingKey {
            case videoFiles = "video_files"
        }
    }
}

struct VideoFile: Decodable {
    let id: Int
    let quality: String?
    let fileType: String
    let width: Int?
    let height: Int?
    let link: String

    enum CodingKeys: String, CodingKey {
        case id
        case quality
        case fileType = "file_type"
        case width
        case height
        case link
    }
}
