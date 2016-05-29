class CallbacksController < Devise::OmniauthCallbacksController
 def failure
     redirect_to root_path
   end

 def facebook
    generic_callback( 'facebook' )
  end

def twitter
    generic_callback( 'twitter' )
  end

   def linkedin
    generic_callback( 'linkedin' )
  end

def instagram
    generic_callback( 'instagram' )
  end



 def generic_callback( provider )
    @user = User.from_omniauth(env["omniauth.auth"], current_user)
    if @user.persisted?
      flash[:notice] = "You are in..!!! Go to edit profile to see the status for the accounts"
      sign_in_and_redirect(@user)
    else
      session["devise.user_attributes"] = @user.attributes
      redirect_to new_user_registration_url
    end
end

end
