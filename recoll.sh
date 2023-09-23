#!/usr/bin/env sh

# ---------------------
#   David Lima - 2023
# github.com/davidolima
# ---------------------

GREET_STR="What are you looking for?"
FILES_FOUND_STR=" files found."
VALID_FILE_REGEX="[\x{0080}-\x{00ff}]|[a-zA-Z0-9]|\.|_|-| |\(|\)"

echo -en "\0prompt\x1frecoll\n"

if [ ! -z "$@" ]
then
    # Get query results
    QUERY=$@
    if [[ "$@" == file://*  ]]
    then
        xdg-open "${QUERY:7}" > /dev/null 2>&1
        exec 1>&-
        exit;
    fi

    RESULTS=$(recoll -t -q $QUERY)

    # Print how many files were found
    N_FILES=$(recoll -t -q "$QUERY" | awk -e '$0 ~ /^[0-9]+/ {print $1}')
    echo $N_FILES$FILES_FOUND_STR

    # List found files
    echo "$RESULTS" | tail -n +3 | while read -r l; do
        ftype=$(echo "$l" | awk -e '$0 ~ /^[a-z]+\/[a-z]+\s/ { print $1 }')
        fpath=$(echo "$l" | grep -Po "file://($VALID_FILE_REGEX|/)+")
        #fname=$(echo "$fpath" | awk -F '/' "/$VALID_FILE_REGEX\.[a-zA-Z]+$/ { print }" )
        echo $fpath
    done
else
    echo $GREET_STR
fi
