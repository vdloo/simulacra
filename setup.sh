#!/bin/bash
mkdir -p lib
cd lib

# Import the latest version of jobrunner into this repo
if [ -d jobrunner ]; then
    echo "Ensuring jobrunner is the latest version"
    cd jobrunner
    git clean -xfd
    git pull origin master || /bin/true
    git reset --hard origin/master
    cd ..
else
    echo "Creating a new checkout of jobrunner"
    git clone https://github.com/vdloo/jobrunner
fi;
cd ..

# Link the jobrunner modules to the main project
find lib/jobrunner/ -maxdepth 1 -mindepth 1 -type d | while read line; do
    echo "Ensuring $(basename $line) is linked to the main project"
    test -d "$(basename $line)" || ln -s "$line" ./
done

# Link the jobrunner top level files to the main project
find lib/jobrunner/ -maxdepth 1 -mindepth 1 -type f | while read line; do
    echo "Ensuring $(basename $line) is linked to the main project"
    test -e "$(basename $line)" || ln -sf "$line" ./
done

# Link project jobs plugin into the jobrunner flows module
echo "Ensuring ./simulacra is linked to ./flows/simulacra"
test -d ./flows/simulacra || ln -s ../../../simulacra ./flows/
