# kubectx

A CLI tool to manage kubernetes contexts alongside IBM Cloud kubernetes contexts

# installing

```bash
pip3 install -e "git+https://github.com/renier/kubectx#egg=kubectx"
```

# using

To cache all existing IBM Cloud Kubernetes contexts:
```
$ kubectx
```

That's it. To switch to any of the cached contexts:
```
$ kubectx <context name>
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

## Installing a context

To install a brand new IBM Cloud Kubernetes context (assuming you are already logged in to IBM Cloud):
```
$ ibmcloud ks cluster-config <context name> # requires the container-service ibmcloud plugin
$ kubectx # To cache it
$ kubectx <context name> # To set it
```
