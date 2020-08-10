#!/usr/bin/env python3
import os
import re
import yaml
import fnmatch

project_path = os.environ['HOME'] + '/code/work/azure-sdk-for-java/'

def locate(pattern, root=os.curdir):
    '''Locate all files matching supplied filename pattern in and below
    supplied root directory.'''
    for path, _, files in os.walk(os.path.abspath(root)):
        for filename in fnmatch.filter(files, pattern):
            yield os.path.join(path, filename)

def trim_middle_space(lines):
    for i, line in enumerate(lines):
        match = re.match(r'^( *\* @param [^\s]+) {2,}(.*)', line)
        if match:
            # print(f'{line!r}')
            # print(f'{match.group(1)!r}')
            # print(f'{match.group(2)!r}')
            # print()
            lines[i] = match.group(1) + ' ' + match.group(2)
            if lines[i][-1] != '\n':
                lines[i] = lines[i] + '\n'

def file_end_newline(lines):
    if lines[-1][-1] != '\n':
        lines[-1] = lines[-1] + '\n'

def fix_license(lines):
    licenses = ['// Copyright (c) Microsoft Corporation. All rights reserved.\n', '// Licensed under the MIT License.\n\n']
    if len(lines) > 1 and lines[0].strip() == licenses[0].strip() and lines[1].strip() == licenses[1].strip():
        return lines

    for i, line in enumerate(lines):
        if line.strip() == '' or re.match(r'^package\s+[\w\.]+;', line):
            return licenses + lines[i:]
    
    raise Exception('no package line')
    

# from https://gist.github.com/rodrigosetti/4734557
def unused_import(lines):
    IMPORT_RE = re.compile(r'^\s*import\s+[\w\.]+\.(\w+)\s*;\s*(?://.*)?$')
    import_lines = {}
    other_lines = []

    for n, line in enumerate(lines):
        m = IMPORT_RE.match(line)
        if m:
            # this is an import line, associate the line number with
            # the symbol imported
            import_lines[n] = m.group(1)
        else:
            # this is a non-import line (everything else)
            other_lines.append(line)

        # get the code excluding the import line
        other_code = ''.join(other_lines)

    new_lines = []
    for n, line in enumerate(lines):
        if (n in import_lines and
            not re.search(r'(?<!\w)%s(?!\w)' % import_lines[n],
                            other_code)):
            # import not found in code... continue (not writing)
            # print("unused: %s at %s:%d" % (line, filename, n))
            continue
        new_lines.append(line)
    return new_lines


if __name__ == "__main__":
    dirname = os.path.join(project_path, 'sdk/resourcemanager/')
    for filename in locate('*.java', dirname):
        with open(filename, 'r+') as fstream:
            lines = fstream.readlines()

            trim_middle_space(lines)
            file_end_newline(lines)
            lines = unused_import(lines)
            lines = fix_license(lines)

            fstream.truncate(0)
            fstream.seek(0)
            fstream.write(''.join(lines))
            print(filename)