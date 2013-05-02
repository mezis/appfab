require 'rake'

Rake::DSL.module_eval do
  def task_with_raven(*args, &block)
    task_without_raven(*args) do |*block_args|
      Raven.capture do
        block.call(*block_args)
      end
    end
  end

  alias_method_chain :task, :raven
end
