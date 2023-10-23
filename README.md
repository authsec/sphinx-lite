# Container Build

To locally build the container execute the following build command:

```
docker build . -t authsec/sphinx-lite 
```

# Usage 

You can start an internal HTTP server by setting the HTTP_SERVER_PORT variable to the same value as one of the forwardPorts in your `.devcontainer/devcontainer.json` configuration file.

```
{
   "image": "authsec/sphinx-lite",
   "forwardPorts": [
      8008
],
"containerEnv": {
    "HTTP_SERVER_PORT": "8008"
},
"customizations": {
    "vscode": {
        "extensions": [
            "ms-python.python",
            "ms-toolsai.jupyter",
            "jebbs.plantuml",
            "trond-snekvik.simple-rst",
            "swyddfa.esbonio",
            "mechatroner.rainbow-csv",
            "useblocks.sphinx-needs-vscode"
        ]
    }
}
}
```

The container can then be started using the `rs` (for run/restart server) command alias. You can then reach the container web server from the host operating system using http://localhost:$HTTP_SERVER_PORT.