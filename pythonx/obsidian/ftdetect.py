#!/usr/bin/env python3
import os

import vim


def ftdetect():
    path = vim.current.buffer.name
    while path != os.path.dirname(path):
        path = os.path.dirname(path)
        if ('.obsidian' in os.listdir(path)
                and os.path.isdir(os.path.join(path, '.obsidian'))):
            vim.command('let b:under_obsidian_vault = 1')
            vim.command('syntax on')
            break
