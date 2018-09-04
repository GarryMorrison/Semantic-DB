#!c:/Python34/python.exe

#######################################################################
# simple http server
#
# Author: Garry Morrison
# email: garry -at- semantic-db.org
# Date: 3/9/2018
# Update: 4/9/2018
# Copyright: GPLv3
#
#
#######################################################################

import os
import time
import glob
from http.server import BaseHTTPRequestHandler, HTTPServer
# from io import BytesIO
from urllib.parse import urlparse, unquote_plus
from html import escape
from semantic_db import *
import io
from contextlib import redirect_stdout
import urllib.request

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
command_history_length = 100
shell_history_length = 20
full_history = []


# HTTPRequestHandler class
class OurHTTPServer_RequestHandler(BaseHTTPRequestHandler):

    # Write content as utf-8 data
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
                    self.wfile.write(f.read())
                return
        except Exception as e:
            self.write('Reason: %s' % e)
            return

        try:
            # Send headers
            self.send_header('Content-type', 'text/html')
            self.end_headers()

            query = urlparse(self.path).query
            name = os.path.basename(self.path)

            # Send message back to client
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
            message = "Hello world!"
            # self.write(message)
            self.write("You accessed path: %s<br>" % self.path)
            self.write("query: %s<br>" % query)
            self.write("query_dict: %s<br>" % query_dict)
            for h in self.headers:
                self.write("header: %s<br>" % h)
                self.write("value: %s<br>" % self.headers[h])
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
        # self.send_header('Location', '#form')
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
                elif 'reset' in query_dict:
                    reset_input = query_dict['reset']
                    self.write(process_reset(reset_input))
                elif 'download' in query_dict:
                    download_input = query_dict['download']
                    # self.write(process_download(download_input))
                    self.write(process_download(query_dict))
                elif 'webload' in query_dict:
                    self.write(process_webload(query_dict))
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
  sa: <input type="text" name="sa-input" size="100" autofocus="autofocus">
  <input type="submit" name="compute" value="compute">
</form>
<p>
    """

    footer = """
</body>
</html>
    """
    return header + footer


header = """
<html>
<head><title>Semantic DB</title></head>
<body>
<h3>Semantic DB</h3>
"""

form = """
<a name="form"></a>
<form method="post">
  sa: <input type="text" name="sa-input" size="100" autofocus="autofocus">
  <input type="submit" name="compute" value="compute">
</form>
"""

footer = """
</body>
</html>
"""

def process_input(line):
    line = line.strip()
    # s = 'sa: %s<br>' % line
    s = 'sa: %s' % line
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
    elif line.startswith("web-files "):
        # print('List and load remote sw files.\nFor example:\n\n  web-files http://semantic-db.org/sw/\n')
        url_prefix, url_base = os.path.split(line[10:])
        # print('url_prefix: %s' % url_prefix)
        # print('url_base: %s' % url_base)

        # try sw-index.txt first
        url = url_prefix + '/sw-index.txt'
        have_sw_index = False
        have_result = True

        # download sw-index.txt:
        try:
            result += 'downloading sw index file: <a href="%s">%s</a>\n' % (url, url)
            headers = {'User-Agent': 'semantic-agent/2.0'}
            req = urllib.request.Request(url, None, headers)  # does it handle https?
            f = urllib.request.urlopen(req)
            html = f.read()
            f.close()
            have_sw_index = True
        except:
            # try index.html next:
            if url_base == '':
                url = url_prefix + '/'
            else:
                url = url_prefix + '/' + url_base

            # download index.html:
            try:
                result += 'downloading sw index file: <a href="%s">%s</a>\n' % (url, url)
                headers = {'User-Agent': 'semantic-agent/2.0'}
                req = urllib.request.Request(url, None, headers)  # does it handle https?
                f = urllib.request.urlopen(req)
                html = f.read()
                f.close()
            except:
                result += 'failed to download: <a href="%s">%s</a>\n' % (url, url)
                have_result = False

        if have_result:
            result += '<form method="post">'
            urls = []
            k = 1
            # process sw-index.txt file if we have it:
            if have_sw_index:
                for line in html.decode('ascii').split('\n'):
                    line = line.strip()
                    if line != '':
                        file = line.split(' ')[0]
                        file_url = url_prefix + '/' + file
                        urls.append((file_url, file))
                        # print(' %s)  %s' % (k, line))
                        result += '    <input type="checkbox" name="%s" value="%s">%s\n' % ('download' + str(k), escape(file_url), line)
                        k += 1
            else:
                for file in re.findall('href="(.*sw|.*swc)"', html.decode('utf-8')):  # do we want to sort the list?
                    base = os.path.basename(file)
                    file_url = url_prefix + '/' + file
                    # print('file_url: %s' % file_url)
                    urls.append((file_url, base))
                    # print(' %s)  %s' % (k, base))
                    result += '    <input type="checkbox" name="%s" value="%s">%s\n' % ('download' + str(k), escape(file_url), base)
                    k += 1

            result += '    <input type="submit" name="download" value="download">\n</form>'

    elif line in ["i", "history"]:
        result = '<form method="post">'
        for k, line in enumerate(command_history):
            result += '<input type="radio" name="%s" value="%s">%s\n' % ('sa-input', escape(line), line)
        result += '<input type="submit" name="compute" value="compute">\n</form>'
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
        # result = header
        result += '\n<img src="%s.png">\n' % name
        # result += form + footer
        # return result
    elif line == "display":
        result += context.display_all()
    elif line.startswith("display "):
        var = line[8:]
        # print("var: %s\n" % var)
        try:
            seq = extract_compound_sequence(context, var)
            result += context.display_seq(seq)
        except:
            pass
    elif line == "quiet on":
        global quiet
        quiet = True
    elif line == "quiet off":
        global quiet
        quiet = False
    elif line.startswith('usage '):
        op_names = line[6:].split(', ')
        with io.StringIO() as buf, redirect_stdout(buf):  # ugly hack for now
            usage(op_names)
            result += buf.getvalue()
    elif line == "reset":
        result += "\n  Warning! This will erase all unsaved work! Are you sure?"
        result += """
<form method="post">
    <input type="submit" name="reset" value="yes"> <input type="submit" name="reset" value="no">
</form>"""
        # if len(check) > 0 and check[0] == 'y':
        #     context.reset('sw console')
        #     print("\n  Gone ... ")
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

    # return header + s + '<pre>\n' + result + '</pre>\n' + form + footer
    full_history.append(s + '<pre>' + result + '</pre>\n')
    return header + "".join(full_history) + form + footer


def process_reset(reset_input):
    result = ''
    if reset_input == 'yes':
        context.reset('http shell')
        result += '\n    Gone!'
    full_history.append('<pre>' + result + '</pre>\n')
    return header + "".join(full_history) + form + footer


def process_download(query_dict):
    result = """<form method="post">"""
    max_len = 0
    data = []
    for key, value in query_dict.items():
        if key.startswith('download'):
            idx = key[8:]
            if len(idx) > 0:
                # result += '%s: %s\n' % (idx, value)
                # result += 'webloading: %s\n' % unquote_plus(value)
                value = unquote_plus(value)
                name = value.split("/")[-1]
                dest = sw_file_dir + "/" + name
                # check if it exists:
                if os.path.exists(dest):
                    max_len = max(max_len, len(name))
                    data.append((name, idx, value))
    for name, idx, value in data:
        result += """    File "%s" already exists:%s <input type="radio" name="webload-%s" value="overwrite-%s">overwrite <input type="radio" name="webload-%s" value="rename-%s">rename <input type="radio" name="webload-%s" value="dont_save-%s">don't save\n""" % (name, ''.ljust(max_len - len(name)), idx, value, idx, value, idx, value)
    result += '    <input type="submit" name="webload" value="download">\n</form>'
    # return header + '<pre>' + result + '</pre>' + form + footer
    full_history.append('<pre>' + result + '</pre>\n')
    return header + "".join(full_history) + form + footer


def process_webload(query_dict):
    # result = ''
    max_len = 0
    rename_files = []
    result = '<form method="post">'
    for key, value in query_dict.items():
        value = unquote_plus(value)
        if key.startswith('webload-'):
            # result += '%s: %s\n' % (key, value)
            if value.startswith('overwrite-'):
                # result += 'Overwrite: %s\n' % value[10:]
                pass
            elif value.startswith('rename-'):
                # result += 'Rename: %s\n' % value[7:]
                name = os.path.basename(value[7:])
                max_len = max(max_len, len(name))
                rename_files.append(name)
                # result += '<form method="post">'
                # result += '  rename: %s <input type="text" name="rename" value="%s" size="100" autofocus="autofocus">\n' % (name, name)
                # result += '</form>'
            elif value.startswith('dont_save-'):
                # result += "Don't save: %s\n" % value[10:]
                pass
    result = '<form method="post">'
    for name in rename_files:
        result += '    rename %s <input type="text" name="rename" value="%s" size="100" autofocus="autofocus">\n' % (name.ljust(max_len), name)
    result += '    <input type="submit" name="rename" value="rename"></form>'
    # return header + '<pre>' + result + '</pre>' + form + footer
    full_history.append('<pre>' + result + '</pre>\n')
    return header + "".join(full_history) + form + footer


if __name__ == '__main__':
    run()
