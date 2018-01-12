#!/bin/bash

# Part 1. If git has not already been configured, do it now.
if ! grep --quiet github ~/.gitconfig; then
    git config --global user.name "${C9_FULLNAME}"
    git config --global user.email $C9_EMAIL
    git config --global credential.helper 'cache --timeout 5400'
    git config --global core.editor '/mnt/shared/sbin/c9 open --wait'
    git config --global credential.https://github.com.username $C9_EMAIL
fi

# Part 2. Commit changes and sync with GitHub.

# This part begins by retrieving all changes to "submodules" from GitHub.
# Submodules are repos within repos. Within repos for student assignments,
# they are used to incorporate various utilities that are re-used across
# many different assignments.

# Next, this script adds all new or modified files in your "working tree"
# to the index or "staging area" of your git repository in c9.

# If anything was added, this script opens a tab for you to edit 
# a commit message for the logs, and pauses until you close the tab.

# If you saved before closing the tab, this script commits the staged 
# files to your c9 repository. (Closing the tab without saving will
# cancel the commit.)

# If the commit succeeds, this script syncs your c9 repository with
# its clone on GitHub.com. You may be asked to enter your GitHub password.
# The sync has two steps. First, this script pulls any changes on GitHub to 
# your c9 repo. If there are changes, you must edit another commit message 
# so that they can be merged into your c9 repository. Then this script pushes 
# changes from your c9 repository to GitHub.

cd ..

git submodule update --remote

git add --all && git commit && git pull && git push && echo Success!

# Part 3. Activating eslint configuration.

# eslint is the code checking tool that displays icons in the margin of your
# c9 editor. Some git repos contain a `.eslintrc` file that sets configuration
# options for the tool. Unfortunately, c9 wants that file to be up one level
# in the file tree in order to apply it to the entire project. If there is a
# .eslintrc file in this repo AND no .eslintrc file exists one level up, this
# script creates a "soft link" (shortcut) in the parent folder, pointing to 
# the .eslintrc file. This activates it for everything down the file tree.

if [ -e './.eslintrc' ]
then
    if [ ! -e '../.eslintrc' ]
    then
        ln -s `pwd`/.eslintrc ../.eslintrc
    fi
fi