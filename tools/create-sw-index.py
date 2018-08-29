#!/usr/bin/env python

#######################################################################
# create sw index
#
# Author: Garry Morrison
# email: garry -at- semantic-db.org
# Date: 28/8/2018
# Update: 28/8/2018
# Copyright: GPLv3
#
# Usage: ./create-sw-index.py dir-to-sw-files
# it will dump two files in current directory:
# sw-index.txt and index.html
# then you need to upload these to your web host, along with your sw files
# Now you can run this command from the semantic-db shell:
#
#   web-files http://your-host.org/path-to-sw-files/
#
#######################################################################

import os
import sys
import glob
# tighten this up so we only import extract_sw_stats() from code.py:
from semantic_db import *

sw_file_dir = sys.argv[1]

if __name__ == "__main__":
    sep = "   "
    max_len = 0
    data = []
    for file in sorted(glob.glob(sw_file_dir + "/*.swc") + glob.glob(sw_file_dir + "/*.sw")):
        base = os.path.basename(file)
        max_len = max(max_len, len(base))
        data.append([base, extract_sw_stats(file)])

    # write out sw-index.txt
    with open('sw-index.txt', 'w') as f:
        for file, stats in data:
            f.write('  ' + file.ljust(max_len) + sep + stats + '\n')

    # define index.html header and footer:
    header = """
<html>
<head><title>sw examples</title></head>
Some sample sw files.
<pre>
sa: files

"""
    footer = """
</pre>
<hr>
Last updated: %s
</body>
</html>
""" % datetime.date.today().strftime("%B %d, %Y")

    # write out index.html
    with open('index.html', 'w') as f:
        f.write(header)
        for file, stats in data:
            f.write('  <a href="%s">%s</a>%s%s%s\n' % (file, file, ''.ljust(max_len - len(file)), sep, stats))
        f.write(footer)

    # dump to screen too:
    print()
    for file, stats in data:
        print("  " + file.ljust(max_len) + sep + stats)
