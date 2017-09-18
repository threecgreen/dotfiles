#!/bin/bash
function f() {
    sleep "$!"
    echo "$1"
}

while [ -n "$1" ]
do
    f "$1" &
    shift
done
wait

