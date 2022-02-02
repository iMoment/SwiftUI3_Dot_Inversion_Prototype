//
//  LandingView.swift
//  Dot_Inversion
//
//  Created by Stanley Pan on 2022/02/01.
//

import SwiftUI

struct LandingView: View {
    @State var currentIndex: Int = 0
    
    var body: some View {
        ZStack {
            DotInversion(currentIndex: $currentIndex)
                .ignoresSafeArea()
            
            // Indicators
            HStack(spacing: 10) {
                ForEach(tabs.indices, id: \.self) { index in
                    Circle()
                        .fill(Color.white)
                        .frame(width: 8, height: 8)
                        .opacity(currentIndex == index ? 1 : 0.3)
                        .scaleEffect(currentIndex == index ? 1.1 : 0.8)
                    
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
            .padding(25)
            
            // Skip Buton
            Button("Skip") {
                
            }
            .font(.system(size: 18, weight: .bold))
            .foregroundColor(Color.white)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
            .padding()
        }
    }
}

struct LandingView_Previews: PreviewProvider {
    static var previews: some View {
        LandingView()
    }
}
