#!/usr/bin/env python3

#######################################################################
# q-learn and then q-walk the frozen lake
# data here: https://github.com/openai/gym/blob/master/gym/envs/toy_text/frozen_lake.py
#
# Author: Garry Morrison
# email: garry -at- semantic-db.org
# Date: 8/9/2018
# Update: 8/9/2018
# Copyright: GPLv3
#
# Usage: ./q-walk-lake.py
#
#######################################################################

from semantic_db import *

# switch off debug and info by default:
logger.setLevel(logging.WARNING)

MAPS = {
    "4x4": [
        "SFFF",
        "FHFH",
        "FFFH",
        "HFFG"
    ],
    "8x8": [
        "SFFFFFFF",
        "FFFFFFFF",
        "FFFHFFFF",
        "FFFFFHFF",
        "FFFHFFFF",
        "FHHFFFHF",
        "FHFFHFHF",
        "FFFHFFFG"
    ],
}


def load_map(context, map):
    w = 0
    h = len(map)
    for line in map:
        w = max(w, len(line))

    value_dict = {}
    value_dict[''] = '0'
    value_dict[' '] = '0'
    value_dict['S'] = '0'
    value_dict['F'] = '0'
    value_dict['H'] = '-1'
    value_dict['G'] = '1'

    def ket_elt(j, i):
        return ket('grid: %s: %s' % (j, i))

    # Makes use of the fact that context.learn() ignores rules that are the empty ket |>.
    def ket_elt_bd(j, i, I, J):
        # finite universe model:
        if i <= 0 or j <= 0 or i > I or j > J:
            return ket()
        # torus model:
        #  i = (i - 1)%I + 1
        #  j = (j - 1)%J + 1
        return ket_elt(j, i)

    goal_states = superposition()
    for j in range(1, h + 1):
        for i in range(1, w + 1):
            elt = ket_elt(j, i)
            try:
                value = map[j-1][i-1]
                reward = value_dict[value]
            except:
                value = ''
                reward = '0'
            context.learn('reward', elt, reward)
            if value in ('H', 'G'):  # if find terminating grid elements:
                context.learn('step', elt, elt)
                goal_states.add(elt.label)
            else:
                context.add_learn('step', elt, ket_elt_bd(j - 1, i, h, w))
                # context.add_learn('step', elt, ket_elt_bd(j - 1, i + 1, h, w))
                context.add_learn('step', elt, ket_elt_bd(j, i + 1, h, w))
                # context.add_learn('step', elt, ket_elt_bd(j + 1, i + 1, h, w))
                context.add_learn('step', elt, ket_elt_bd(j + 1, i, h, w))
                # context.add_learn('step', elt, ket_elt_bd(j + 1, i - 1, h, w))
                context.add_learn('step', elt, ket_elt_bd(j, i - 1, h, w))
                # context.add_learn('step', elt, ket_elt_bd(j - 1, i - 1, w, w))
    return h, w, goal_states


if __name__ == '__main__':
    context = NewContext('frozen lake')

    # h, w, goal_states = load_map(context, MAPS['4x4'])
    h, w, goal_states = load_map(context, MAPS['8x8'])
    print('rewards:')
    display_map(context, h, w, 'reward')
    q_learn(goal_states, context, 4000, 1, 0.8, 'step')
    # sa: table[transition, norm-Q] ket-sort rel-kets[norm-Q]
    transitions = context.relevant_kets('norm-Q').ket_sort()
    pretty_print_table(transitions, context, 'transitions', 'norm-Q')

    start = ket('grid: 1: 1')
    steps = q_walk(start, context)
    print('steps: %s\n' % steps)
    for k, x in enumerate(steps):
        context.learn('path', x.to_ket(), str(k+1))
    print('path:')
    display_map(context, h, w, 'path')
    # context.save('sw-examples/frozen-lake-%s-%s.sw' % (h, w))
