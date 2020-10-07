# kubectx

A CLI wrapper around `kubectl config` to manage kubernetes contexts alongside IBM Cloud kubernetes contexts

# installing

```
$ wget https://raw.githubusercontent.com/renier/kubectx/master/kubectx.sh
$ chmod +x kubectx.sh
$ cp kubectx.sh /usr/local/bin/kubectx
```

# using

To see the contexts table:
```
kubectx
```

That's it. To switch to any of the cached contexts:
```
$ kubectx <context name>
```

It also supports setting the namespace:
```
$ kubectx <context name> <namespace>
```

To only set the namespace in the current context:
```
$ kubectx . <namespace>
```

## Bash completion

It works better with bash completion!! To configure:
```
$ BASEDIR=/usr/local/etc/bash_completion.d
$ mkdir -p $BASEDIR
$ curl -L -o $BASEDIR/kubectx https://raw.githubusercontent.com/renier/kubectx/master/bash_completion_kubectx
$ chmod +x $BASEDIR/kubectx
$ echo "source $BASEDIR/kubectx" >> ~/.bashrc # or ~/.bash_profile if on the Mac
$ source $BASEDIR/kubectx # to get it going on the current terminal
```

Now try it: `kubectx <TAB><TAB>`. 🎉

## Installing a new context

To install a brand new IBM Cloud Kubernetes context (assuming you are already logged in to IBM Cloud):
```
$ iksconfig <cluster name> # requires the container-service ibmcloud plugin
$ kubectx # to see that it is already set as your context
```

## iTerm2 Mac users

There is a `kubectx.py` python script that adds the current kube context with current namespace to the terminal status bar. You can add it from the script menu. Once you install it, you can add it to the status bar using an interpolated string applet with `\(user.kubectx)` as the value.
