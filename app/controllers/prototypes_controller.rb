class PrototypesController < ApplicationController
  before_action :find_prototype, only: [:show, :edit, :update] 
  before_action :authenticate_user!, except: [:index, :show ]

  def index
    @prototypes = Prototype.includes(:user)
  end

  def new
    @prototype = Prototype.new
  end

  def create
    @prototype = Prototype.new(prototype_params)
    if @prototype.save
      redirect_to root_path
    else
      @prototype = Prototype.new(prototype_params)
      render :new
    end
  end

  def show
    @comment = Comment.new
    @comments = @prototype.comments.includes(:user)
  end

  def edit
    unless user_signed_in? && @prototype.user_id == current_user.id
      redirect_to action: :index
    end
  end

  def update
    if @prototype.update(prototype_params)
      redirect_to prototype_path(params[:id])
    else
      render :edit
    end
  end

  def destroy
    @prototype = Prototype.find(params[:id])
    @prototype.destroy
    redirect_to root_path
  end

  private

  def prototype_params
    params.require(:prototype).permit(:title, :catch_copy, :concept, :image).merge(user_id: current_user.id)
  end

  def find_prototype
    @prototype = Prototype.find(params[:id])
  end
end
