class SessionController < ApplicationController

 def login 
  render 'login'
 end

 def login_user
  object = params[:user]
  user = User.authenticate(object[:email], object[:password])
	if user
		session[:user_id] = user[:id]
		
	    if(user[:type] == 1) #admin
	       redirect_to 'admin/index'
	    end
	    if(user[:type] == 2) #salesman
	       redirect_to 'salesman/index'
	    end
	    if(user[:type] == 3) #accountant
	    	redirect_to 'accountant/index'
	    end
	    if(user[:type] === 4) #collector
	    	redirect_to 'collector/index'
	    end
    else
	#render text: params[:user].inspect
        flash.now.alert = "Invalid email or password"
        render 'login'
	end
 end

 def destroy_user
  session[:user_id] = nil
  render 'login'
 end

end
