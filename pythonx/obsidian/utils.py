import vim


def get_syntax_region_name(crow, ccol):
    """
    ``crow``, ``ccol`` should be the value returned by ``window.cursor``.
    """
    return vim.eval('synIDattr(synID({}, {}, 0), "name")'.format(crow, ccol + 1))
