#!/usr/bin/env python3
import os

import vim


def reload_syntax_if_under_obsidian_vault():
    if get_obv_basedir():
        vim.command('let b:under_obsidian_vault = 1')
        vim.command('syntax on')


def get_obv_basedir():
    path = vim.current.buffer.name
    while path != os.path.dirname(path):
        path = os.path.dirname(path)
        if ('.obsidian' in os.listdir(path)
                and os.path.isdir(os.path.join(path, '.obsidian'))):
            return path
    return ''
