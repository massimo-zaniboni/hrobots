# HRobots

HRobots are robots, written in Haskell programming language, that can fight on a virtual arena, provided by NetRobots project at https://github.com/massimo-zaniboni/netrobots

# Installation

## Stack

Install in Debian

    sudo aptitude install libzmq3 libzmq3-dev pkg-config

Build the package under Stack

    stack build

Test if the robot can start without error messages, with

    stack exec hrobots 127.0.0.1 1234 classic test

then press ctr-c because the robot will wait (forever) for the server connection.

## Nix

    ./generate-nix-project.sh
    nix-shell -I . --command 'cabal build'

## Server 

The Netrobots server is on repo https://github.com/massimo-zaniboni/netrobots


