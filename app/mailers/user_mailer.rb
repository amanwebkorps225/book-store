class UserMailer < ApplicationMailer
    def welcome(user)
        @user= user
        mail(to:@user.email, subject:"Welcome new user")
    end
    
     def signin(user)
        @user= user
        mail(to:@user.email, subject:"sign successfully")
        
     end

     def buybook(user)
        @user= user
        @a = Bought.last
         @b = @a.book_id
         @boughtbook= Book.find(@b)
        mail(to:@user.email, subject:"Successfully buy book")        
     end

       
end
