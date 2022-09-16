//
//  ProgressView.swift
//  carpool-app
//
//  Created by Brandon Wong on 8/24/22.
//

import SwiftUI
import RealmSwift

struct OpaqueProgressView: View {
    var message: String?

    private enum Dimensions {
        static let padding: CGFloat = 100
        static let bgColor = Color("Clear")
        static let cornerRadius: CGFloat = 16
    }

    init() {
        message = nil
    }

    init(_ message: String?) {
        self.message = message
    }

    var body: some View {
        VStack {
            if let message = message {
                ProgressView(message)
            } else {
                ProgressView()
            }
        }
        .padding(Dimensions.padding)
        .background(.ultraThinMaterial,
                    in: RoundedRectangle(cornerRadius: Dimensions.cornerRadius))
    }
}

struct OpaqueProgressView_Previews: PreviewProvider {
    static var previews: some View {
        OpaqueProgressView("Loading")
    }
}
