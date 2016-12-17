#!/bin/bash

/usr/local/bin/indexer --all > /var/sphinx/log/indexer.log

echo "Starting Sphinx"
/usr/local/bin/searchd --nodetach

