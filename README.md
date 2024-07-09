
# PicMerge

PicMerge is a Swift command-line tool designed to create a single, seamless image grid from multiple images. This tool automatically scales images to a specified width and arranges them in a grid format, making it ideal for quick visual compilations.

## Features

- **Automatic Scaling**: Scales all images to a uniform width.
- **Customizable Grid Layout**: Specify the number of images per row.
- **Supports Multiple Formats**: Works with JPEG and PNG image files.

## Requirements

- macOS 10.15 or later.
- Swift 5.3 or later.
- Xcode or Swift command-line tools installed.

## Installation

1. Clone the repository to your local machine:
   ```bash
   git clone https://github.com/dacaiguoguo/PicMerge.git
   ```
2. Navigate to the project directory:
   ```bash
   cd PicMerge
   ```
   
3. build
```
swiftc main.swift -framework CoreGraphics -framework ImageIO -framework UniformTypeIdentifiers -o picmerge
```

## Usage

To use PicMerge, you need to provide the source folder where your images are stored, the output path for the resulting image, and the number of images per row in the grid. Optionally, you can specify the maximum width for each image.

### Basic Command

```bash
picmerge sourceFolder outputImagePath imagesPerRow maxWidth
```

### Command Parameters

- `sourceFolder`: The directory path that contains the images.
- `outputImagePath`: The path where the grid image will be saved.
- `imagesPerRow`: The number of images in each row of the grid.
- `maxWidth` (optional): The maximum width for each image in the grid. Default is 500 pixels.

### Example

```bash
Usage: PicMerge sourceFolder outputImagePath imagesPerRow maxWidth
```

This command will process images located in `/path/to/images`, arrange them in rows of 5 images each, scale each image to a width of 500 pixels, and save the resulting grid image to `/path/to/output/image.jpg`.

## Notes

- Ensure that the images are named in a way that reflects their desired order in the grid, as the tool sorts images numerically based on their filenames.
- The grid layout is calculated based on the image dimensions and the number of images per row, so the final image size may vary.

## Contributing

Contributions to improve PicMerge are welcome. Feel free to fork the repository and submit pull requests.

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE) file for details.
