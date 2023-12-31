class FamiliesController < ApplicationController
  def new
    @code = Family.new

    authorize @code

    render layout: 'focus'
  end

  def create
    @family = Family.new(code: SecureRandom.urlsafe_base64(4))
    authorize @family
    if @family.save
      current_user.family = @family
      current_user.save!
      redirect_to profile_path, notice: "Family successfully created, send the code to your rival !"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def join_family
    @family_params = family_params
    @code = @family_params["code"]
    family_array = Family.where(code: @code)
    family = family_array.first
    if family_array.count == 1
      authorize family
      if family.users.count == 1
        current_user.family = family
        current_user.save!

        family.code = nil
        family.save!

        redirect_to profile_path, notice: "Welcome to your family"
      else
        render :new, alert: "Error during assignation of family"
      end
    else
      @family = Family.new(code: SecureRandom.urlsafe_base64(4))
      authorize @family
      redirect_to new_family_path, alert: "Error during assignation of family"
    end
  end

  def leave
    family = current_user.family

    if family.users.count == 1
      redirect_to profile_path, alert: "You cannot leave your family alone!"
    else
      family.code = SecureRandom.urlsafe_base64(4)
      family.save!
      current_user.family = nil
      current_user.save!
      redirect_to profile_path, notice: "You left your family"
    end
  end

  private

  def family_params
    params.require(:family).permit(:code)
  end
end
