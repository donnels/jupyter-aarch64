# jupyter-r-aarch64
Running r on jupyter in docker on arm64/aarch64

## STATUS - Work in Progress (not ready for release yet)
- Base Docker Build working
  - Debian
    - base config for user etc done
- python
  - done
- jupyter
  - installed
- R-base
  - installed

- R installation/config
  - seems to be done (proof is in the pudding)

- running together (smoothly)
    - work in progress
- size optimized
    - to be done

## Requirements
- required: must run on a pinebook pro
- optional: run on a raspi
- optional: run on a (new) mac

## Backstory
I did not like the official R jupyter docker files so I decided to make my own to see how far I get with it. The aim is to run it on the laptop I am typing this on: a pinebook pro. I might revisit Rocker instead of going it on my own.

## Why R?
As R has some good graphing capabilities I would like to explore I decided to understand what it requires to run in order to run it with confidence. R is a good alternative for ingesting data and analysing it.

## Why docker?
Docker helps package things in a stable and repeatable fashion.
While the initial build can take a while to put together it later becomes easier to fix and update and understand.
The alternative of installing large apps on an individual device without docker means having to adapt when installing on another device. 
Docker allows a basic level of portability and abstraction.
### Why mutlistage docker builds
Because I'm tinkering with this it helps to be able to go step by step.
multistage docker allows this approach so that errors in one part of the build can more easily be fixed and the interim containers can be built and looked at individually if required. Also later when one has finished tinkering multistage allows products from individual stages to be exported to the next stage a opposed to the full build environment being present in the end product.

## Why Jupyter?
Similar to docker it allows a simple form of abstraction and portability.
Also Jupyter tends to support tinkering with data and languages so that it lends itself to learning and data science.
