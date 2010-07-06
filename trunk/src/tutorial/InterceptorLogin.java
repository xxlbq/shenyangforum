package tutorial;

import java.util.Map;

import org.apache.struts2.interceptor.SessionAware;

import com.opensymphony.xwork2.ActionSupport;

public class InterceptorLogin extends ActionSupport implements SessionAware  {
    private String role;    
    private Map session;

    public String getRole()  {
        return role;
   } 

     public void setRole(String role)  {
        this .role = role;
   } 
   
    public void setSession(Map session)  {
        this .session = session;
   } 

   @Override
    public String execute()  {
       session.put( " ROLE " , role);
        return SUCCESS;
   }    
} 