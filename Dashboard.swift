import SwiftUI

struct Dashboard: View {
    @State private var progress: CGFloat = 0.6 // Example progress value
    
    var body: some View {
        VStack {
            Spacer()
            
            // Avatar photo
            Image("userProfileImage")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 200, height: 200)
                .clipShape(Circle())
                .padding(.top, 32)
            
            // Progress bar
            ProgressView(value: progress)
                .padding(.top, 16)
            
            Spacer()
            
            // Add your widgets here
            
            Spacer()
        }
        .padding()
    }
}

struct Dashboard_Previews: PreviewProvider {
    static var previews: some View {
        Dashboard()
    }
}
