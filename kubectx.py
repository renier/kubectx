#!/usr/bin/env python3
# Copyright 2019 Renier Morales <renierm@us.ibm.com>
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

from fnmatch import fnmatch
import os
import sys
import yaml

PATHS = [
    '{}/.bluemix/plugins/container-service/clusters'.format(os.environ['HOME'])
]

MAIN_CONFIG = '{}/.kube/config'.format(os.environ['HOME'])


def find_files(pattern, path):
    result = []
    for root, _, files in os.walk(path):
        for file in files:
            if fnmatch(file, pattern):
                result.append(os.path.join(root, file))

    return result


def update():
    # Find all yaml files
    result = []
    for path in PATHS:
        result += find_files('*.yml', path)

    suspects = ['clusters', 'contexts', 'users']
    main_doc = yaml.unsafe_load(open(MAIN_CONFIG, 'r').read())
    for var in suspects:
        table = locals()[var] = {}
        for item in main_doc[var]:
            table[item['name']] = item

    for file in result:
        with open(file, 'r') as f:
            try:
                doc = yaml.unsafe_load(f)
                cluster = doc['clusters'][0]['cluster']
                cluster['certificate-authority'] = \
                    os.path.dirname(file) + '/' + \
                    cluster['certificate-authority']
                context = doc['contexts'][0]['context']
                user = doc['clusters'][0]['name'] + '_' + context['user']
                context['user'] = user
                doc['users'][0]['name'] = user

                for var in suspects:
                    table = locals()[var]
                    table[doc[var][0]['name']] = doc[var][0]

            except yaml.YAMLError as exc:
                print(exc)

    for var in suspects:
        main_doc[var] = []
        for v in locals()[var].values():
            main_doc[var].append(v)

    with open(MAIN_CONFIG, 'w') as f:
        f.write(yaml.dump(main_doc))

    print("Updated %s" % MAIN_CONFIG)
    return 0


def switch(newctx):
    with open(MAIN_CONFIG, 'r') as f:
        main_doc = yaml.unsafe_load(f.read())

    found = False
    for context in main_doc['contexts']:
        if context['name'] == newctx:
            found = True
            break

    if not found:
        print("context not found. please download it and refresh the cache.")
        print("e.g. ibmcloud ks cluster-config {} && {}".format(newctx, os.path.basename(sys.argv[0])))
        return 1

    main_doc['current-context'] = newctx

    with open(MAIN_CONFIG, 'w') as f:
        f.write(yaml.dump(main_doc))

    print("Updated kube context to %s" % newctx)
    return 0


def list():
    with open(MAIN_CONFIG, 'r') as f:
        main_doc = yaml.unsafe_load(f.read())
        contexts = [c['name'] for c in main_doc['contexts']]
        print(" ".join(contexts))
    
    return 0


def main():
    if len(sys.argv) <= 1:
        return update()
    elif sys.argv[1] == 'compgen':
        return list()
    else:
        return switch(sys.argv[1])


if __name__ == "__main__":
    sys.exit(main())