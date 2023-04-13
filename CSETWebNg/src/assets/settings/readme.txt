How the config settings works.

The base configuration is config.json.
The configuration service will load that one up by default first.
It then looks at the the currentConfigChain in the base config.json to decide how to load subsequent config profiles.
Each subsequent config that contains matching properties from previous configs in the chain will be overwritten.
