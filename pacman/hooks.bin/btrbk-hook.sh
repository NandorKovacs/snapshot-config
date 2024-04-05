#!/bin/sh

Green='\033[0;32m'
NC='\033[0m'
Grey='\033[0;35m'
echo -e "${Green}\n-------btrbk-------${Grey}"

btrbk snapshot --format table --override=snapshot_create=always

echo -e "${Green}-------done--------\n${NC}"


