import os

import vim


def ftdetect():
    path = vim.current.buffer.name
    while path != os.path.dirname(path):
        path = os.path.dirname(path)
        if ('.obsidian' in os.listdir(path)
                and os.path.isdir(os.path.join(path, '.obsidian'))):
            vim.command('setlocal filetype=obsidian_markdown')
            break
