# encoding: utf-8

require 'yaml'

unless defined?(PV_ROOT)
  PV_ROOT = File.dirname(__FILE__)
  $LOAD_PATH.unshift(PV_ROOT + "/lib")
end

PV_CONFIG = YAML.load_file("config.yaml") unless defined?(PV_CONFIG)
