package tutorial;

import com.opensymphony.xwork2.ActionSupport;

public class AuthorizatedAccess extends ActionSupport implements RoleAware  {
    private String role;
   
    public void setRole(String role)  {
        this .role = role;
   } 
   
    public String getRole()  {
        return role;
   } 

   @Override
    public String execute()  {
        return SUCCESS;
   } 
} 