class GroupsController < ApplicationController
  before_action :authenticate_user! , only: [:new] 
  before_action :set_group,  only: [:edit, :show, :update, :destroy]

  def index
    @groups = Group.all
  end

  def new
    @group = Group.new
  end




  def create
    @group = Group.new(group_params)
    if @group.save
      redirect_to groups_path
    else
      render :new
    end
  end

  def edit
  end
  def show

  end
  def update
    if @group.update(group_params)
      redirect_to groups_path, notice: "update success!"
    else
      render :edit
    end
  end

  def destroy
    @group.destroy
    redirect_to groups_path, notice: "Delete"

  end
  private
  def set_group
    @group = Group.find(params[:id])
  end

  def group_params
    params.require(:group).permit(:title, :description)
  end
end
