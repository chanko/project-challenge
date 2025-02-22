class DogsController < ApplicationController
  before_action :set_dog, only: [
    :show, :edit, :update, :destroy, :like, :unlike
  ]

  before_action :check_dog_owner, only: [:edit, :update, :destroy]

  # GET /dogs
  # GET /dogs.json
  def index
    @pagy, @dogs = pagy(Dog.order(like_count: :desc), items: 5)
  end

  # GET /dogs/1
  # GET /dogs/1.json
  def show
  end

  # GET /dogs/new
  def new
    @dog = Dog.new
  end

  # GET /dogs/1/edit
  def edit
  end

  # POST /dogs
  # POST /dogs.json
  def create
    @dog = Dog.new(dog_params)

    respond_to do |format|
      if @dog.save
        format.html { redirect_to @dog, notice: 'Dog was successfully created.' }
        format.json { render :show, status: :created, location: @dog }
      else
        format.html { render :new }
        format.json { render json: @dog.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /dogs/1
  # PATCH/PUT /dogs/1.json
  def update
    respond_to do |format|
      if @dog.update(dog_params)
        @dog.images.attach(params[:dog][:images]) if params[:dog][:images].present?

        format.html { redirect_to @dog, notice: 'Dog was successfully updated.' }
        format.json { render :show, status: :ok, location: @dog }
      else
        format.html { render :edit }
        format.json { render json: @dog.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /dogs/1
  # DELETE /dogs/1.json
  def destroy
    @dog.destroy
    respond_to do |format|
      format.html { redirect_to dogs_url, notice: 'Dog was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def like
    Dog.increment_counter(:like_count, @dog.id)

    redirect_to dog_path(@dog)
  end

  def unlike
    Dog.decrement_counter(:like_count, @dog.id)

    redirect_to dog_path(@dog)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_dog
      @dog = Dog.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def dog_params
      params
        .require(:dog)
        .permit(:name, :description, images: [])
        .merge(owner: current_user)
    end

    def check_dog_owner
      msg = 'Action only allowed by owner'
      
      redirect_to dogs_path, alert: msg if @dog.owner != current_user
    end
end
