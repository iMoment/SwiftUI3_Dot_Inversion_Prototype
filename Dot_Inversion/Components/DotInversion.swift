//
//  DotInversion.swift
//  Dot_Inversion
//
//  Created by Stanley Pan on 2022/02/01.
//

import SwiftUI

struct DotInversion: View {
    
    // CurrentState
    @State var dotState: DotState = .normal
    @State var dotScale: CGFloat = 1
    // Rotation
    @State var dotRotation: Double = 0.0
    
    // MARK: Avoid multiple taps
    @State var isAnimating: Bool = false
    
    var body: some View {
        ZStack {
            
            ZStack {
                // Changing color based on state
                (dotState == .normal ? Color("brightOrange") : Color("darkGrey"))
                
                if dotState == .normal {
                    MinimizedView()
                } else {
                    ExpandedView()
                }
            }
            .animation(.none, value: dotState)
            
            Rectangle()
                .fill(dotState != .normal ? Color("brightOrange") : Color("darkGrey"))
                .overlay(
                    ZStack {
                        // MARK: Put view in reverse to look like masking effect
                        // Changing views based on state
                        if dotState != .normal {
                            MinimizedView()
                        } else {
                            ExpandedView()
                        }
                    }
                )
                .animation(.none, value: dotState)
            // Masking view with circle to create dot inversion animation
                .mask(
                    GeometryReader { proxy in
                        Circle()
                        // While increasing the scale the content will be visible
                            .frame(width: 100, height: 100)
                            .scaleEffect(dotScale)
                            .rotation3DEffect(.init(degrees: dotRotation), axis: (x: 0, y: 1, z: 0), anchorZ: dotState == .flipped ? -10 : 10, perspective: 1)
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                            .offset(y: -60)
                    }
                )
            // For Tap Gesture
            Circle()
                .foregroundColor(Color.black.opacity(0.01))
                .frame(width: 100, height: 100)
                // Arrow
                .overlay(
                    Image(systemName: "chevron.right")
                        .font(.title)
                        .foregroundColor(Color.white)
                    // Opacity Animation
                        .opacity(isAnimating ? 0 : 1)
                        .animation(.easeInOut(duration: 0.4), value: isAnimating)
                )
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                .onTapGesture(perform: {
                    if isAnimating { return }
                    
                    isAnimating = true
                    
                    if dotState == .flipped {
                        // Reverse effect
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.725) {
                            withAnimation(.linear(duration: 0.7)) {
                                dotScale = 1
                                dotState = .normal
                            }
                        }
                        withAnimation(.linear(duration: 1.5)) {
                            dotRotation = 0
                            dotScale = 8
                        }
                    } else {
                        // At duration 0.75, reset scale to 1 to create inversion effect
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.725) {
                            withAnimation(.linear(duration: 0.7)) {
                                dotScale = 1
                                dotState = .flipped
                            }
                        }
                        withAnimation(.linear(duration: 1.5)) {
                            dotRotation = -180
                            dotScale = 8
                        }
                    }
                    // After 1.4s, reset isAnimating State
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        isAnimating = false
                    }
                })
                .offset(y: -60)
        }
        .ignoresSafeArea()
    }
    // Expand and Minimize Views
    @ViewBuilder
    func ExpandedView() -> some View {
        VStack(spacing: 10) {
            Image(systemName: "ipad")
                .font(.system(size: 148))
            
            Text("iPad")
                .font(.system(size: 38).bold())
        }
        .foregroundColor(Color.white)
    }
    
    @ViewBuilder
    func MinimizedView() -> some View {
        VStack(spacing: 10) {
            Image(systemName: "applewatch")
                .font(.system(size: 148))
            
            Text("Apple Watch")
                .font(.system(size: 38).bold())
        }
        .foregroundColor(Color.white)
    }
}

struct DotInversion_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

// Enum for current Dot State
enum DotState {
    case normal
    case flipped
}
