//
//  Tab.swift
//  Dot_Inversion
//
//  Created by Stanley Pan on 2022/02/01.
//

import SwiftUI

// MARK: Tab Model and sample Intro Tabs
struct Tab: Identifiable {
    var id: String = UUID().uuidString
    var title: String
    var subTitle: String
    var description: String
    var image: String
    var color: Color
}

var tabs: [Tab] = [
    Tab(title: "Store", subTitle: "your media", description: "Store all your video and images in our cloud for easy accessibility.", image: "landing01", color: Color("darkGrey")),
    Tab(title: "Share", subTitle: "your content", description: "Easily distribute your content to your followers with ease!", image: "landing02", color: Color("brightOrange")),
    Tab(title: "Participate", subTitle: "in your community", description: "Communicate with other content creators and followers in our social messaging platform!", image: "landing03", color: Color("darkBlue"))
]
