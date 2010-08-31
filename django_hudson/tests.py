# -*- coding: utf-8 -*-
from django.test import TestCase

from django_hudson.management.commands.hudson import Command as HudsonCommand

class SanityCheckTest(TestCase):
    def test_is_ok(self):
        pass

class HudsonCommandTests(TestCase):

    def setUp(self):
        import sys, os
        from os import path
        from django.utils import cache
        import django_hudson
        import django.test

        self.modules = {
            'sys': sys,
            'os': os,
            'cache': cache,
            'os.path': path,
            'django_hudson.management.commands.hudson': django_hudson.management.commands.hudson, 
            'django.test': django.test,
        }
        self.command = HudsonCommand()

    def assertModulesExcluded(self, exclusions, module_list):
        module_list = [ module.__name__ for module in module_list ]
        for exclude in exclusions:
            self.assert_(exclude not in module_list, "%s is in %s" % (exclude, module_list))

    def test_exclusion(self):
        excludes = ["sys", "os", "django.test"]
        should_exclude = ['sys', 'os', 'os.path', 'django.test']

        modules = [ module for module in self.modules.values() if 
                    self.command.want_module(module, excludes=excludes) ]
        self.assertModulesExcluded(should_exclude, modules)
        