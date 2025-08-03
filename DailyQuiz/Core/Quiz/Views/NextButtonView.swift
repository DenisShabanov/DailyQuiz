import SwiftUI

struct NextButtonView: View {
    let isEnabled: Bool
    let buttonText: String
    let action: () -> Void
    var backgroundColor: Color = Color.theme.accent
    var textColor: Color = Color.theme.white
    
    var body: some View {
        Button {
            action()
        } label: {
            Text(buttonText.uppercased())
                .foregroundStyle(textColor)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .contentShape(Rectangle())
        }
        .padding()
        .frame(width: 280, height: 50)
        .background(
            isEnabled ? backgroundColor : Color.theme.disable
        )
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .disabled(!isEnabled)
    }
}

#Preview {
    struct NextButtonViewPreview: View {
        @State private var isEnabled = false
        
        var body: some View {
            VStack(spacing: 20) {
                NextButtonView(
                    isEnabled: isEnabled,
                    buttonText: "Далее",
                    action: { }
                )
                
                Button("Toggle Enabled") {
                    isEnabled.toggle()
                }
            }
        }
    }
    
    return NextButtonViewPreview()
}
