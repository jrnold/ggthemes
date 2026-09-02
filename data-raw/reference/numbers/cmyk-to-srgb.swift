// Convert the device-CMYK colors found in Numbers' .sfccolor.plist files to
// sRGB the way macOS itself does, via ColorSync.
//
// A naive `1 - x` conversion is materially wrong here: Numbers' "Blue" series
// 1 is #5E86B8 through ColorSync but #5EA3FF naively.
//
// Reads one "c m y k" quadruple per line on stdin, writes one "#RRGGBB" per
// line on stdout, so the R stage can convert every color in a single call.
//
// Usage: swift cmyk-to-srgb.swift < quadruples.txt

import AppKit

while let line = readLine(strippingNewline: true) {
    let trimmed = line.trimmingCharacters(in: .whitespaces)
    if trimmed.isEmpty { continue }

    let parts = trimmed.split(separator: " ").compactMap { Double($0) }
    guard parts.count == 4 else {
        FileHandle.standardError.write(
            "expected 4 numbers, got: \(line)\n".data(using: .utf8)!)
        exit(1)
    }

    let device = NSColor(deviceCyan: CGFloat(parts[0]),
                         magenta: CGFloat(parts[1]),
                         yellow: CGFloat(parts[2]),
                         black: CGFloat(parts[3]),
                         alpha: 1)
    guard let srgb = device.usingColorSpace(.sRGB) else {
        FileHandle.standardError.write(
            "could not convert to sRGB: \(line)\n".data(using: .utf8)!)
        exit(1)
    }

    let r = Int((srgb.redComponent * 255).rounded())
    let g = Int((srgb.greenComponent * 255).rounded())
    let b = Int((srgb.blueComponent * 255).rounded())
    print(String(format: "#%02X%02X%02X", r, g, b))
}
