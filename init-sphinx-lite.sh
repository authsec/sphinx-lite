#!/bin/bash

# Create a static folder that we can rely on from a naming perspective within our mounted container
cd /workspaces
ln -s $(ls /workspaces) docs
