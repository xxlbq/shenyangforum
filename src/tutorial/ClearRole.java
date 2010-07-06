package tutorial;

import com.opensymphony.xwork2.ActionContext;
import com.opensymphony.xwork2.ActionSupport;

public class ClearRole extends ActionSupport{

    @Override
    public String execute() {
    	
    	
    	
//    	HttpServletRequest request = ServletActionContext.getRequest(); 
//    	HttpServletResponse response = ServletActionContext.getResponse(); 
//    	HttpSession session = request.getSession();
//    	如果你只是想访问session的属性（Attribute），你也可以通过ActionContext.getContext().getSession()获取或添加session范围（Scoped）的对象。

    	ActionContext.getContext().getSession().remove(" ROLE ");

        return SUCCESS;
    }
}
