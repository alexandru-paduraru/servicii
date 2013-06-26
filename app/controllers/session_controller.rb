class SessionController < ApplicationController

 def login 
  render 'login'
 end

 def login_user
  object = params[:user]
  user = User.authenticate(object[:email], object[:password])
   
	if user
		session[:user_id] = user[:id]
	    if(user[:job] == 1) #admin
	       redirect_to admin_path
	    end
	    if(user[:job] == 2) #salesman
	       redirect_to salesman_path
	    end
	    if(user[:job] == 3) #accountant
	    	redirect_to accountant_path
	    end
	    if(user[:job] === 4) #collector
	    	redirect_to collector_path
	    end
    else
	#render text: params[:user].inspect
        flash.now.alert = "Invalid email or password"
        format.html {render 'login'}
	end
 
 end

 def destroy_user
  session[:user_id] = nil
  redirect_to login_path
 end

end
