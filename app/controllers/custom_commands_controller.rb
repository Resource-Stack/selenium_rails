# frozen_string_literal: true

class CustomCommandsController < ApplicationController
  def create
    @custom_command = CustomCommand.create(custom_command_params)
    @custom_command.environment_id = params[:environment_id]
    @custom_command.parameters = params[:parameters].join(',')
    @custom_command.save
  end

  def show; end

  def custom_commands; end

  def edit
    @id = params[:id]
    @custom = CustomCommand.where(environment_id: @id)
  end

  def update; end

  private

  def custom_command_params
    params.require(:custom_command).permit(:name, :command, :parameters)
  end
end
