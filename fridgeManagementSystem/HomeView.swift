//
//  HomeView.swift
//  fridgeManagementSystem
//
//  Created by Влада Фурса on 11.02.25.
//

import SwiftUI

struct HomeView: View {
    @State var viewModel = LoginViewModel()
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        Button(action: {
            viewModel.logout()
                    }) {
                        Text("Sign Out")
                            .padding()
                            .background(Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(8.0)
                    }
                }
    }


#Preview {
    HomeView()
}
