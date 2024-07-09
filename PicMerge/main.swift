//
//  main.swift
//  PicMerge
//
//  Created by yanguo sun on 2024/7/9.
//

import Foundation
import CoreGraphics
import ImageIO

func createImageGrid(sourceFolder: String, outputImagePath: String, imagesPerRow: Int, maxWidth: Int = 500) {
    let fileManager = FileManager.default
    let sourceURL = URL(fileURLWithPath: sourceFolder)
    
    // Fetch all image files
    guard let files = try? fileManager.contentsOfDirectory(at: sourceURL, includingPropertiesForKeys: [.nameKey], options: .skipsHiddenFiles) else {
        print("Cannot access contents of \(sourceFolder)")
        return
    }
    
    // Filter and sort files by numeric order of their names
    let imageFiles = files.filter { $0.pathExtension.lowercased() == "jpg" || $0.pathExtension.lowercased() == "jpeg" || $0.pathExtension.lowercased() == "png" }
        .sorted { lhs, rhs in
            lhs.deletingPathExtension().lastPathComponent.compare(rhs.deletingPathExtension().lastPathComponent, options: .numeric) == .orderedAscending
        }

    var images: [CGImage] = []
    var scaledWidths: [Int] = []
    var scaledHeights: [Int] = []
    
    for fileURL in imageFiles {
        if let imageSource = CGImageSourceCreateWithURL(fileURL as CFURL, nil),
           let image = CGImageSourceCreateImageAtIndex(imageSource, 0, nil) {
            let actualWidth = CGFloat(image.width)
            let actualHeight = CGFloat(image.height)
            let scale = CGFloat(maxWidth) / actualWidth  // Always scale to maxWidth
            let newWidth = Int(actualWidth * scale)
            let newHeight = Int(actualHeight * scale)
            images.append(image)
            scaledWidths.append(newWidth)
            scaledHeights.append(newHeight)
        }
    }

    guard !images.isEmpty else {
        print("No images found in directory")
        return
    }

    let maxImageWidth = maxWidth  // Always use maxWidth for consistency in row width
    let maxImageHeight = scaledHeights.max() ?? 0

    let gridWidth = maxImageWidth * imagesPerRow
    let numberOfRows = (images.count + imagesPerRow - 1) / imagesPerRow
    let gridHeight = maxImageHeight * numberOfRows

    let colorSpace = CGColorSpaceCreateDeviceRGB()
    guard let context = CGContext(data: nil, width: gridWidth, height: gridHeight, bitsPerComponent: 8, bytesPerRow: gridWidth * 4, space: colorSpace, bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue) else {
        print("Unable to create graphics context")
        return
    }

    for (index, image) in images.enumerated() {
        let row = index / imagesPerRow
        let col = index % imagesPerRow
        let x = col * maxImageWidth
        let y = (numberOfRows - row - 1) * maxImageHeight // Coordinate system is flipped in Core Graphics
        let width = scaledWidths[index]
        let height = scaledHeights[index]
        context.draw(image, in: CGRect(x: x, y: y, width: width, height: height))
    }

    guard let outputImage = context.makeImage() else {
        print("Failed to create final image")
        return
    }

    let outputURL = URL(fileURLWithPath: outputImagePath)
    guard let destination = CGImageDestinationCreateWithURL(outputURL as CFURL, kUTTypeJPEG, 1, nil) else {
        print("Failed to create image destination")
        return
    }

    CGImageDestinationAddImage(destination, outputImage, nil)
    if !CGImageDestinationFinalize(destination) {
        print("Failed to write image to \(outputImagePath)")
    } else {
        print("Grid image saved to \(outputImagePath)")
    }
}

// Handling command-line arguments
if CommandLine.argc < 5 {
    print("Usage: picmerge sourceFolder outputImagePath imagesPerRow maxWidth")
    exit(1)
}

let sourceFolder = CommandLine.arguments[1]
let outputImagePath = CommandLine.arguments[2]
guard let imagesPerRow = Int(CommandLine.arguments[3]),
      let maxWidth = Int(CommandLine.arguments[4]) else {
    print("Invalid number format for imagesPerRow or maxWidth")
    exit(1)
}

createImageGrid(sourceFolder: sourceFolder, outputImagePath: outputImagePath, imagesPerRow: imagesPerRow, maxWidth: maxWidth)
