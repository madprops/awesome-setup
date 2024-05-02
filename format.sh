#!/usr/bin/env bash

stylua .

cd modules/
stylua .

cd ../madwidgets
stylua .
stylua --glob ./*