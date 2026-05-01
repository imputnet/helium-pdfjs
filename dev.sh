#!/usr/bin/env bash

_script_path="${BASH_SOURCE[0]:-$0}"
_root_dir="$(dirname "$(greadlink -f "$_script_path")")"
source "$_root_dir/env.sh"

___helium_pdfjs_require() {
    local command_name="$1"

    if ! command -v "$command_name" >/dev/null 2>&1; then
        echo "error: missing dependency: $command_name" >&2
        return 1
    fi
}

___helium_pdfjs_download() {
    ___helium_pdfjs_require curl
    ___helium_pdfjs_require tar

    mkdir -p "$_download_cache"
    if [ ! -f "$_pdfjs_tarball" ]; then
        curl -L "$_pdfjs_url" -o "$_pdfjs_tarball"
    fi

    rm -rf "$_src_dir"
    mkdir -p "$_src_dir"
    tar -xzf "$_pdfjs_tarball" -C "$_src_dir" --strip-components=1
}

___helium_pdfjs_deps() {
    ___helium_pdfjs_require npm

    cd "$_src_dir"
    npm install
}

___helium_pdfjs_push() {
    ___helium_pdfjs_require quilt

    cd "$_src_dir"
    quilt push -a --refresh
}

___helium_pdfjs_setup() {
    if [ -d "$_src_dir" ]; then
        echo -e "Source directory already exists at $_src_dir.\n" \
                "Run 'pdf reset' to remove it and start fresh." >&2
        return
    fi
    ___helium_pdfjs_download
    ___helium_pdfjs_deps
    ___helium_pdfjs_push
}

___helium_pdfjs_build() {
    ___helium_pdfjs_require npx

    cd "$_src_dir"
    npx gulp chromium

    rm -rf "$_dist_dir"
    mkdir -p "$(dirname "$_dist_dir")"
    cp -R "$_src_dir/build/chromium" "$_dist_dir"
}

___helium_pdfjs_reset() {
    if [ -d "$_src_dir" ]; then
        if mv "$_src_dir" "${_src_dir}x"; then
            rm -rf "${_src_dir}x" &
        fi
    fi

    if [ -d "$_dist_dir" ]; then
        if mv "$_dist_dir" "${_dist_dir}x"; then
            rm -rf "${_dist_dir}x" &
        fi
    fi
}

__helium_pdfjs_menu() {
    set -e

    case "${1-}" in
        setup) ___helium_pdfjs_setup;;
        build) ___helium_pdfjs_build;;
        reset) ___helium_pdfjs_reset;;

        *)
            echo "usage: pdf <command>" >&2
            echo "\tsetup - download pdf.js, install npm deps, and apply patches" >&2
            echo "\tbuild - build the Chromium extension into build/chromium" >&2
            echo "\treset - remove build/src and build/chromium" >&2
            ;;
    esac
}

pdf() {
    (__helium_pdfjs_menu "$@")
}

if ! (return 0 2>/dev/null); then
    printf "usage:\n\t$ source dev.sh\n\t$ pdf\n" 2>&1
    exit 1
else
    if [ "$__tooling_loaded" = "" ]; then
        __tooling_loaded=1
        PS1="📄 $PS1"
    fi
fi
