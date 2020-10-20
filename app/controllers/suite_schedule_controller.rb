class SuiteScheduleController < ApplicationController
    include FormatConcern
    protect_from_forgery with: :null_session

    # def create_suite_schedule
    #     begin
    #         @suite_schedule = SuiteSchedule.new(suite_schedule_params(params[:suite_schedule]).except(:id))
    #          if @suite_schedule.save
    #             schedule_immediately = params[:schedule_immediately]
    #             if schedule_immediately
    #                 Scheduler.create_new_schedule(@suite_schedule.test_suite_id, @suite_schedule.start_date)
    #             end
    #             render json: format_response_json({
    #                 message: 'Suite scheduled succesfully!',
    #                 status: true,
    #                 result: @suite_schedule
    #             })
    #          else 
    #             render json: format_response_json({
    #                 message: 'Failed to schedule a new suite!',
    #                 status: false
    #             })
    #          end
    #     rescue
    #         render json: format_response_json({
    #             message: 'Failed to schedule a new suite!',
    #             status: false
    #         })
    #     end
    # end


    def create_suite_schedule
        environ_id = id = session[:enviro_id]
        @suite_schedule = SuiteSchedule.new(suite_schedule_params(params[:suite_schedule]).except(:id))
        respond_to do |format|
            if @suite_schedule.save
                schedule_immediately = params[:schedule_immediately]
                if schedule_immediately
                    Scheduler.create_new_schedule(@suite_schedule.test_suite_id, @suite_schedule.start_date)
                end
                format.html {redirect_to "/test_suites"}
                # format.json { render json: 
                #     message: 'Suite scheduled succesfully!',
                #     status: true,
                #     result: @suite_schedule
                # }
            end
        end
    end

    def get_suite_schedules
        begin
            search_term = params[:search][:value]
            skip = params[:start]
            take = params[:length]
            draw = params[:draw]
    
            @total_data = SuiteSchedule.where(:active=> true, :test_suite_id=> params[:suite_id])
            if !search_term.empty?
                @total_data = @total_data.where('name LIKE ?',  "%#{search_term}%")
            end
            @total_data = @total_data.order(:id)
    
            total_items = @total_data.count
            @filtered_data =@total_data.offset(skip).limit(take).select(:id, :test_suite_id, :name, :start_date, :end_date, :time).as_json
    
            render json: {
                draw: draw,
                recordsTotal: total_items,
                recordsFiltered: total_items,
                data: @filtered_data
            }
        rescue
            render json: format_response_json({
                message: 'Failed to get suite schedules!',
                status: false
            })
        end
    end

    def update_suite_schedule
        begin
            @suite_schedule = params[:suite_schedule]
            success = SuiteSchedule.find(@suite_schedule[:id]).update_attributes(suite_schedule_params(@suite_schedule))

            if(success)
                render json: format_response_json({
                    message: 'Suite schedule updated!',
                    status: true,
                    result: @suite_schedule
                })
            else        
                render json: format_response_json({
                    message: 'Failed to update suite schedule!',
                    status: false
                })
            end
        rescue 
            render json: format_response_json({
                message: 'Failed to update suite schedule!',
                status: false
            })
        end
    end

    def delete_suite_schedule
        begin
            @suite_schedule = SuiteSchedule.find(params[:id])
            if !@suite_schedule.nil?
                @suite_schedule.active = false
                @suite_schedule.save
            end

            render json: format_response_json({
                message: 'Schedule deleted succesfully!',
                status: true
            })
        rescue
            render json: format_response_json({
                message: 'Failed to delete the schedule!',
                status: false
            })
        end
    end

    private 

    def suite_schedule_params(suite_schedule)
        suite_schedule.permit([:id, :test_suite_id, :name, :start_date, :end_date, :time])
    end
end
  