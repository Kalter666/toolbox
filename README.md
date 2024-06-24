# Toolbox

## make_epub.sh

If you have a directory with images and want to create an epub file.

### Requirements

1. [calibre](https://calibre-ebook.com)

2. [imagemagick](https://imagemagick.org)

### Usage

Before you need to make it executable

```bash
chmod +x make_epub.sh
```

#### Parameters

This script supports 3 parameters

1. Source folder
2. sort images for content
3. sort images for cover

#### default

```bash
./make_epub.sh ./path_to/the/source/folder
```

#### Images go in ascending order but the cover in the end

Like 0.jpg, 1.jpg, 2.jpg, ... N.jpg
N.jpg would be the cover

```bash
./make_epub.sh ./path_to/the/source/folder -a -d
```
