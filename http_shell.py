#!c:/Python34/python.exe

#######################################################################
# simple http server
#
# Author: Garry Morrison
# email: garry -at- semantic-db.org
# Date: 3/9/2018
# Update: 3/9/2018
# Copyright: GPLv3
#
#
#######################################################################

import os
import time
import glob
from http.server import BaseHTTPRequestHandler, HTTPServer
from io import BytesIO
from urllib.parse import urlparse, unquote_plus
from html import escape
from semantic_db import *
import io
from contextlib import redirect_stdout

try:
    from graphviz import Digraph
    have_graphviz = True
except ImportError:
    have_graphviz = False


quiet = False
sw_file_dir = 'sw-examples'
dot_file_dir = 'graph-examples'
x = ket()
stored_line = ""
command_history = []
command_history_len = 100


# HTTPRequestHandler class
class OurHTTPServer_RequestHandler(BaseHTTPRequestHandler):

    def write(self, s):
        self.wfile.write(bytes(s, 'utf8'))

    # GET:
    def do_GET(self):
        # Send response status code
        self.send_response(200)

        try:
            query = urlparse(self.path).query
            name = os.path.basename(self.path)
            if len(query) == 0 and name.endswith('.png'):
                # Send headers
                self.send_header('Content-type', 'image/png')
                self.end_headers()

                filename = dot_file_dir + '/' + name
                with open(filename, 'rb') as f:
                    # self.write(f.read())
                    self.wfile.write(f.read())
                return

            # Send headers
            self.send_header('Content-type', 'text/html')
            self.end_headers()

            # Send message back to client
            message = "Hello world!"
            if len(query) == 0 and (name.endswith('.sw') or name.endswith('.swc')):
                filename = sw_file_dir + '/' + name
                with open(filename, 'r') as f:
                    text = f.read()
                    self.write('<pre>\n')
                    self.write(text)
                    self.write('</pre>\n')
                return
            query_dict = {}
            if len(query) > 0:
                query_dict = dict(q.split("=") for q in query.split("&"))
            # Write content as utf-8 data
            # self.wfile.write(bytes(message, "utf8"))
            # self.wfile.write(bytes("<p>You accessed path: %s</p>" % self.path, "utf-8"))
            # self.wfile.write(bytes("<p>headers: %s</p>" % self.headers, "utf-8"))
            # self.wfile.write(bytes("<p>query: %s</p>" % query, "utf-8"))
            # self.wfile.write(bytes("<p>query_dict: %s</p>" % query_dict, "utf-8"))
            self.write(message)
            self.write("<p>You accessed path: %s</p>" % self.path)
            self.write("<p>query: %s</p>" % query)
            self.write("<p>query_dict: %s</p>" % query_dict)
            for h in self.headers:
                self.write("<p>header: %s</p>" % h)
                self.write("<p>value: %s</p>" % self.headers[h])
            self.write("<hr>")
            self.write(intro_page())
        except Exception as e:
            self.write('Reason: %s' % e)
        return

    # POST:
    def do_POST(self):
        content_length = int(self.headers['Content-Length'])
        body = self.rfile.read(content_length)
        self.send_response(200)
        self.end_headers()
        # response = BytesIO()
        # response.write(b'This is POST request. ')
        # response.write(b'Received: ')
        # response.write(body)
        # self.wfile.write(response.getvalue())
        # self.write('hey!<hr>')
        # self.write(html.unescape(body))
        try:
            query_dict = {}
            if len(body) > 0:
                query_dict = dict(q.split("=") for q in body.decode('utf-8').split("&"))
                # self.write('query_dict: %s\n<hr>\n' % query_dict)
                if 'sa-input' in query_dict:
                    sa_input = unquote_plus(query_dict['sa-input'])
                    self.write(process_input(sa_input))
                elif 'history' in query_dict:
                    history_input = query_dict['history']
                    self.write('history: %s' % history_input)
        except Exception as e:
            self.write('Reason: %s' % e)
        return


def run():
    print('starting server...')

    # Server settings
    # Choose port 8080, and localhost:
    server_address = ('127.0.0.1', 8080)
    httpd = HTTPServer(server_address, OurHTTPServer_RequestHandler)
    print('running server...')
    httpd.serve_forever()


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


def intro_page():
    header = """
<html>
<head><title>Semantic DB</title></head>
<body>
<h3>Semantic DB</h3>
Welcome to version 2.0 of the Semantic DB<br>
Last updated 3 September, 2018<p>

To load remote sw files, run:<p>
web-files <a href="http://semantic-db.org/sw/">http://semantic-db.org/sw/</a><p>
To see usage docs:
<a href="http://semantic-db.org/docs/usage/">http://semantic-db.org/docs/usage/</a><p>
<form method="post">
  sa: <input type="text" name="sa-input" size="100">
  <input type="submit" name="compute" value="compute">
</form>
<p>
    """

    footer = """
</body>
</html>
    """
    return header + footer



def process_input(line):
    line = line.strip()
    header = """
<html>
<head><title>Semantic DB</title></head>
<body>
<h3>Semantic DB</h3>
"""

    form = """
<form method="post">
  sa: <input type="text" name="sa-input" size="100">
  <input type="submit" name="compute" value="compute">
</form>
"""
    footer = """
</body>
</html>
"""
    s = 'sa: %s<br>' % line
    command_history.append(line)
    result = ''
    if line == "dump":
        result = context.dump_universe()
    elif line == "dump multi":
        result = context.dump_multiverse()
    elif line.startswith("load "):
        name = line[5:]
        name = os.path.basename(name)
        name = sw_file_dir + "/" + name  # load and save files to the sw_file_dir.
        result += "loading sw file: %s\n" % name

        if not quiet:
            # time it!
            start_time = time.time()
            
        with io.StringIO() as buf, redirect_stdout(buf):
            context.load(name)
            result += buf.getvalue()

        if not quiet:
            end_time = time.time()
            delta_time = end_time - start_time
            result += "\n  Time taken: %s\n" % display_time(delta_time)
    elif line == "files":
        sep = "   "
        max_len = 0
        data = []
        for file in sorted(glob.glob(sw_file_dir + "/*.swc") + glob.glob(sw_file_dir + "/*.sw")):
            base = os.path.basename(file)
            max_len = max(max_len, len(base))
            data.append([base, extract_sw_stats(file)])
        for file, stats in data:
            result += '  <a href="%s">%s</a>%s%s%s\n' % (file, file, ''.ljust(max_len - len(file)), sep, stats)
    elif line == "i" or line == "history":
        result = '<form method="post">\n'
        for k, line in enumerate(command_history):
            result += '<input type="radio" name="%s" value="%s">%s\n' % ('sa-input', escape(line), line)
        result += '<input type="submit" name="compute" value="compute">\n</form>\n'
    elif line == "graph":
        if not have_graphviz:
            return 'graph is disabled\nPlease install graphviz'


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
        name = dot_file_dir + '/tmp.dot'
        dot.render(name)
        result = header
        result += '\n<img src="%s.png">\n' % name
        result += form + footer
        return result

    else:
        if not quiet:
            start_time = time.time()

        with io.StringIO() as buf, redirect_stdout(buf):
            # seq = process_input_line(context, line, x)
            seq = process_input_line(context, line, ket())
            result += buf.getvalue()

        result += '%s\n' % seq

        if not quiet:
            end_time = time.time()
            delta_time = end_time - start_time
            result += "\n  Time taken: %s\n" % display_time(delta_time)


    return header + s + '<pre>\n' + result + '</pre>\n' + form + footer


if __name__ == '__main__':
    run()
