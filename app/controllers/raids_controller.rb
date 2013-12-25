class RaidsController < ApplicationController

  def index
    @raids = Raid.all
  end

  def new
    @raid = Raid.new
  end

  def create
    @raid= Raid.new(raid_params)

    if @raid.save
      redirect_to @raid
    else
      render :new
    end
  end

  def show
    @raid = Raid.find_by_param(params[:id])
  end

  protected

  def raid_params
    params.require(:raid).permit(:name, :tier)
  end

end