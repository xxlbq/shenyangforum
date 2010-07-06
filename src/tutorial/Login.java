package tutorial;

import com.opensymphony.xwork2.ActionSupport;

public class Login extends ActionSupport {
    private String name;
    private String password;
    private String message;
    
    public String getName() {
        return name;
    }
    
    public void setName(String name) {
        this.name = name;
    }
    
    public String getPassword() {
        return password;
    }
    
    public void setPassword(String password) {
        this.password = password;
    }
    
    public String getMessage() {
        return message;
    }

    @Override
    public String execute() {
    	
    	
    	
//    	HttpServletRequest request = ServletActionContext.getRequest(); 
//    	HttpServletResponse response = ServletActionContext.getResponse(); 
//    	HttpSession session = request.getSession();
//    	如果你只是想访问session的属性（Attribute），你也可以通过ActionContext.getContext().getSession()获取或添加session范围（Scoped）的对象。

    	
    	
    	
    	
    	
    	
        if("111".equals(name) &&"111".equals(password)) {
            message ="Welcome, "+ name;
        }else{
            message ="Invalid user or password";
        }
        return SUCCESS;
    }
    
    
    
    
    
}