require 'enumerator'

module Cucumber
  module FeatureElement
    def attach_steps(steps)
      steps.each {|step| step.feature_element = self}
    end

    def file_colon_line(line = @line)
      @feature.file_colon_line(line) if @feature
    end

    def text_length
      name_line_lengths.max
    end

    def first_line_length
      name_line_lengths[0]
    end

    def name_line_lengths
      if @name.empty?
        [@keyword.jlength]
      else
        @name.split("\n").enum_for(:each_with_index).map do |line, line_number| 
          line_number == 0 ? @keyword.jlength + line.jlength : line.jlength + Ast::Step::INDENT
        end
      end
    end

    def matches_scenario_names?(scenario_names)
      scenario_names.detect{|name| name == @name}
    end

    def backtrace_line(name = "#{@keyword} #{@name}", line = @line)
      @feature.backtrace_line(name, line) if @feature
    end

    def source_indent(text_length)
      max_line_length - text_length
    end

    def max_line_length
      @steps.max_line_length(self)
    end

    def accept_hook?(hook)
      @tags.accept_hook?(hook)
    end

    # TODO: Remove when we use StepCollection everywhere
    def previous_step(step)
      i = @steps.index(step) || -1
      @steps[i-1]
    end
    
  end
end
