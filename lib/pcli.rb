# frozen_string_literal: true

require 'zeitwerk'
require 'pastel'
require 'tty-screen'
require 'tty-which'
require 'action_view'
require 'tty-spinner'
require 'dry/cli'
require 'tty-table'
require 'tty-option'
require 'http'
require 'rqrcode'
require 'tty-prompt'
require 'active_support/core_ext/module/delegation'
require 'active_support/core_ext/string/inflections'
require 'tty-command'
require 'tty-editor'

loader = Zeitwerk::Loader.for_gem
loader.setup

module Pcli
end
