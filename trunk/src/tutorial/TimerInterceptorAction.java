package tutorial;

import com.opensymphony.xwork2.ActionSupport;

public class TimerInterceptorAction extends ActionSupport  {
   @Override
    public String execute()  {
        try  {
            // ģ���ʱ�Ĳ��� 
           Thread.sleep( 500 );
       } catch (Exception e)  {
           e.printStackTrace();
       } 
        return SUCCESS;
   } 
} 