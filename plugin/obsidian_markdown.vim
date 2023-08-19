let s:plugin_root_dir = fnamemodify(resolve(expand('<sfile>:p')), ':h')

py3 << EOF
import sys
import os
import vim

__obsidian_vim_plugin_rootdir = vim.eval('s:plugin_root_dir')
__obsidian_vim_py_rootdir = os.path.join(
    __obsidian_vim_plugin_rootdir, 'python3')
sys.path.append(__obsidian_vim_py_rootdir)
EOF
