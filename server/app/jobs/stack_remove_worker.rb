require_relative '../mutations/stacks/sort_helper'

class StackRemoveWorker
  include Celluloid
  include Logging
  include Stacks::SortHelper

  def perform(stack_id)
    stack = Stack.find_by(id: stack_id)
    if stack
      stop_stack(stack)
      remove_stack(stack)
    end
  end

  def stop_stack(stack)
    stack.grid_services.each do |service|
      GridServices::Stop.run(grid_service: service)
    end
  end

  def remove_stack(stack)
    services = sort_services(stack.grid_services.to_a).reverse
    services.each do |service|
      outcome = GridServices::Delete.run(grid_service: service)
      if outcome.success?
        begin
          Timeout::timeout(600) do
            sleep 1 until GridService.find_by(id: service.id).nil?
          end
        rescue Timeout::Error
          error "Removing of #{service.to_path} timed out"
        end
      else
        error "Cannot remove service #{service.to_path}: #{outcome.errors.message}"
      end
    end
    if stack.grid_services.count == 0
      stack.destroy
    end
  end
end
