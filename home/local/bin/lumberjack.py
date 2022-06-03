#! /usr/bin/env python3.7

from datetime import datetime
from datefinder import find_dates
from operator import itemgetter
import re
import sys
import os
import argparse


class colors:
    reset = '\033[0m'
    bold = '\033[01m'
    disable = '\033[02m'
    underline = '\033[04m'
    reverse = '\033[07m'
    strikethrough = '\033[09m'
    invisible = '\033[08m'

    class fg:
        black = '\033[30m'
        red = '\033[31m'
        green = '\033[32m'
        orange = '\033[33m'
        blue = '\033[34m'
        purple = '\033[35m'
        cyan = '\033[36m'
        lightgrey = '\033[37m'
        darkgrey = '\033[90m'
        lightred = '\033[91m'
        lightgreen = '\033[92m'
        yellow = '\033[93m'
        lightblue = '\033[94m'
        pink = '\033[95m'
        lightcyan = '\033[96m'

    class bg:
        black = '\033[40m'
        red = '\033[41m'
        green = '\033[42m'
        orange = '\033[43m'
        blue = '\033[44m'
        purple = '\033[45m'
        cyan = '\033[46m'
        lightgrey = '\033[47m'

    @staticmethod
    def highlight(color, line, substr=None):
        if substr is not None:
            return line.replace(substr, color + substr + colors.reset)
        return color + line + colors.reset


class Lumberjack:

    search_pattern = None
    highlight_search_pattern = True

    files = list()

    run_extra_pattern = False
    extra_pattern = None

    run_default_extra_pattern = True
    default_extra_pattern = re.compile('(DEBUG|INFO|DIAGNOSE|WARN|ERROR|FATAL)')

    sort_time = True
    print_file_name = True
    highlight_file_name = True
    highlight_date_time = True

    def __init__(self, search_pattern, files):
        self.search_pattern = re.compile(search_pattern)
        self.files = files
        if len(self.files) == 1:
            self.disable_file_name()

    def set_extra_pattern(self, search_pattern):
        self.run_extra_pattern = True
        self.extra_pattern = re.compile(search_pattern)

    def disable_default_extras(self):
        self.run_default_extra_pattern = False

    def disable_all_highlight(self):
        self.highlight_search_pattern = False
        self.run_extra_pattern = False
        self.run_default_extra_patten = False
        self.highlight_file_name = False
        self.disable_highlight_date_time()

    def disable_file_name(self):
        self.print_file_name = False
        self.highlight_file_name = False

    def disable_highlight_date_time(self):
        self.highlight_date_time = False

    def disable_date_sort(self):
        self.disable_highlight_date_time()
        self.sort_time = False

    def run(self):
        if not sys.stdout.isatty():
            self.disable_all_highlight()
        inp_strs = self.get_input()
        if self.sort_time:
            sort_strs = self.sort_strings(inp_strs)
            self.print_strings(sort_strs)
        else:
            self.print_strings(inp_strs)

    def get_datetime(self, string):
        try:
            date = datetime.strptime(string[1][0:24], "%d %b %Y %H:%M:%S,%f")
            return (date, string[0], string[1])
        except ValueError:
            self.print_string((string[0], "NO DATE:" + string[1]), highlight_date_time=False)

    def sort_strings(self, strings):
        out = list(map(self.get_datetime, strings))
        out = list(filter(None, out))
        out.sort(key=itemgetter(0))
        out = list(map(itemgetter(1, 2), out))
        return out

    def highlight_matches(self, line, matches):
        if (not self.highlight_search_pattern):
            return line
        for match in matches:
            line = colors.highlight(colors.fg.lightcyan, line, match)
        return line

    def highlight_extras(self, line):
        if self.run_extra_pattern:
            matches = self.extra_pattern.findall(line)
            if matches:
                for match in matches:
                    line = colors.highlight(colors.fg.blue, line, match)

        if self.run_default_extra_pattern:
            matches = self.default_extra_pattern.findall(line)
            if matches:
                for match in matches:
                    line = colors.highlight(colors.fg.yellow, line, match)
        return line

    def search_file(self, file_name, running_list=[]):
        with open(file_name, 'r') as fp:
            for line in fp:
                matches = self.search_pattern.findall(line)
                if matches:
                    line = self.highlight_matches(line, matches)
                    line = self.highlight_extras(line)
                    running_list.append((file_name, line))

    def get_input(self):
        running_list = []
        for file_name in self.files:
            self.search_file(file_name, running_list)
        return running_list

    def print_strings(self, str_list,
                      highlight_date_time=None,
                      highlight_file_name=None):
        for t in str_list:
            self.print_string(t, highlight_date_time, highlight_file_name)

    def print_string(self, string,
                     highlight_date_time=None,
                     highlight_file_name=None):
        if highlight_file_name is None:
            highlight_file_name = self.highlight_file_name
        if highlight_date_time is None:
            highlight_date_time = self.highlight_date_time

        filename = ""
        if self.print_file_name:
            if highlight_file_name:
                filename = colors.highlight(colors.fg.pink, string[0])
            else:
                filename = string[0]
            filename += ":"

        if highlight_date_time:
            datetime = colors.highlight(colors.fg.green, string[1][0:24])
            line = datetime + string[1][24:]
        else:
            line = string[1]
        print("%s%s" % (filename, line), end='')


def main():
    parser = argparse.ArgumentParser()

    # Positional Arguments
    parser.add_argument('search_pattern', metavar='regular_expression',
                        type=str, help='Regex pattern to search for')
    parser.add_argument('files', metavar='file', type=str, nargs='*',
                        help='File to search though',
                        default=[f for f in os.listdir(os.getcwd()) if os.path.isfile(f)])

    # Optional Arguments
    parser.add_argument('-e', '--extra_pattern', type=str,
                        help='Highlights extra pattern in matched string. '
                        'These patterns will not add new lines to the match '
                        'list only highlights text in allready matched lines.')
    parser.add_argument('--disable_all_highlight',
                        action='store_true',
                        help='Disabled all color highlighting of matches. '
                        'This is set to true whenever the output is not '
                        'the terminal')
    parser.add_argument('--disable_date_sort', '-G', action='store_true',
                        help='Disables all form of date search and sorting'
                        'similar to how grep works')
    parser.add_argument('--disable_highlight_date_time',
                        action='store_true',
                        help='Disables highlighting date and time')
    parser.add_argument('--disable_file_names',
                        action='store_true',
                        help='Disables printing source files name')
    parser.add_argument('--disable_highlight_default_extra',
                        action='store_true',
                        help='Run the default extra highlighting')

    args = parser.parse_args()

    lumberjack = Lumberjack(args.search_pattern, args.files)
    if args.extra_pattern is not None:
        lumberjack.set_extra_pattern(args.extra_pattern)

    if args.disable_highlight_date_time:
        lumberjack.disable_highlight_date_time()
    if args.disable_date_sort:
        lumberjack.disable_date_sort()

    if args.disable_highlight_default_extra:
        lumberjack.disable_default_extras()

    if args.disable_file_names:
        lumberjack.disable_file_name()

    if args.disable_all_highlight:
        lumberjack.disable_all_highlight()

    lumberjack.run()


if __name__ == "__main__":
    main()
