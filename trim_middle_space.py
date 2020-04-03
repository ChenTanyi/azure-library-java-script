import os
import re
import yaml

project_path = os.environ['HOME'] + '/code/work/azure-sdk-for-java/'

f = os.path.join(project_path, 'sdk/management/pipelines/fluentJavaMgmt.yml')
yml = yaml.safe_load(open(f))

for d in yml['trigger']['paths']['include']:
    dirname = os.path.join(project_path, d)
    for root, dirs, files in os.walk(dirname):
        for filename in files:
            if filename.endswith('.java'):
                filepath = os.path.join(root, filename)
                with open(filepath, 'r+') as fstream:
                    lines = fstream.readlines()
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

                    output = ''.join(lines)

                    fstream.truncate(0)
                    fstream.seek(0)
                    fstream.write(output)
                    print(filename)