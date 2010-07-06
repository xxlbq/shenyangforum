package tutorial;

import com.opensymphony.xwork2.ActionSupport;

public class HelloWorld extends ActionSupport {
	
    private String name;
    private String message;
    
    public String getMessage()  {
        return message;
   } 
    public String getName() {
        return name;
    }
    
    public void setName(String name) {
        this.name = name;
    }
    
    
    
    
    
    
    
    public String execute() {
        name = "Hello, " + name + "!"; 
        return SUCCESS;
    }
    
    public String aliasAction() {
        message ="自定义Action调用方法";
        return SUCCESS;
    }
    
    public String vmAction() {
        message =name;
        return SUCCESS;
    }

}