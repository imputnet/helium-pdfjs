# Helium PDF.js (WIP)

[PDF.js](https://github.com/mozilla/pdf.js) adapted for the
[Helium Browser](https://github.com/imputnet/helium) as a
browser component.

## Why

Chromium's PDF viewer sucks and is very difficult to build on top of, but we
want to have a good PDF viewing experience in our browser.

Instead of reinventing the wheel, we use the work of talented Mozillians and
fix some rough edges to make it feel at home in Helium.

## How

This repo fetches the expected release tag, patches source files with quilt, and
builds a Chromium extension ready for embedding into Helium.

## Local development and testing

We expect that you work on this extension in a UNIX environment (Linux/macOS).

1. Clone this repo:
    ```
    git clone https://github.com/imputnet/helium-pdfjs
    ```

2. Go to the newly created dir:
    ```
    cd helium-pdfjs
    ```

3. Run the initial setup script to fetch the source code, npm deps, and apply
   patches:
    ```
    source dev.sh
    pdf setup
    ```

4. Create a Chromium extension build:
    ```
    pdf build
    ```

5. For basic testing, import the unpacked extension from `build/chromium` into
   any Chromium-based web browser, such as
   [Helium](https://github.com/imputnet/helium).
   Printing will not work correctly, as it's handled on browser-side, but
   everything else will.

6. All source changes must reside in patches. The sourced environment configures
   quilt, so use regular quilt commands
   directly from `build/src`.

### Working with patches

This repo uses the same quilt environment as the main Helium repos, but with a
single patch series at `patches/series`.

1. Load the dev environment:
    ```
    source dev.sh
    ```

2. Go to the source tree:
    ```
    cd build/src
    ```

3. Use quilt to create or edit a patch:
    ```
    quilt new general/my-change.patch
    quilt add path/to/file.js
    ```

4. Refresh the patch after editing:
    ```
    quilt refresh
    ```

## License

Just like PDF.js itself, this repo is licensed under the
[Apache License 2.0](LICENSE).
