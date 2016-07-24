import unittest
import os
import tempfile

from merge_expconfig import *

class TestExpConfMerge(unittest.TestCase):

    @classmethod
    def setUpClass(cls):
        base_path = os.path.dirname(os.path.realpath(__file__))
        file_path = os.path.join(base_path, 'files')

        def fpath(*names):
            return os.path.join(file_path, *names)

        cls.test_file_prefix = "files/"

        cls.test_co_config_files = {
            "normal": fpath("co-config.yaml")
        }
        cls.test_app_config_files = {
            "minimal": fpath("app-config-minimal.yaml"),
            "mixed": fpath("app-config-mixed.yaml"),
            "mixed-nimbus": fpath("app-config-nimbus.yaml")
        }
        cls.test_expconfig_files = {
            "full": fpath("expconfig-full.yaml"),
            "full-nimbus": fpath("expconfig-full-nimbus.yaml"),
        }

    def test_full_merge(self):
        """
        Both source files have a disjunct set of parameters.
        """
        co_config_file = self.test_co_config_files["normal"]
        app_config_file = self.test_app_config_files["minimal"]

        with tempfile.NamedTemporaryFile('w', delete=True) as f_expconfig:
            expconfig_file = f_expconfig.name
            merge_config(co_config_file, app_config_file, expconfig_file)

            expconfig = load_yaml(expconfig_file)
            self.assertIsNotNone(expconfig)

            expconfig_expected = load_yaml(self.test_expconfig_files["full"])

            self.maxDiff = None
            self.assertEqual(expconfig_expected, expconfig)

    def test_mixed_merge(self):
        """
        Some of the parameters in the application's config are the ones
        belonging to the CO configuration. This should be overwritten
        in the merge.
        """
        co_config_file = self.test_co_config_files["normal"]
        app_config_file = self.test_app_config_files["mixed"]

        with tempfile.NamedTemporaryFile('w', delete=True) as f_expconfig:
            expconfig_file = f_expconfig.name
            merge_config(co_config_file, app_config_file, expconfig_file)

            expconfig = load_yaml(expconfig_file)

            expconfig_expected = load_yaml(self.test_expconfig_files["full"])

            self.maxDiff = None
            self.assertEqual(expconfig_expected, expconfig)

    def test_mixed_nimbus_merge(self):
        """
        Some of the parameters in the application's config are the ones
        belonging to the CO configuration. This should be overwritten
        in the merge. Additionally, the application defines the
        Storm nimbus as an external service, which should be preserved
        in the final output.
        """
        co_config_file = self.test_co_config_files["normal"]
        app_config_file = self.test_app_config_files["mixed-nimbus"]

        with tempfile.NamedTemporaryFile('w', delete=True) as f_expconfig:
            expconfig_file = f_expconfig.name
            merge_config(co_config_file, app_config_file, expconfig_file)

            expconfig = load_yaml(expconfig_file)

            expconfig_expected = load_yaml(
                self.test_expconfig_files["full-nimbus"])

            self.maxDiff = None
            self.assertEqual(expconfig_expected, expconfig)
