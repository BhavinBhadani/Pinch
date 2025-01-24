//
//  PageModel.swift
//  Pinch
//
//  Created by Bhavin Bhadani on 24/01/25.
//

import Foundation

struct Page: Identifiable {
    let id: Int
    let imageName: String
}

extension Page {
    var thumbnailName: String {
        return "thumb-\(imageName)"
    }
}
