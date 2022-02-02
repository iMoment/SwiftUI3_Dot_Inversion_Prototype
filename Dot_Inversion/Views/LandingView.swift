//
//  LandingView.swift
//  Dot_Inversion
//
//  Created by Stanley Pan on 2022/02/01.
//

import SwiftUI

struct LandingView: View {
    
    var body: some View {
        ZStack {
            DotInversion()
                .ignoresSafeArea()
        }
    }
}

struct LandingView_Previews: PreviewProvider {
    static var previews: some View {
        LandingView()
    }
}
