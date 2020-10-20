class SortableController < ApplicationController

  VERIFIER = Rails.application.message_verifier(:rails_sortable_generate_sortable_id)

  def reorder
  	 ActiveRecord::Base.transaction do
  	 	logger.debug("INSIDE REORDER #{params[:sortable][:test_cases].inspect}")
  	 	tc_id = params[:sortable][:test_cases]
  	 	#position = 0 
  	 	tc_id.each_with_index do |t_id, index|
  	 		logger.debug("INSIDE TestCase ID t_id #{t_id}, index #{index}")
  	 		TestCase.where(id: t_id).update(position: index+1)
  	 		 #t = TestCase.where(id: t_id)
  	 		 #t.priority = index+1 
  	 		 #t.save!
  	 		 #logger.debug("AFTER SAVE #{t.inspect}")
  	 		 #TestCase.update_all({position: index+1}, {id: t_id})
  	 	end
      #params['rails_sortable'].each_with_index do |token, new_sort|
       #next unless token.present?
        
        #model = find_model(token)
        #current_sort = model.read_attribute(model.class.sort_attribute)
        #model.update_sort!(new_sort) if current_sort != new_sort
      #end
    end

    head :ok

  end
private

  def find_model(token)
    klass, id = VERIFIER.verify(token).match(/class=(.+),id=(.+)/)[1..2]
    klass.constantize.find(id)
  end

end
