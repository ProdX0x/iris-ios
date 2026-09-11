// MakeAppIcon.swift
// Tooling (macOS, not part of the app target)
// Purpose: Render the Iris app icon (a six-blade amber diaphragm around a pearl lueur on ink) as a 1024x1024 PNG.
// Usage: swift Tools/MakeAppIcon.swift Resources/Assets.xcassets/AppIcon.appiconset/AppIcon.png

import Foundation
import CoreGraphics
import ImageIO
import UniformTypeIdentifiers

let arguments = CommandLine.arguments
guard arguments.count >= 2 else {
    FileHandle.standardError.write(Data("usage: MakeAppIcon <output.png>\n".utf8))
    exit(1)
}
let side = 1024.0
let colorSpace = CGColorSpaceCreateDeviceRGB()
guard let context = CGContext(data: nil, width: Int(side), height: Int(side), bitsPerComponent: 8, bytesPerRow: 0,
                              space: colorSpace, bitmapInfo: CGImageAlphaInfo.noneSkipLast.rawValue) else { exit(1) }
func hex(_ value: UInt32, alpha: Double = 1) -> CGColor {
    CGColor(colorSpace: colorSpace, components: [Double((value >> 16) & 0xFF) / 255, Double((value >> 8) & 0xFF) / 255, Double(value & 0xFF) / 255, alpha])
        ?? CGColor(gray: 0, alpha: 1)
}
let center = CGPoint(x: side / 2, y: side / 2)

context.setFillColor(hex(0x07080B))
context.fill(CGRect(x: 0, y: 0, width: side, height: side))
if let abyss = CGGradient(colorsSpace: colorSpace, colors: [hex(0x151A25), hex(0x07080B)] as CFArray, locations: [0, 1]) {
    context.drawRadialGradient(abyss, startCenter: center, startRadius: 0, endCenter: center, endRadius: side * 0.62, options: [])
}
// Fibres.
context.setStrokeColor(hex(0xECE7DC, alpha: 0.05))
context.setLineWidth(1.6)
for index in 0..<96 {
    let angle = Double(index) / 96 * 2 * .pi
    context.move(to: CGPoint(x: center.x + cos(angle) * side * 0.2, y: center.y + sin(angle) * side * 0.2))
    context.addLine(to: CGPoint(x: center.x + cos(angle) * side * 0.72, y: center.y + sin(angle) * side * 0.72))
}
context.strokePath()
// Amber halo.
if let halo = CGGradient(colorsSpace: colorSpace, colors: [hex(0xF2B35A, alpha: 0.22), hex(0xF2B35A, alpha: 0)] as CFArray, locations: [0, 1]) {
    context.drawRadialGradient(halo, startCenter: center, startRadius: side * 0.12, endCenter: center, endRadius: side * 0.46, options: [])
}
// Outer ring.
context.setStrokeColor(hex(0xF2B35A, alpha: 0.5))
context.setLineWidth(8)
context.strokeEllipse(in: CGRect(x: center.x - side * 0.3, y: center.y - side * 0.3, width: side * 0.6, height: side * 0.6))
// Six blades.
context.setStrokeColor(hex(0xF2B35A))
context.setLineWidth(46)
context.setLineCap(.round)
let bladeRadius = side * 0.19
for index in 0..<6 {
    let start = (Double(index) * 60 + 18) * .pi / 180
    context.addArc(center: center, radius: bladeRadius, startAngle: start, endAngle: start + 40 * .pi / 180, clockwise: false)
    context.strokePath()
}
// Lueur.
if let glow = CGGradient(colorsSpace: colorSpace, colors: [hex(0xF4EFE4), hex(0xF7E6C4, alpha: 0)] as CFArray, locations: [0, 1]) {
    context.drawRadialGradient(glow, startCenter: center, startRadius: 0, endCenter: center, endRadius: side * 0.09, options: [])
}
context.setFillColor(hex(0xF4EFE4))
context.fillEllipse(in: CGRect(x: center.x - 26, y: center.y - 26, width: 52, height: 52))

guard let image = context.makeImage() else { exit(1) }
let url = URL(fileURLWithPath: arguments[1])
guard let destination = CGImageDestinationCreateWithURL(url as CFURL, UTType.png.identifier as CFString, 1, nil) else { exit(1) }
CGImageDestinationAddImage(destination, image, nil)
guard CGImageDestinationFinalize(destination) else { exit(1) }
print("wrote \(url.path)")
