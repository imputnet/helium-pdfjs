#!/usr/bin/env bash

# Repository paths
_script_path="${BASH_SOURCE[0]:-$0}"
_root_dir="$(dirname "$(greadlink -f "$_script_path")")"
_build_dir="$_root_dir/build"
_src_dir="$_build_dir/src"
_dist_dir="$_build_dir/chromium"
_download_cache="$_build_dir/download_cache"

# pdf.js source archive
_pdfjs_version="$(tr -d '[:space:]' < "$_root_dir/pdfjs_version")"
_pdfjs_tag="v$_pdfjs_version"
_pdfjs_tarball="$_download_cache/pdf.js-$_pdfjs_tag.tar.gz"
_pdfjs_url="https://codeload.github.com/mozilla/pdf.js/tar.gz/refs/tags/$_pdfjs_tag"

# Quilt variables
alias quilt='quilt --quiltrc -'

export QUILT_PATCHES="$_root_dir/patches"

# Options below borrowed from Debian and default quilt options.
export QUILT_PUSH_ARGS="--color=auto"
export QUILT_DIFF_OPTS="--show-c-function"
export QUILT_PATCH_OPTS="--unified --reject-format=unified"
export QUILT_DIFF_ARGS="-p ab --no-timestamps --no-index --color=auto"
export QUILT_REFRESH_ARGS="-p ab --no-timestamps --no-index --strip-trailing-whitespace"
export QUILT_COLORS="diff_hdr=1;32:diff_add=1;34:diff_rem=1;31:diff_hunk=1;33:diff_ctx=35:diff_cctx=33"
export QUILT_SERIES_ARGS="--color=auto"
export QUILT_PATCHES_ARGS="--color=auto"

export LC_ALL=C
if [ -n "${LESS-}" ] && [ -z "${QUILT_PAGER+x}" ]; then
    export QUILT_PAGER="less -FRX"
fi
