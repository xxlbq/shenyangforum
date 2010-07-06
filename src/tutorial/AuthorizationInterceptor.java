package tutorial;

import java.util.Map;

import com.opensymphony.xwork2.Action;
import com.opensymphony.xwork2.ActionInvocation;
import com.opensymphony.xwork2.interceptor.AbstractInterceptor;

public class AuthorizationInterceptor extends AbstractInterceptor  {

   @Override
    public String intercept(ActionInvocation ai) throws Exception  {
	   
       Map session = ai.getInvocationContext().getSession();
       
       String role = (String) session.get( " ROLE " );
       
        if ( null != role)  {
           Object o = ai.getAction();
            if (o instanceof RoleAware)  {
               RoleAware action = (RoleAware) o;
               action.setRole(role);
           } 
            return ai.invoke();
       } else  {
            return Action.LOGIN;
       }        
   } 

} 