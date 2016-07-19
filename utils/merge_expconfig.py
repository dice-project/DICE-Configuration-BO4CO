#!/usr/bin/env python

# This tool can be used for merging the fixed installation configuration of
# the BO4CO with the configuration specific for each application. The result
# is an extconfig.yaml file usable in the BO4CO runtime.

import sys
import yaml
import copy
import argparse

def load_yaml(yaml_path):
    with open(yaml_path) as f:
        data = yaml.load(f)

    return data

def save_yaml(yaml_path, data):
    with open(yaml_path, 'w') as f:
        yaml.dump(data, f)

def merge_config(install_config_path, app_config_path, expconfig_path):
    co_config = load_yaml(install_config_path)
    app_config = load_yaml(app_config_path)

    def array2dict(arr, key):
        return { v[key]: v for v in arr }

    # any extra services requested by the application needs to be
    # transferred over, while the others have to be overwritten
    if "services" in app_config:
        app_config_services = array2dict(app_config["services"], "servicename")
        co_config_services = array2dict(co_config["services"],
            "servicename")
        app_config_services.update(co_config_services)

        co_config["services"] = app_config_services.values()
        co_config["services"].sort(key=lambda x:x["servicename"])
    else:
        # this is only necessary to make the test cases consistent
        co_config["services"].sort(key=lambda x:x["servicename"])

    co_config_modified = {
        "services": co_config["services"],
        "runexp": app_config["runexp"],
    }
    keys = co_config.keys()
    keys.remove("services")
    for k in keys:
        co_config_modified["runexp"][k] = co_config[k]

    expconfig = copy.deepcopy(app_config)
    expconfig.update(co_config_modified)

    save_yaml(expconfig_path, expconfig)


if __name__ == "__main__":
    parser = argparse.ArgumentParser(
        description='Generate a configuration file for configuration '
                'optimization from static configuration and application '
                'specific configuration.')
    group_mandatory = parser.add_argument_group('mandatory arguments')
    group_mandatory.add_argument('-c', '--co-config',
            help='Configuration file for the Configuration Optimization')
    group_mandatory.add_argument('-a', '--app-config',
            help='Specification of application and its parameters to be '
                'optimized.')
    group_mandatory.add_argument('-O', '--output-configuration',
            help='Output path to save the configuration of the Configuration '
                'Optimization into.')

    args = parser.parse_args()

    if not (args.co_config and args.app_config and args.output_configuration):
        parser.print_help()
        sys.exit(1)

    merge_config(
        install_config_path=args.co_config,
        app_config_path=args.app_config,
        expconfig_path=args.output_configuration)
