# Docker Robot Framework AppiumSikuliLibrary

Docker image for running Robot Framework with AppiumSikuliLibrary and Xorg configuration.

**Project:** [GitHub Repository](https://github.com/thinhdnn/robotframework-AppiumSikuliLibrary)

**PyPI:** [robotframework-AppiumSikuliLibrary on PyPI](https://pypi.org/project/robotframework-AppiumSikuliLibrary)

## Introduction

This Docker image provides an environment for running Robot Framework with the AppiumSikuliLibrary, along with Xorg configuration. It's a convenient way to set up and execute your Robot Framework tests that involve Sikuli-based automation.

## Features

- Includes the Sikuli - AppiumSikuliLibrary for Robot Framework.
- Allows the addition of custom fonts through the "font" folder.
- Xorg configuration stored in "xorg.conf" for Xfb configuration.

## Configs
- xfvb: 1920x1080x24 with DPI 96 .You can change in Dockerfile and robot.sh

## Usage

To use this Docker image, you can run the following command:

```shell
docker run --rm -it -v /project-folder:/data xpra "TestSuit-Path"
