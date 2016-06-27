# BO4CO [![License](https://img.shields.io/pypi/l/Django.svg)](https://github.com/dice-project/DICE-Configuration-BO4CO/blob/master/LICENSE.txt)

## Introduction
Configuration Optimization Tool for Big Data Systems

Bayesian Optimization for Configuration Optimization (BO4CO) is an auto-tuning algorithm for Big Data applications. Big data applications typically are developed with several technologies (e.g., Hadoop, Spark, Cassandra) each of which has typically dozens of configurable parameters that should be carefully tuned in order to perform optimally. BO4CO helps end users of big data systems such as data scientists or SMEs to automatically tune the system.  

## Architecture
The following figure illustrates all the components of BO4CO:
(i) optimization component, (ii) experimental suite, (iii) and a data broker. 

![BO4CO architecture](doc/latex/figures/bo4co-arch.png)


## How to use

The configuration tool works in `deployed` and `MATLAB` mode. `deployed` mode does not need any MATLAB installation and only is dependent on a royalty free [MATLAB compiler](http://uk.mathworks.com/products/compiler/mcr/). 

### Getting BO4CO

Regardless of the method, first download the tool using git or
a package download. With git, run the following steps:

```bash
$ mkdir -p ~/myrepos ; cd ~/myrepos
$ git clone https://github.com/dice-project/DICE-Configuration-BO4CO.git
$ cd DICE-Configuration-BO4CO
```

Or, to obtain the tool, use the following steps:

```bash
$ mkdir -p ~/myrepos ; cd ~/myrepos
$ wget https://github.com/dice-project/DICE-Configuration-BO4CO/archive/master.zip
$ unzip master.zip
# This step is only to unify the result with the one from the git download
$ mv DICE-Configuration-BO4CO-master DICE-Configuration-BO4CO
$ cd DICE-Configuration-BO4CO
```

### Installation

First the install MCR on the platform you intends to runt he tool, e.g., here is the instructions for `ubuntu`: 

```bash
$ cd DICE-Configuration-BO4CO
$ ./install_mcr.sh
```

Then the compiled main file needs to get copied to the `src` folder:

```bash
$ cd DICE-Configuration-BO4CO/
$ cp deploy/ubuntu64/main deploy/ubuntu64/* src
$ cp deploy/run_bo4co.sh src
```

### Tool configuration

The user of the tool needs to configure BO4CO by specifying the configuration parameters at the following input configuration file:

```bash
$ vim conf/expconfig.yaml
```

### Starting BO4CO

To run BO4CO you just need to run the following bash script:


```bash
$ vim src/run_bo4co.sh
```

## Documentation 
[wiki](https://github.com/dice-project/DICE-Configuration-BO4CO/wiki)

## [Paper](https://arxiv.org/pdf/1606.06543v1)
For more technical details about the approach that has been implemented in the tool please refer to:
```
P. Jamshidi, G. Casale, "An Uncertainty-Aware Approach to Optimal Configuration of Stream Processing Systems", in Proc. of IEEE MASCOTS, (September 2016).
```

If you are looking for the DevOps enabled configuration optimization tool, please refer to:
[TL4CO](https://github.com/dice-project/DICE-Configuration-TL4CO)

## Contact

If you notice a bug, want to request a feature, or have a question or feedback, please send an email to pooyan.jamshidi@gmail.com. We would like to hear from people using our code.

## Licence

The code is published under the [FreeBSD License](https://github.com/dice-project/DICE-Configuration-BO4CO/blob/master/LICENSE.txt).
