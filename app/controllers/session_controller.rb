class SessionController < ApplicationController
  skip_before_filter :require_login, :only => [:login, :login_user, :create, :signup, :home]

	
 def signup
		@user = User.new
 end

    def create
		# render text: params[:post].inspect
		pass = {}
		object = params[:user]
		@user = User.new
		@user.email = object[:email]
		@user.password = object[:password] 
		@user.first_name = object[:first_name]
		@user.last_name = object[:last_name]
		@user.job = 1
		@user.company_id = 0
		
			if @user.save 
				session[:user_id] = @user[:id]
				redirect_to company_new_path 
			else 
				render 'signup'
			end
		#redirect_to company_new_path
	end
	  
	def login 
    	render 'login'
    end
  
    def home
        if user = current_user 
            if(user[:company_id]==0)
 		     	redirect_to company_new_path
 		    else 
	 		    if(user[:job] == 1)
	 		    	redirect_to admin_path
	 		    else 
	 		    	redirect_to users_path
	 		    end
	 		end
        else
            render 'login'
        end
    end
    
 def login_user
	object = params[:user]
	user = User.authenticate(object[:email], object[:password])
	
	if(user) 
 		session[:user_id] = user[:id]
 		if(user[:company_id]==0)
 			redirect_to company_new_path
 		else 
	 		if(user[:job] == 1)
	 			redirect_to admin_path
	 		else 
	 			redirect_to users_path
	 		end
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
