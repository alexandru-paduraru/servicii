class SessionController < ApplicationController

  def login 
   render 'login'
  end

 def login_user
	object = params[:user]
	user = User.authenticate(object[:email], object[:password])
	
	if(user) 
 		session[:user_id] = user[:id]
 		if(user[:job] == 1)
 			redirect_to admin_path
 		else 
 			redirect_to user_path
 		end
 	else
 		 flash.now.alert = "Invalid email or password"
 		 render 'login'
 	end
 	
 end

 def destroy_user
  session[:user_id] = nil
  redirect_to root_path
 end

end
