#!/usr/bin/env bash
# Make thumbs

set -euo pipefail

DIR="$( cd "$(dirname $( dirname "${BASH_SOURCE[0]}" ))" && pwd )"
THUMB_DIR="${DIR}/thumbs"
THUMB_INC_DIR="${DIR}/_includes/thumbs"

pathinfo() {
    local infile dir filename ext file
    infile="$1"

    dir="${infile%/*}"
    filename="${infile##*/}"

    ext="${filename##*.}"
    file="${filename%.*}"

    printf '%s %s %s %s\n' "$dir" "$filename" "$file" "$ext"
}

# A sure sign I should have written this in perl
make_name() {
    local title="$@"
    echo $title | \
        tr [:upper:] [:lower:] | \
        tr ' ' '-' | \
        perl -pe 's/[^\w-]+//g' | \
        sed -e 's#--*#-#g'
}

handle_md() {
    local title="$1"
    local description="$2"
    local path="$3"
    local file="$4"
    sed -i \
        -e "s#{{title}}#$title#g" \
        -e "s#{{description}}#$description#g" \
        -e "s#{{path}}#$path#g" \
        "$file"
}

main() {
    local dir filename file ext
    (( $# < 3 )) && {
        echo "usage: $(basename $0) <file-path> <title> <description>"
        exit 1
    }

    local file_path="$1"
    local title="$2"
    local description="$3"

    set -- $(make_name "$title")

    local name="$1"

    "${DIR}"/scripts/make_thumbs "$file_path"

    local src_dir="./.thumbs"

    echo mkdir -p "$THUMB_DIR"
    mkdir -p "$THUMB_DIR"
    echo mkdir -p "${THUMB_DIR}/${name}"
    mkdir -p "${THUMB_DIR}/${name}"
    echo mkdir -p "${THUMB_INC_DIR}"
    mkdir -p "${THUMB_INC_DIR}"

    # Because it's 3 levels...
    for fn in "$src_dir"/*/*/*; do
        set -- $(pathinfo "$fn")
        dir="$1"
        filename="$2"
        file="$3"
        ext="$4"

        echo mv "$fn" "${THUMB_DIR}/${name}/${filename}"
        mv "$fn" "${THUMB_DIR}/${name}/${filename}"

        if [[ "$ext" == "md" ]]; then
            handle_md "$title" "$description" "$name" "${THUMB_DIR}/${name}/${filename}"
            mv "${THUMB_DIR}/${name}/${filename}" "${THUMB_INC_DIR}/${name}.md"
        fi
    done

    rm -rf "$src_dir"
}

main "$@"
