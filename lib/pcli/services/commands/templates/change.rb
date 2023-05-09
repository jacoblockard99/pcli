# frozen_string_literal: true

module Pcli
  module Services
    module Commands
      module Templates
        class Change < Dry::CLI::Command
          include Depends.on(
            'api',
            'api_manager',
            'output',
            'screen',
            'editor',
            'prompt'
          )

          desc 'Change or view a template.'

          argument :template, desc: 'The template id to change.'

          def call(template: nil, **args)
            response = api_manager.ensure_authenticated do
              spinner = SimpleSpinnerBar.start('Retrieving templates...', output)
              r = api.templates
              if r.failure?
                spinner.failure
              else
                spinner.success
              end
              r
            end

            if response.failure?
              output.puts
              Output::ServerError.show(response, output, screen)
            end

            templates = response.json

            unless template
              choices = templates.map { |t| { name: "#{t['name']} (#{t['id']})", value: t['id'] } }
              template = prompt.select('Which template would you like to view/change?', choices)
            end

            template = templates.find { |t| t['id'] === template }
            unless template
              output.puts(Pl.yellow('That template does not exist.'))
              return CommandOutput.continue
            end

            file = Tempfile.new('pcli_open_template')
            file.write(template['templateXML'])
            file.close

            unless editor.open(file.path)
              output.puts('Aborted.')
              return CommandOutput.continue
            end

            file.open
            new_template = file.read

            if template['templateXML'] == new_template
              output.puts('Nothing to change.')
              return CommandOutput.continue
            end

            unless prompt.yes?('Save changes?')
              output.puts('Aborted.')
              return CommandOutput.continue
            end

            response = api_manager.ensure_authenticated do
              spinner = SimpleSpinnerBar.start('Changing template...', output)
              r = api.change_template(template['id'], { 'templateXML' => new_template })
              if r.failure?
                spinner.failure
              else
              spinner.success("Template #{Pl.green('changed')}")
              end
              r
            end

            if response.failure?
              output.puts
              Output::ServerError.show(response, output, screen)
            end

            CommandOutput.continue
          end
        end
      end
    end
  end
end
