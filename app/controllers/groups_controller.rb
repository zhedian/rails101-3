class GroupsController < ApplicationController
  before_action :authenticate_user! , only: [:new, :create, :edit, :update, :destroy, :join, :quit]
  before_action :set_group,  only: [:edit, :show, :update, :destroy]
  before_action :check_user, only: [:edit, :update, :destroy]

  def index
    @groups = Group.all
  end

  def new
    @group = Group.new
  end




  def create
    @group = Group.new(group_params)
    @group.user = current_user
    if @group.save
      redirect_to groups_path
    else
      render :new
    end
  end

  def edit
  end
  def show
    @posts = @group.posts.recent.paginate(:page => params[:page], :per_page => 2)
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

  def join
    @group = Group.find(params[:id])

    if !current_user.is_member_of?(@group)
      current_user.join!(@group)
      flash[:notice] = "加入成功！"
    else
      flash[:warning] = "已经是了"
    end
    redirect_to group_path(@group)
  end

  def quit
    @group = Group.find(params[:id])
    if current_user.is_member_of?(@group)
      current_user.quit!(@group)
      flash[:alert] = "已退出"
    else
      flash[:warning] = "退不出"
    end
    redirect_to group_path(@group)
  end

  private
  def set_group
    @group = Group.find(params[:id])
  end

  def check_user
    if current_user != @group.user
      redirect_to root_path, alert: "You have no permission."
    end
  end

  def group_params
    params.require(:group).permit(:title, :description)
  end
end
