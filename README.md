# connector-web-api

External Connector API is an API that stands between the EXternal Connector implementation and the Enterprise Search (Workplace Search). It is pull-based, meaning that there will be only GET methods in it, which will allow Workplace Search to pull content based on the schedule that Workplace Search implements and supports.

## API Description

See [the generated API description](swagger.md).

## API Description generation

API descriptions are generated from the [swagger.yaml](swagger.yaml) using the [swagger-markdown](https://github.com/syroegkin/swagger-markdown) tool.

Run this once to install the tool:

```shell
make install
```

Run this every time to regenerate the markdown:
```shell
nake md
```
