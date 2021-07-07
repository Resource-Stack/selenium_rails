# frozen_string_literal: true

class TermsAndConditionsController < ApplicationController
  include FormatConcern
  skip_before_action :authenticate_user!, only: [:terms_and_conditions]

  def terms_and_conditions; end

  def acknowledge_terms
    current_user.terms_acknowledged = true
    current_user.save!
    redirect_to root_path
  rescue StandardError
    redirect_to root_path
  end
end
