# Adjust the parameters in this file according to your system

VERSION=0.01pre01
DATE=June 06, 2018

# paths
PREFIX= /usr/local
MANPREFIX= $(PREFIX)/share/man

# default output path
SRC= ./src
OUT= ./out

LIBS= -lm
CFLAGS= -D_POSIX_C_SOURCE=200809L -std=c99 -pedantic -Wall -g
CC= gcc
