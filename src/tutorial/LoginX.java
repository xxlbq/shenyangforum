package tutorial;

import com.opensymphony.xwork2.ActionSupport;

public class LoginX extends ActionSupport {
    private User user;
    private String message;
    
    public void setUser(User user) {
        this.user = user;
    }
    
    public User getUser() {
        return user;
    }
    
    public String getMessage() {
        return message;
    }
    
    @Override
    public String execute() {
    	
        if("111".equals(user.getName()) &&"111".equals(user.getPassword())) {
            message ="Welcome, "+ user.getName();
        }else{
            message ="Invalid user or password";
        }
        return SUCCESS;
    }
}
