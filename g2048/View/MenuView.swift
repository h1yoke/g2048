//
//  MenuView.swift
//  g2048
//
//  Created by Dmitry Protsenko on 05.04.2024.
//

import SwiftUI

struct MenuView: View {
    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            Button("play", action: {})
                .navigationBarHidden(true)
                .padding()
                .frame(maxWidth: .infinity)
                .background(.gray)
                .clipShape(Capsule())
            Button("settings", action: {})
                .padding()
                .frame(maxWidth: .infinity)
                .background(.brown)
                .clipShape(Capsule())
            Button("highscores", action: {})
                .padding()
                .frame(maxWidth: .infinity)
                .background(.yellow)
                .clipShape(Capsule())
        }
        .foregroundStyle(.white)
        .frame(maxWidth: 500)
        .padding(.horizontal, 30.0)
        .font(.title)
    }
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView()
    }
}
