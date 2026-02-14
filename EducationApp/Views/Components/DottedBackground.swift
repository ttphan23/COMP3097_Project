import SwiftUI

struct DottedBackground: View {
    var body: some View {
        Color.white
            .overlay(
                GeometryReader { geo in
                    let w = geo.size.width
                    let h = geo.size.height
                    Path { path in
                        let step: CGFloat = 22
                        var y: CGFloat = 0
                        while y < h {
                            var x: CGFloat = 0
                            while x < w {
                                path.addEllipse(in: CGRect(x: x, y: y, width: 2.2, height: 2.2))
                                x += step
                            }
                            y += step
                        }
                    }
                    .fill(Color.black.opacity(0.06))
                }
            )
    }
}

#Preview {
    DottedBackground()
}
