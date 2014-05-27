class InquiriesController < ApplicationController
  skip_before_action :authorize
  
  def new
    @inquiry = Inquiry.new
  end
    
  def create
    @inquiry = Inquiry.new(params[:inquiry])
    if @inquiry.deliver
      render :thank_you
    else
      render :new
    end
  end
  
end