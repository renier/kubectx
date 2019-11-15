# kubectx

A CLI wrapper around `kubectl config` to manage kubernetes contexts alongside IBM Cloud kubernetes contexts

# installing

```
$ wget https://raw.githubusercontent.com/renier/kubectx/master/kubectx.sh
$ chmod +x kubectx.sh
$ cp kubectx.sh /usr/local/bin/kubectx
```

# using

To cache all existing IBM Cloud Kubernetes configs:
```
$ source kubectx > /dev/null
```
You should also add this command to your `~/.bash_profile` (or `~/.bashrc` on Unix/Linux).

That's it. To switch to any of the cached contexts:
```
$ kubectx <context name>
```

It also supports setting the namespace:
```
$ kubectx <context name> <namespace>
```

To see the context table:
```
kubectx
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
$ ibmcloud ks cluster-config <context name> # requires the container-service ibmcloud plugin
$ source kubectx # To cache it
$ kubectx <context name> # To set it
```
