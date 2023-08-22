#!/usr/bin/env python3
import re

import vim

from obsidian import utils


def try_syn_region_with_offsets(crow, ccol, offsets, target_names):
    """
    Invalid offsets are silently ignored.

    :param crow: current cursor row number
    :param ccol: current cursor column number
    :param offsets: the offsets on ``ccol`` to try evaluating the syntax
           region name
    :param target_name: the region names to find
    :return: the column number where the ``target_name`` is first found, plus
             the found target name; if it's never found, return ``None``
    """
    for o in offsets:
        syn_name = utils.get_syntax_region_name(crow, ccol + o)
        if syn_name in target_names:
            return ccol + o, syn_name
    return None


def get_wikilink():
    """
    Returns the wikilink if the cursor is over a wikilink.
    Otherwise returns empty string.
    """
    cline = vim.current.line
    crow, ccol = vim.current.window.cursor
    syn_name = utils.get_syntax_region_name(crow, ccol)
    if syn_name == 'mkdWikiLink':
        pass
    # for a wikilink:          [[hello|world]]
    #                          ^^     ^     ^^
    # for another:             [[h]]
    #                          ^^ ^^
    # carets point out our possible locations;
    elif syn_name == 'mkdDelimiter':
        offsets = [2, 1, -1, -2]
        res = try_syn_region_with_offsets(crow, ccol, offsets,
                                          ['mkdWikiLink', 'mkdWikiAltName'])
        if res is None:
            return ''
        ccol, syn_name = res
        # now syn_name is one of 'mkdWikiLink' and 'mkdWikiAltName'
    if syn_name == 'mkdWikiAltName':
        ccol = cline.rfind('|', 0, ccol + 1)
        if ccol == -1:
            return ''
        ccol -= 1
        syn_name = utils.get_syntax_region_name(crow, ccol)
        if syn_name != 'mkdWikiLink':
            return ''
    # if reached here, the (crow, ccol) is over one of the characters in a
    # wikilink
    left_boundary = cline.rfind('[[', 0, ccol)
    right_boundary1 = cline.find(']]', ccol)
    right_boundary2 = cline.find('|', ccol)
    if right_boundary1 != -1 and right_boundary2 != -1:
        right_boundary = min(right_boundary1, right_boundary2)
    elif right_boundary1 != -1:
        right_boundary = right_boundary1
    elif right_boundary2 != -1:
        right_boundary = right_boundary2
    else:
        right_boundary = -1
    if left_boundary != -1 and right_boundary != -1:
        return cline[left_boundary + 2:right_boundary]
    return ''


def test_get_wikilink():
    print(repr(get_wikilink()))

def test_syn_name():
    crow, ccol = vim.current.window.cursor
    print(repr(utils.get_syntax_region_name(crow, ccol)))
