package tutorial;

import com.opensymphony.xwork2.ActionSupport;

public class TimerInterceptorAction extends ActionSupport  {
   @Override
    public String execute()  {
        try  {
            // 模拟耗时的操作 
           Thread.sleep( 500 );
       } catch (Exception e)  {
           e.printStackTrace();
       } 
        return SUCCESS;
   } 
} 