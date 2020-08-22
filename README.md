# Quick reference
- **Maintained by:** Juan Pablo Tosso
- **Where to get help:** Github or Slack
- **Where to file issues:** [https://github.com/jptosso/coraza-waf/issues](https://github.com/jptosso/coraza-waf/issues)
- **Supported architectures:** amd64, i386

# Supported tags and respective ``Dockerfile`` links
- [0.1.0-alpha.1](#), [latest](#)

# What is Coraza WAF

<img src="https://github.com/jptosso/coraza-waf/raw/master/docs/logo.png" width="50%">

# How to use this image

## Hosting some simple static server

```
$ docker run --name my-waf -v /some/config/routes.eskip:/etc/coraza-waf/routes.eskip:ro -d jptosso/coraza-waf
```

Alternatively, a simple Dockerfile can be used to generate a new image that includes the necessary content (which is a much cleaner solution than the bind mount above):

```
FROM jptosso/coraza-waf
COPY static-settings-directory /etc/coraza-waf
```

Place this file in the same directory as your directory of content ("static-settings-directory"), ``run docker build -t my-waf .``, then start your container:

```
$ docker run --name my-waf -d some-waf-server
```

``static-settings-directory`` structure must be:
- /routes.eskip: Routes file
- /skipper.yaml: Skipper settings
- /profiles/{profile}/{rules}.conf: rules to be imported by skipper filter

## Exposing external port

```
$ docker run --name my-waf -d -p 9090:9090 some-waf-server
```

Then you can hit http://localhost:9090 or http://host-ip:9090 in your browser.

# License

View [license information](#) for the software contained in this image.

As with all Docker images, these likely also contain other software which may be under other licenses (such as Bash, etc from the base distribution, along with any direct or indirect dependencies of the primary software being contained).

As for any pre-built image usage, it is the image user's responsibility to ensure that any use of this image complies with any relevant licenses for all software contained within.