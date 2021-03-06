class ShiftsController < ApplicationController
  def index
    @shift = Shift.new
    shift_details
  end

  def create
    date = shift_params[:date]
    start_time = get_date_time(date, shift_params[:start])
    finish_time = get_date_time(date, shift_params[:finish])
    @shift = Shift.create(
      user_id: current_user.id, 
      start: start_time, 
      finish: finish_time, 
      break_length: shift_params[:break_length]
    )
    if @shift.save
      redirect_to shifts_path
    else
      shift_details
      render :index
    end
  end

  def edit
    @shift = Shift.find(params[:id])
  end

  def update
    date = shift_params[:date]
    start_time = get_date_time(date, shift_params[:start])
    finish_time = get_date_time(date, shift_params[:finish])
    @shift = Shift.update(
      params[:id],
      start: start_time,
      finish: finish_time,
      break_length: shift_params[:break_length]
    )
    if @shift.errors.any?
      render :edit
    else
      redirect_to shifts_path
    end
  end

  def destroy
    Shift.destroy(params[:id])
    redirect_to shifts_path
  end

  private

  def shift_params
    params.require(:shift).permit(:date, :start, :finish, :break_length)
  end

  
  def get_date_time(date, time)
    Time.zone.parse(date + " " + time)
  end

  # calc shift length
  def get_shift_duration(start, finish)
    # if shift starts and finishes on same day
    if start < finish
      (finish - start) / 60 / 60
    else 
      # if shift finishes the following day
      (finish.next_day() - start)/ 60 / 60
    end
  end

  # calc shift cost
  def get_shift_cost(start, finish, hours, rate, break_hrs)
    sun_hours = 0
    norm_hours = 0

    if start < finish
      if start.sunday?
        sun_hours = hours
      else
        norm_hours = hours
      end
    else
      # if shift finishes the following day
      real_finish = finish.next_day() - (60 * 60 * break_hrs)
      # if shift starts on sunday and finishes on monday
      if start.sunday? && real_finish.monday?
        sun_hours = (start.seconds_until_end_of_day + 1) / 60 / 60
      # if shift starts on saturday and finishes on sunday
      elsif start.saturday? && real_finish.sunday?
        sun_hours = real_finish.seconds_since_midnight / 60 / 60
      end
      # subtract sunday hours from hours to get normal hours
      norm_hours = hours - sun_hours
    end
    return (norm_hours * rate) + (2 * sun_hours * rate)
  end

  # display shift details, including date, start time, finish time, break length, hours worked, shift cost
  def shift_details
    # objects to store names, hours_worked, and shift_costs
    @names = {}
    @hours_worked = {}
    @shift_costs = {}
  
    @organization = Organization.find(current_user.organization_id)

    # query shifts for current org
    @shifts = Shift
      .includes(:user)
      .where(users: {organization_id: current_user.organization_id})
      .order(start: :asc)

    # iterate through shifts in current org
    @shifts.each do |shift|
      # break length in minutes
      break_l = Float(shift.break_length) / 60
      # shift length
      shift_duration = get_shift_duration(shift.start, shift.finish)
      # shift length - break length
      hours_worked = shift_duration - break_l
      # shift cost
      shift_cost = get_shift_cost(shift.start, shift.finish, hours_worked, @organization.hourly_rate, break_l)
      
      @names[shift] = User.find(shift.user_id).name
      @hours_worked[shift] = hours_worked.round(2)
      @shift_costs[shift] = shift_cost.round(2)
    end
  end
end
