# Configuration Optimization helper tools

This folder contains tool(s) for easier use of the Configuration Optimization.

## Merging `expconfig.py`

The Configuration Optimisation's `expconfig.yaml` consists of two types of
parameters:

* static parameters, which help the CO to connect to various external locations and services, and
* the parameters that depend on each application being tested.

The CO acts as a service, which receives applications, each of which will in
principle have a different set of parameters. The experiment parameters will
vary as well. To help separate the parameters that an administrator might set
from the ones that are of the users' concern, we provide the
`utils/merge_expconfig.py` tool.

The usage of the tool is as follows:

```
merge_expconfig.py [-h] [-c CO_CONFIG] [-a APP_CONFIG]
                          [-O OUTPUT_CONFIGURATION]

optional arguments:
  -h, --help            show this help message and exit

mandatory arguments:
  -c CO_CONFIG, --co-config CO_CONFIG
                        Configuration file for the Configuration Optimization
  -a APP_CONFIG, --app-config APP_CONFIG
                        Specification of application and its parameters to be
                        optimized.
  -O OUTPUT_CONFIGURATION, --output-configuration OUTPUT_CONFIGURATION
                        Output path to save the configuration of the
                        Configuration Optimization into.
```

The `CO_CONFIG` is the path of the file containing the administrative
parameters of the CO. The following example, e.g. named `co-config.yaml`,
should contain the following:

```yaml
saveFolder: ./integrated/reports/
confFolder: ./integrated/config/
summaryFolder: ./integrated/summary/
blueprint: blueprint.yaml
conf: topology-configuration.yaml
topic: jsontest
services:
  - servicename: deployment.service
    URL: http://deployer.example.lan:8000
    container: 7b5750a7-914e-4e83-ab40-b04fd1975542 
    username: user
    password: password123
    tools: /Repos/DICE-Deployment-Service/tools
  - servicename: monitoring.service
    URL: http://10.10.45.20:5001
  - servicename: "broker"
    URL: http://localhost:8082
  - servicename: zookeeper.servers
    URL: localhost:2181
    ip: ["10.10.50.11"]
```

As a rule, all the top level keys except for the `services` will be copied into
the `runexp` dictionary of the final configuration files.

The `APP_CONFIG` file contains the experiment settings and specifications of the
parameters to be included in the optimization process. Here is an example of
such file's contents:

```yaml
runexp:
  noise: 1e-5
  numIter: 100
  initialDesign: 10
  sleep_time: 10000
  metricPoll: 1000
  expTime: 300000
application:
  jar_file: storm-starter-1.0.1.jar
  jar_path: 
  class: storm.starter.WordCountTopology
  name: wordcount
  type: storm
vars:
  - paramname: "component.spout_num" 
    node: ["storm", "nimbus"] 
    options: [1 3]
    lowerbound: 0
    upperbound: 0
    integer: 0
    categorical: 1

  - [...]
```

To produce the final `OUTPUT_CONFIGURATION` file, call the following:

```bash
$ ./merge_expconfig.py \
    -c co-config.yaml \
    -a app-config-minimal.yaml \
    -O expconfig.yaml
```
