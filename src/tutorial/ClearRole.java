package tutorial;

import com.opensymphony.xwork2.ActionContext;
import com.opensymphony.xwork2.ActionSupport;

public class ClearRole extends ActionSupport{

    @Override
    public String execute() {
    	
    	
    	
//    	HttpServletRequest request = ServletActionContext.getRequest(); 
//    	HttpServletResponse response = ServletActionContext.getResponse(); 
//    	HttpSession session = request.getSession();
//    	�����ֻ�������session�����ԣ�Attribute������Ҳ����ͨ��ActionContext.getContext().getSession()��ȡ�����session��Χ��Scoped���Ķ���

    	ActionContext.getContext().getSession().remove(" ROLE ");

        return SUCCESS;
    }
}
