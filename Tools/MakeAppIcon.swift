// MakeAppIcon.swift
// Tooling (macOS, not part of the app target)
// Purpose: Render the Iris app icon (an amber iris on a dark ground) as a 1024x1024 PNG with CoreGraphics.
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
                              space: colorSpace, bitmapInfo: CGImageAlphaInfo.noneSkipLast.rawValue) else {
    FileHandle.standardError.write(Data("cannot create context\n".utf8))
    exit(1)
}
func rgb(_ r: Double, _ g: Double, _ b: Double, _ a: Double = 1) -> CGColor {
    CGColor(colorSpace: colorSpace, components: [r, g, b, a]) ?? CGColor(gray: 0, alpha: 1)
}
func hex(_ value: UInt32, alpha: Double = 1) -> CGColor {
    rgb(Double((value >> 16) & 0xFF) / 255, Double((value >> 8) & 0xFF) / 255, Double(value & 0xFF) / 255, alpha)
}
let center = CGPoint(x: side / 2, y: side / 2)

// Ground: deep warm black with a faint amber glow rising from the bottom (horizon feeling).
context.setFillColor(hex(0x0F1013))
context.fill(CGRect(x: 0, y: 0, width: side, height: side))
if let glow = CGGradient(colorsSpace: colorSpace, colors: [hex(0xE7A43B, alpha: 0.22), hex(0xE7A43B, alpha: 0.0)] as CFArray, locations: [0, 1]) {
    context.drawRadialGradient(glow, startCenter: CGPoint(x: side / 2, y: side * 0.30), startRadius: 0,
                               endCenter: CGPoint(x: side / 2, y: side * 0.30), endRadius: side * 0.75, options: [])
}
// Horizon hairline.
context.setStrokeColor(hex(0xFFFFFF, alpha: 0.06))
context.setLineWidth(3)
context.move(to: CGPoint(x: 0, y: side * 0.34))
context.addLine(to: CGPoint(x: side, y: side * 0.34))
context.strokePath()

// Iris: outer amber halo, ring, fibres, pupil.
let outerRadius = side * 0.34
if let halo = CGGradient(colorsSpace: colorSpace, colors: [hex(0xE7A43B, alpha: 0.55), hex(0xE7A43B, alpha: 0.0)] as CFArray, locations: [0, 1]) {
    context.drawRadialGradient(halo, startCenter: center, startRadius: outerRadius * 0.92, endCenter: center, endRadius: outerRadius * 1.28, options: [])
}
if let iris = CGGradient(colorsSpace: colorSpace,
                         colors: [hex(0x2A1A08), hex(0xB8791C), hex(0xE7A43B), hex(0xF3C46B)] as CFArray,
                         locations: [0.0, 0.45, 0.85, 1.0]) {
    context.saveGState()
    context.addEllipse(in: CGRect(x: center.x - outerRadius, y: center.y - outerRadius, width: outerRadius * 2, height: outerRadius * 2))
    context.clip()
    context.drawRadialGradient(iris, startCenter: center, startRadius: 0, endCenter: center, endRadius: outerRadius, options: [])
    context.restoreGState()
}
// Fibres.
context.saveGState()
context.setLineWidth(2.2)
for index in 0..<96 {
    let angle = Double(index) / 96 * .pi * 2
    let jitter = sin(Double(index) * 12.9898) * 0.5 + 0.5
    let inner = outerRadius * (0.42 + jitter * 0.08)
    let outer = outerRadius * (0.96 - jitter * 0.06)
    context.setStrokeColor(hex(0x14110A, alpha: 0.22 + jitter * 0.2))
    context.move(to: CGPoint(x: center.x + cos(angle) * inner, y: center.y + sin(angle) * inner))
    context.addLine(to: CGPoint(x: center.x + cos(angle) * outer, y: center.y + sin(angle) * outer))
    context.strokePath()
}
context.restoreGState()
// Outer rim.
context.setStrokeColor(hex(0x14110A, alpha: 0.9))
context.setLineWidth(10)
context.strokeEllipse(in: CGRect(x: center.x - outerRadius, y: center.y - outerRadius, width: outerRadius * 2, height: outerRadius * 2))
// Pupil.
let pupilRadius = outerRadius * 0.40
context.setFillColor(hex(0x0B0B0E))
context.fillEllipse(in: CGRect(x: center.x - pupilRadius, y: center.y - pupilRadius, width: pupilRadius * 2, height: pupilRadius * 2))
// Specular highlight (top-left, matching the in-game sphere lighting).
if let spec = CGGradient(colorsSpace: colorSpace, colors: [hex(0xFFFFFF, alpha: 0.85), hex(0xFFFFFF, alpha: 0.0)] as CFArray, locations: [0, 1]) {
    let specCenter = CGPoint(x: center.x - pupilRadius * 0.45, y: center.y + pupilRadius * 0.45)
    context.drawRadialGradient(spec, startCenter: specCenter, startRadius: 0, endCenter: specCenter, endRadius: pupilRadius * 0.42, options: [])
}
guard let image = context.makeImage() else { exit(1) }
let url = URL(fileURLWithPath: arguments[1])
guard let destination = CGImageDestinationCreateWithURL(url as CFURL, UTType.png.identifier as CFString, 1, nil) else { exit(1) }
CGImageDestinationAddImage(destination, image, nil)
guard CGImageDestinationFinalize(destination) else { exit(1) }
print("wrote \(url.path)")
