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
    
    // Current and Next Index
    @Binding var currentIndex: Int
    @State var nextIndex: Int = 1
    
    
    var body: some View {
        ZStack {
            
            ZStack {
                // Changing color based on state
                (dotState == .normal ? tabs[currentIndex].color : tabs[nextIndex].color)
                
                if dotState == .normal {
                    MinimizedView()
                } else {
                    ExpandedView()
                }
            }
            .animation(.none, value: dotState)
            
            Rectangle()
                .fill(dotState != .normal ? tabs[currentIndex].color : tabs[nextIndex].color)
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
                            .frame(width: 80, height: 80)
                            .scaleEffect(dotScale)
                            .rotation3DEffect(.init(degrees: dotRotation), axis: (x: 0, y: 1, z: 0), anchorZ: dotState == .flipped ? -10 : 10, perspective: 1)
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                            .offset(y: -(getSafeArea().bottom + 20))
                    }
                )
            // For Tap Gesture
            Circle()
                .foregroundColor(Color.black.opacity(0.01))
                .frame(width: 80, height: 80)
                // Arrow
                .overlay(
                    Image(systemName: "chevron.right")
                        .font(.title)
                        .foregroundColor(Color.white)
                    // Opacity Animation
                        .opacity(dotRotation == -180 ? 0 : 1)
                        .animation(.easeInOut, value: dotRotation)
                )
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                .onTapGesture(perform: {
                    if isAnimating { return }
                    
                    isAnimating = true
                    
                    withAnimation(.linear(duration: 1.5)) {
                        dotRotation = -180
                        dotScale = 8
                    }
                    
                    // Modifying for single tap
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.725) {
                        // Updating animation
                        withAnimation(.easeInOut(duration: 0.7)) {
                            dotState = .flipped
                        }
                    }
                    
                    // Animation Reversal
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                        withAnimation(.easeInOut(duration: 0.5)) {
                            dotScale = 1
                        }
                    }
                    
                    // After 1.4s, reset isAnimating State
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.4) {
                        // Resetting to default
                        withAnimation(.easeInOut(duration: 0.3)) {
                            dotRotation = 0
                            dotState = .normal
                            
                            // Updating index, currentIndex is next
                            currentIndex = nextIndex
                            nextIndex = getNextIndex()
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            isAnimating = false
                        }
                    }
                })
                .offset(y: -(getSafeArea().bottom + 20))
        }
        .ignoresSafeArea()
    }
    
    @ViewBuilder
    func IntroView(tab: Tab) -> some View {
        VStack {
            Image(tab.image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding(40)
            
            VStack(alignment: .leading, spacing: 0) {
                Text(tab.title)
                    .font(.system(size: 45))
                
                Text(tab.subTitle)
                    .font(.system(size: 50, weight: .bold))
                
                Text(tab.description)
                    .fontWeight(.semibold)
                    .padding(.top)
                    .frame(width: getScreenSize().width - 100, alignment: .leading)
                
            }
            .foregroundColor(Color.white)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading, 20)
            .padding([.trailing, .top])
        }
    }
    
    // Infinite loop effect
    func getNextIndex() -> Int {
        let index = (nextIndex + 1) > (tabs.count - 1) ? 0 : (nextIndex + 1)
        return index
    }
    
    // MARK: Expand and Minimize Views
    @ViewBuilder
    func ExpandedView() -> some View {
        IntroView(tab: tabs[nextIndex])
            .offset(y: -50)
    }
    
    @ViewBuilder
    func MinimizedView() -> some View {
        IntroView(tab: tabs[currentIndex])
            .offset(y: -50)
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

// MARK: View Extension for Screen Rect
extension View {
    func getScreenSize() -> CGRect {
        return UIScreen.main.bounds
    }
    
    func getSafeArea() -> UIEdgeInsets {
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return .zero }
        
        guard let safeArea = screen.windows.first?.safeAreaInsets else { return .zero }
        
        return safeArea
    }
}
