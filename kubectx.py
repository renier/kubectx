#!/usr/bin/env python3.7
#
# This will set an iterm2 variable "user.kubectx" with the name of the
# current kubectl context and namespace configured. This variable in turn
# can be referenced from the status bar controls using an interpolated
# string. It updates the variable every 5 seconds.
#
# See:
# https://www.iterm2.com/documentation-scripting-fundamentals.html
# https://github.com/renier/kubectx

import iterm2
import subprocess
import time
import json


async def main(connection):

    async def set_kubectx(conn):
        app = await iterm2.async_get_app(conn)
        process = subprocess.Popen(
            ['/bin/bash', '-c', 'source /usr/local/bin/kubectx > /dev/null && /usr/local/bin/kubectl config view --minify --output json'], stdout=subprocess.PIPE)
        output, error = process.communicate()

        decoded = output.decode('utf-8')
        json_dict = json.loads(decoded)
        context_name = json_dict['contexts'][0]['name']
        namespace = json_dict['contexts'][0]['context'].get(
            'namespace', 'default')
        kubectx = "%s %s" % (context_name, namespace)

        window = app.current_window
        if not window:
            print("No windows found")
            return

        tab = window.current_tab
        if not tab:
            print("No tabs found")
            return

        for session in tab.sessions:
            try:
                await session.async_set_variable('user.kubectx', kubectx)
            except Exception as e:
                print(e)
        # for window in app.windows:
        #     for tab in window.tabs:
        #         for session in tab.sessions:
        #             await session.async_set_variable('user.kubectx', kubectx)

        return kubectx

    while True:
        time.sleep(5)
        await set_kubectx(connection)


iterm2.run_forever(main)
