#!/usr/bin/env python3

#######################################################################
# convert bnf to mumble lang
#
# Author: Garry Morrison
# email: garry -at- semantic-db.org
# Date: 3/12/2018
# Update: 4/12/2018
# Copyright: GPLv3
#
# Usage: ./bnf-to-mumble.py comma-number.bnf
#
#######################################################################

import sys

if len(sys.argv) < 2:
    print('please specify a filename')
    sys.exit(1)

filename = sys.argv[1]
# print('filename:', filename)


if __name__ == '__main__':

    s = '-- the following code implements this grammar:\n'
    rules = {}
    with open(filename, 'r') as f:
        for line in f:
            line = line.strip()
            s += '-- ' + line + '\n'
            head, tail = line.split(' = ')
            tail = tail.split(' | ')
            tail = [x.split(' . ') for x in tail]
            rules[head] = tail

    s += '\n\n-- define our chomp null operator:\n'
    s += 'chomp |*> #=> |_self>\n'
    s += 'chomp |null> #=> |>\n'

    s += '\n-- define our merge class operator:\n'
    s += 'merge (*) #=> smerge sdrop chomp clean weighted-pick-elt class |_self>\n'

    s += '\n-- define our classes:\n'
    s += 'class |*> #=> remove-suffix[\"\'\"] remove-prefix[\"\'\"] |_self>\n'

    def process_tail(tail):
        tail_type = '=>'
        new_tail = []
        for x in tail:
            elt = None
            if len(x) == 1:
                x = x[0]
                if x == "''":
                    elt = '|null>'
                elif x.startswith("'") and x.endswith("'"):
                    elt = '|%s>' % x[1:-1]
                else:
                    elt = 'merge |%s>' % x
                    tail_type = '#=>'
            else:
                elt = 'merge (|%s>)' % '> . |'.join(x)
                tail_type = '#=>'
            if elt is not None:
                new_tail.append(elt)
        return tail_type, new_tail


    for head, tail in rules.items():
        special_case = False
        for x in tail:
            if head in x:
                special_case = True  # recursion case detected!
                break
        if special_case:
            # s += '  special case:\n'
            s += 'class |%s> #=> process-if if(pick-elt split |yes no>, |unfinished %s>, |finished %s>)\n' % (head, head, head)
            new_tail = []
            special_tail = []
            for x in tail:
                if not head in x:
                    new_tail.append(x)
                else:
                    special_tail.append(x)
            # s += 'new_tail: %s\n' % new_tail
            # s += 'special_tail: %s\n' % special_tail
            tail_type, tail = process_tail(new_tail)
            s += 'process-if |finished %s> %s %s\n' % (head, tail_type, ' + '.join(tail))
            tail_type, tail = process_tail(special_tail)
            s += 'process-if |unfinished %s> %s %s\n' % (head, tail_type, ' + '.join(tail))
        else:
            tail_type, tail = process_tail(tail)
            s += 'class |%s> %s %s\n' % (head, tail_type, ' + '.join(tail))

    print(s)

