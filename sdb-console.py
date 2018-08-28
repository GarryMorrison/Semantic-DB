#!c:/Python34/python.exe 

#######################################################################
# the semantic-db console
#
# Author: Garry Morrison
# email: garry -at- semantic-db.org
# Date: 2014
# Update: 28/8/2018
# Copyright: GPLv3
#
# Usage: ./sdb-console.py [--debug | --info] [-q] [-i] [--version] [file1.sw ... filen.sw]
#
#######################################################################

import sys
import glob
import os
import datetime
import time
import urllib.request
import getopt

try:
    from graphviz import Digraph
    have_graphviz = True
except ImportError:
    have_graphviz = False

# import logging

from semantic_db import *
from semantic_db.usage_tables import usage

# parse our command line parameters:
try:
    optlist, args = getopt.getopt(sys.argv[1:], 'qidV', ['debug', 'info', 'quiet', 'interactive', 'dump', 'version'])
except getopt.GetoptError as err:
    print(err)
    sys.exit(2)

# switch on/off display of command execution times:
quiet = False

# interactive mode:
interactive = False

# switch off debug and info by default:
logger.setLevel(logging.WARNING)

# dump loaded files:
dump = False

# process our option list:
for o, a in optlist:
    if o == '--info':
        logger.setLevel(logging.INFO)
        logger.info('info enabled')
    elif o == '--debug':
        logger.setLevel(logging.DEBUG)
        logger.debug('debug enabled')
    elif o in ('-q', '--quiet'):
        quiet = True
    elif o in ('-i', '--interactive'):
        interactive = True
    elif o in ('-d', '--dump'):
        dump = True
    elif o in ('-V', '--version'):
        print('Semantic DB 2.0')
        sys.exit(0)

# arguments become files to run:
files_to_run = args

# not sure we want this:
if len(files_to_run) == 0:
    interactive = True


# starting .sw directory:
sw_file_dir = "sw-examples"
# check it exists, if not create it:
if not os.path.exists(sw_file_dir):
    print("Creating %s directory." % sw_file_dir)
    os.makedirs(sw_file_dir)

dot_file_dir = 'graph-examples'

if interactive:
    print("Welcome to version 2.0 of the Semantic DB!\nLast updated 28 August, 2018")
    print("To see remote sw files, run:\n\n  web-files http://semantic-db.org/sw/")

# context = ContextList("sw console")  # currently broken, due to parsley binding dict issue.
# C = context

help_string = """
  q, quit, exit                         quit the agent.
  h, help                               print this message
  context                               print list of context's
  context string                        set current context to string
  icontext                              interactive context
  reset                                 reset back to completely empty console
                                        Warning! you will lose all unsaved work!
  dump                                  print current context
  dump exact                            print current context in exact mode
  dump multi                            print context list
  dump self                             print what we know about the default ket/sp
  dump ket/sp                           print what we know about the given ket/sp
  display                               (relatively) readable display of current context
  display ket/sp                        (relatively) readable display about what we know for the ket/sp
  freq                                  convert current context to frequency list
  mfreq                                 convert context list to frequency list
  web-load http://file.sw               load a sw file from the web
  load file.sw                          load file.sw
  line-load file.sw                     load file.sw one line at a time, useful for large files, breaks for swc files.
  save file.sw                          save current context to file.sw
  save multi file.sw                    save context list to file.sw
  save-as-dot file.dot                  save current context in dot format to file.dot
  files                                 show the available .sw files
  web-files http://semantic-db.org/sw/  show the available .sw files on remote site
  cd                                    change and create if necessary the .sw directory
  ls, dir, dirs                         show the available directories
  create inverse                        create inverse for current context
  create multi inverse                  create inverse for all context in context list
  x = foo: bah                          set x (the default ket) to |foo: bah>
  id                                    display the default ket/superposition
  s, store                              set x to the result of the last computation
  .                                     repeat last computation
  i                                     interactive history
  history                               show last 30 commands
  history n                             show last n commands
  save history                          save console history to file
  debug on                              switch verbose debug messages on
  debug off                             switch debug messages off
  info on                               switch info messages on
  info off                              switch info messages off
  -- comment                            ignore, this is just a comment line.
  usage                                 show list of usage information
  usage op1, op2, op3                   show usage of listed operators
  if none of the above                  process_input_line(context, line, x)
"""

x = ket()
result = ket()
stored_line = ""
command_history = []
command_history_len = 1000
command_history_file = "sa-console-command-history.txt"  # file where we save the command history. Might be interesting.


# our display time intervals:
intervals = (
    ('weeks', 604800000),  # 1000 * 60 * 60 * 24 * 7
    ('days', 86400000),  # 1000 * 60 * 60 * 24
    ('hours', 3600000),  # 1000 * 60 * 60
    ('minutes', 60000),  # 1000 * 60
    ('seconds', 1000),  # 1000
    ('milliseconds', 1),
)


# our display time function:
def display_time(seconds):
    ms = int(1000 * seconds)
    result = []

    for name, count in intervals:
        value = ms // count
        if value:
            ms -= value * count
            if value == 1:
                name = name.rstrip('s')
            result.append("%s %s" % (value, name))
    if len(result) == 0:
        return "0"
    return ', '.join(result)


# save history function:
def save_history(history, history_file):
    print("saving history ... ")
    try:
        f = open(history_file, 'a')
        today = str(datetime.date.today())
        f.write(today + "\n")
        for line in history:
            f.write("  %s\n" % line)
        f.write("\n")
        f.close()
        print("Done.")
    except:
        print("failed!")


# load history from file:
try:
    tmp_history = []
    with open(command_history_file, 'r') as f:
        for line in f:
            if line.startswith('  '):  # filter out date-lines, which don't start with two spaces.
                line = line.strip()
                tmp_history.append(line)
    command_history = tmp_history[-command_history_len:]
except FileNotFoundError:
    pass


# run our command line files:
for sw_file in files_to_run:
    path, file = os.path.split(sw_file)
    if path == "":
        path = sw_file_dir
    full_name = path + '/' + file
    command_history.append('load ' + file)
    context.load(full_name)


# dump our ContextList:
if dump and len(files_to_run) > 0:
    context.print_multiverse()

if not interactive:
    sys.exit(0)


# define our web-load() function:
def web_load(url):
    # find the sw file name:
    name = url.split("/")[-1]
    dest = sw_file_dir + "/" + name  # if sw_file_dir is '', then it puts it in root directory! Fix!

    dont_save = False
    # check if it exists:
    while os.path.exists(dest):
        # either rename or overwrite
        check = input("\n  File \"%s\" already exists.\n  [O]verwrite, [R]ename or [D]on't save? (O,R,D): " % name)
        if len(check) > 0:
            if check[0] in ["o", "O"]:  # we are allowed to overwrite it
                break
            if check[0] in ["d", "D"]:  # don't save the file
                dont_save = True
                break
            elif check[0] in ["r", "R"]:  # we have to choose a new name
                check = input("\n  New name: ")
                if len(check) > 0:
                    name = check
                    dest = sw_file_dir + "/" + name
    print()

    if not quiet:
        start_time = time.time()

    # check if we don't want to save:
    if not dont_save:
        try:
            # download url
            print("downloading sw file:", url)  # code to time the download? Probably, eventually.
            headers = {'User-Agent': 'semantic-agent/2.0'}
            req = urllib.request.Request(url, None, headers)  # does it handle https?
            f = urllib.request.urlopen(req)
            html = f.read()
            f.close()
        except:
            print("failed to download:", url)
            return

        # let's save it:
        print("saving to:", name)  # do we need a try/except here?
        f = open(dest, 'wb')
        f.write(html)
        f.close()

    # now let's load it into memory:
    print("loading: %s\n" % dest)
    context.load(dest)
    if not quiet:
        end_time = time.time()
        delta_time = end_time - start_time
        print("\n  Time taken:", display_time(delta_time))


# the interactive semantic agent:
while True:
    line = input("\nsa: ")
    line = line.strip()

    if line == "i":
        n = 30
        if len(command_history) > 0:
            count = min(len(command_history), n)
            history = command_history[-count:]
            for k, line in enumerate(history):
                print(" %s)  %s" % (str(k), line))
            selection = input("\nEnter your selection: ")
            try:
                selection = int(selection)
                line = history[selection]
                print("Your selection: %s\n" % line)
            except:
                continue
        else:
            print("history is empty")
            continue
    command_history.append(line)

    # exit the agent:
    if line in ['q', 'quit', 'exit']:
        # save history before we go:
        save_history(command_history, command_history_file)

        print("\nBye!")
        break

    if line in ['h', 'help']:
        print(help_string)

    elif line.startswith('--'):
        continue

    elif line == "context":
        print(context.show_context_list())

    elif line == "icontext":
        print(context.show_context_list_index())
        selection = input("Enter your selection: ")
        try:
            selection = int(selection)
            if context.set_index(selection):
                print(context.dump_universe())
        except:
            continue

    # switch context:
    elif line.startswith("context "):
        name = line[8:]
        context.set(name)
        print(context.dump_universe())

    elif line == "reset":
        check = input("\n  Warning! This will erase all unsaved work! Are you sure? (y/n): ")
        if len(check) > 0 and check[0] == 'y':
            # context = ContextList("sw console") # this is correct approach, but broken due to parser!
            context.reset('sw console')           # this seems to work.
            print("\n  Gone ... ")

    elif line == "dump":
        print(context.dump_universe())

    elif line == "dump exact":
        print(context.dump_universe(exact=True))

    elif line == "dump multi":
        print(context.dump_multiverse())

    elif line == "dump self":
        print(context.dump_multiple_ket_rules(x))

    elif line.startswith("dump "):
        var = line[5:]
        print("var: %s\n" % var)
        try:
            seq = extract_compound_sequence(context, var)
            print(context.dump_multiple_ket_rules(seq))
        except:
            continue

    elif line == "display":
        print(context.display_all())

    elif line.startswith("display "):
        var = line[8:]
        print("var: %s\n" % var)
        try:
            seq = extract_compound_sequence(context, var)
            print(context.display_seq(seq))
        except:
            continue

    elif line == "freq":
        result = context.to_freq_list()
        print(result)

    elif line == "mfreq":
        print(context.multiverse_to_freq_list())

    elif line.startswith("web-load "):
        url = line[9:]
        web_load(url)


    elif line.startswith("load "):
        name = line[5:]
        name = sw_file_dir + "/" + name  # load and save files to the sw_file_dir.
        print("loading sw file:", name)

        if not quiet:
            # time it!
            start_time = time.time()
        context.load(name)
        if not quiet:
            end_time = time.time()
            delta_time = end_time - start_time
            print("\n  Time taken:", display_time(delta_time))

    elif line.startswith("line-load "):
        name = line[10:]
        name = sw_file_dir + "/" + name  # load and save files to the sw_file_dir.
        print("loading sw file:", name)

        if not quiet:
            # time it!
            start_time = time.time()
        context.line_load(name)
        if not quiet:
            end_time = time.time()
            delta_time = end_time - start_time
            print("\n  Time taken:", display_time(delta_time))

    elif line == "save history":
        # save history:
        save_history(command_history, command_history_file)

    elif line.startswith("save multi "):
        name = line[11:]
        name = sw_file_dir + "/" + name  # load and save files to the sw_file_dir.
        print("saving context list to:", name)
        save_sw_multi(context, name)

    elif line.startswith("save "):  # check for file existence first? Or just blow away what is already there?
        name = line[5:]
        name = sw_file_dir + "/" + name  # load and save files to the sw_file_dir.
        print("saving current context to:", name)
        context.save(name)

    elif line.startswith('save-as-dot '):
        if not have_graphviz:
            print('save-as-dot is disabled\nPlease install graphviz')
            continue

        name = line[12:]
        # check it exists, if not create it:
        if not os.path.exists(dot_file_dir):
            print("Creating %s directory." % dot_file_dir)
            os.makedirs(dot_file_dir)
        name = dot_file_dir + '/' + name
        print('saving dot file: %s' % name)

        dot = Digraph(comment=context.context_name(), format='png')

        # walk the sw file:
        for x in context.relevant_kets("*"):  # find all kets in the sw file
            x_node = x.label.replace('"', '\\"').replace(':', ';')  # escape quote characters, and rename colon

            for op in context.recall("supported-ops", x):  # find the supported operators for a given ket
                op_label = op.label[4:]
                arrow_type = "normal"

                sp = context.recall(op, x)  # find the superposition for a given operator applied to the given ket
                if type(sp) is stored_rule:
                    sp = ket(sp.rule)
                    arrow_type = "box"

                if type(sp) is memoizing_rule:
                    sp = ket(sp.rule)
                    arrow_type = "tee"

                if type(sp) is sequence:  # handle sequences later! Fix!
                    sp = sp.to_sp()

                for y in sp:
                    y_node = y.label.replace('"', '\\"').replace(':', ';')  # escape quote characters, and rename colon
                    dot.edge(x_node, y_node, label=op_label, arrowhead=arrow_type)

        # finish up:
        print('\nNow we use graphviz to display it:')
        print('http://www.graphviz.org/')
        dot.render(name, view=True)

    elif line == "files":
        sep = "   "
        max_len = 0
        data = []
        for file in sorted(glob.glob(sw_file_dir + "/*.swc") + glob.glob(sw_file_dir + "/*.sw")):
            base = os.path.basename(file)
            max_len = max(max_len, len(base))
            data.append([base, extract_sw_stats(file)])
        print()
        for file, stats in data:
            print("  " + file.ljust(max_len) + sep + stats)

    elif line.startswith("web-files "):
        url_prefix = line[10:].rstrip('/')
        url = url_prefix + '/sw-index.txt'
        print('List remote sw files.\nFor example:\n\n  web-files http://semantic-db.org/sw/\n')

        # download url
        try:
            print("downloading sw index file:", url)  # code to time the download? Probably, eventually.
            headers = {'User-Agent': 'semantic-agent/2.0'}
            req = urllib.request.Request(url, None, headers)  # does it handle https?
            f = urllib.request.urlopen(req)
            html = f.read()
            f.close()
        except:
            print("failed to download:", url)
            continue

        # process sw-index.txt file:
        print()
        urls = []
        k = 1
        for line in html.decode('ascii').split('\n'):
            line = line.strip()
            if line != '':
                file = line.split(' ')[0]
                file_url = url_prefix + '/' + file
                urls.append((file_url, file))
                print(' %s)  %s' % (k, line))
                k += 1

        # now choose which file we want:
        selection = input("\nEnter your selection: ")
        try:
            selection = int(selection)
            file_url, file = urls[selection-1]
            print("Your selection: %s\n" % file)
            web_load(file_url)
        except:
            continue

    elif line.startswith("cd "):
        sw_file_dir = line[3:]
        # check it exists, if not create it:
        if not os.path.exists(sw_file_dir):
            print("Creating %s directory." % sw_file_dir)
            os.makedirs(sw_file_dir)

    elif line in ['ls', 'dir', 'dirs']:
        print("directory list:")
        for dir in [d for d in os.listdir('.') if os.path.isdir(d) and not d.startswith("__") and not d.startswith('.')]:
            prefix = "  "
            if dir == sw_file_dir:
                prefix = "* "
            sw_count = len(glob.glob(dir + "/*.sw"))
            print('%s%s (%s)' % (prefix, dir, str(sw_count)))


    elif line == "create inverse":
        context.create_universe_inverse()

    elif line == "create multi inverse":
        context.create_multiverse_inverse()


    elif line.startswith("x = "):
        var = line[4:]
        try:
            x = extract_compound_sequence(context, var)
        except:
            x = ket(var)

    elif line == "id":
        print(x)

    elif line in ['s', 'store']:  # set x to the result of the last computation.
        x = result
        print("stored:", x)

    elif line.startswith("--"):
        continue

    elif line.startswith("history"):
        try:
            n = int(line[8:])
        except:
            n = 30

        if len(command_history) > 0:
            count = min(len(command_history), n)
            for line in command_history[-count:]:
                print("  " + line)

    elif line == 'debug on':
        logger.setLevel(logging.DEBUG)

    elif line == 'debug off':
        logger.setLevel(logging.INFO)

    elif line == 'info on':
        logger.setLevel(logging.INFO)

    elif line == 'info off':
        logger.setLevel(logging.WARNING)

    elif line == 'usage':
        usage()

    elif line.startswith('usage '):
        op_names = line[6:].split(', ')
        usage(op_names)

    else:
        if line == ".":
            line = stored_line

        elif line.endswith(('#=>', '!=>')):
            s = line
            while True:
                line = input(':     ')
                if line.strip() == '':
                    break
                s += '\n    ' + line
            line = s + '\n'

        stored_line = line
        if not quiet:
            start_time = time.time()

        try:
            result = process_input_line(context, line, x)
            print(result)
        except KeyboardInterrupt:  # doesn't seem to work.
            print('caught keyboard interrupt')

        if not quiet:
            end_time = time.time()
            delta_time = end_time - start_time
            print("\n  Time taken:", display_time(delta_time))

