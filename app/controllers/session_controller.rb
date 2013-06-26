class SessionController < ApplicationController

 def login 
  render 'login'
 end

 def login_user
  obiect = params[:user]
  user = User.authenticate(obiect[:email], obiect[:password])
	if client
		session[:client_id] = client[:id]
		
	    if(client[:type] == 1) #admin
	       redirect_to 'admin/index'
	    end
	    if(client[:type] == 2) #salesman
	       redirect_to 'salesman/index'
	    end
	    if(client[:type] == 3) #accountant
	    	redirect_to 'accountant/index'
	    end
	    if(client[type] === 4) #collector
	    	redirect_to 'collector/index'
	    end
    else
        flash.now.alert = "Invalid email or password"
        render 'login'
	end
 end

 def destroy_user
  session[:user_id] = nil
  render 'login'
 end

end
