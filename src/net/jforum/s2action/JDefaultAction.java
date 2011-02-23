package net.jforum.s2action;

import java.io.IOException;
import java.io.Writer;
import java.sql.Connection;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.jforum.ControllerUtils;
import net.jforum.DBConnection;
import net.jforum.ForumStartup;
import net.jforum.JForumExecutionContext;
import net.jforum.SessionFacade;
import net.jforum.context.JForumContext;
import net.jforum.context.RequestContext;
import net.jforum.context.ResponseContext;
import net.jforum.context.web.WebRequestContext;
import net.jforum.context.web.WebResponseContext;
import net.jforum.entities.Banlist;
import net.jforum.exceptions.ForumException;
import net.jforum.exceptions.TemplateNotFoundException;
import net.jforum.repository.BanlistRepository;
import net.jforum.repository.SecurityRepository;
import net.jforum.repository.Tpl;
import net.jforum.util.I18n;
import net.jforum.util.preferences.ConfigKeys;
import net.jforum.util.preferences.SystemGlobals;
import net.jforum.util.preferences.TemplateKeys;

import com.opensymphony.xwork2.ActionSupport;
import com.opensymphony.xwork2.util.logging.Logger;

import freemarker.template.SimpleHash;
import freemarker.template.Template;

public class JDefaultAction extends ActionSupport{
	
	
	
	private static boolean isDatabaseUp;
	protected String templateName;
	protected RequestContext request;
	protected ResponseContext response;
	protected SimpleHash context;
	
	
	public String service(HttpServletRequest req, HttpServletResponse res) throws IOException, ServletException
	{
		Writer out = null;
		JForumContext forumContext = null;
//		RequestContext request = null;
//		ResponseContext response = null;
		String encoding = SystemGlobals.getValue(ConfigKeys.ENCODING);

		try {
			// Initializes the execution context
			JForumExecutionContext ex = JForumExecutionContext.get();

			request = new WebRequestContext(req);
            response = new WebResponseContext(res);

			this.checkDatabaseStatus();

            forumContext = new JForumContext(request.getContextPath(),
                SystemGlobals.getValue(ConfigKeys.SERVLET_EXTENSION),
                request,
                response
            );
            ex.setForumContext(forumContext);
            
			// Check if we're in fact up and running
			Connection conn = DBConnection.getImplementation().getConnection();
//			DBConnection.getImplementation().releaseConnection(conn);
			conn.setAutoCommit(!SystemGlobals.getBoolValue(ConfigKeys.DATABASE_USE_TRANSACTIONS));
			ex.setConnection(conn);
			
            JForumExecutionContext.set(ex);

			// Setup stuff
			context = JForumExecutionContext.getTemplateContext();
			
			ControllerUtils utils = new ControllerUtils();
			utils.refreshSession();
			
			context.put("logged", SessionFacade.isLogged());
			
			// Process security data
			SecurityRepository.load(SessionFacade.getUserSession().getUserId());

			utils.prepareTemplateContext(context, forumContext);

//			String module = request.getModule();
//			
//			// Gets the module class name
//			String moduleClass = module != null 
//				? ModulesRepository.getModuleClass(module) 
//				: null;
			
//			if (moduleClass == null) {
//				// Module not found, send 404 not found response
//				response.sendError(HttpServletResponse.SC_NOT_FOUND);
//			}
//			else {
				boolean shouldBan = this.shouldBan(request.getRemoteAddr());
				
				if (!shouldBan) {
//					context.put("moduleName", module);
//					context.put("action", request.getAction());
				}
				else {
//					moduleClass = ModulesRepository.getModuleClass("forums");
//					context.put("moduleName", "forums");
					((WebRequestContext)request).changeAction("banned");
				}
				
				if (shouldBan && SystemGlobals.getBoolValue(ConfigKeys.BANLIST_SEND_403FORBIDDEN)) {
					response.sendError(HttpServletResponse.SC_FORBIDDEN);
					return ERROR;
				}
				else {
					context.put("language", I18n.getUserLanguage());
					context.put("session", SessionFacade.getUserSession());
					context.put("request", req);
					context.put("response", response);
					
//					out = this.processCommand(out, request, response, encoding, context);
					req.setAttribute("forumdata", context);
					
					return SUCCESS;
					
				}
				
			}
//		}
		catch (Exception e) {
			this.handleException(out, response, encoding, e, request);
			return ERROR;
		}
	
	}
	private void handleException(Writer out, ResponseContext response2,
			String encoding, Exception e, RequestContext request2) {
		// TODO Auto-generated method stub
		
	}
	private boolean shouldBan(String ip)
	{
		Banlist b = new Banlist();
		
		b.setUserId(SessionFacade.getUserSession().getUserId());
		b.setIp(ip);
		
		return BanlistRepository.shouldBan(b);
	}
	private void checkDatabaseStatus()
	{
		if (!isDatabaseUp) {
			synchronized (this) {
				if (!isDatabaseUp) {
					isDatabaseUp = ForumStartup.startDatabase();
				}
			}
		}
	}
	
	
	protected void setTemplateName(String templateName)
	{
		this.templateName = Tpl.name(templateName);
	}
	protected void handleFinally() throws IOException
	{
		try {
//			if (out != null) { out.close(); }
		}
		catch (Exception e) {
		    // catch close error 
		}
		
//		String redirectTo = JForumExecutionContext.getRedirectTo();
		JForumExecutionContext.finish();
		
//		if (redirectTo != null) {
//			if (forumContext != null && forumContext.isEncodingDisabled()) {
//				response.sendRedirect(redirectTo);
//			} 
//			else {
//				response.sendRedirect(response.encodeRedirectURL(redirectTo));
//			}
//		}
	}
	private boolean ignoreAction;
	private static Class[] NO_ARGS_CLASS = new Class[0];
	private static Object[] NO_ARGS_OBJECT = new Object[0];
	protected void ignoreAction()
	{
		this.ignoreAction = true;
	}
	public Template process(RequestContext request, ResponseContext response, SimpleHash context)
	{
		this.request = request;
		this.response = response;
		this.context = context;
		
		String action = this.request.getAction();

		if (!this.ignoreAction) {
			try {
				this.getClass().getMethod(action, NO_ARGS_CLASS).invoke(this, NO_ARGS_OBJECT);
			}
			catch (NoSuchMethodException e) {
				
//				this.list();		
			}
			catch (Exception e)
            {
                throw new ForumException(e);
			}
		}
		
		if (JForumExecutionContext.getRedirectTo() != null) {
			this.setTemplateName(TemplateKeys.EMPTY);
		}
		else if (request.getAttribute("template") != null) {
			this.setTemplateName((String)request.getAttribute("template"));
		}
		
		if (JForumExecutionContext.isCustomContent()) {
			return null;
		}
		
		if (this.templateName == null) {
			throw new TemplateNotFoundException("Template for action " + action + " is not defined");
		}

        try {
//            return JForumExecutionContext.templateConfig().getTemplate(
//                new StringBuffer(SystemGlobals.getValue(ConfigKeys.TEMPLATE_DIR)).
//                append('/').append(this.templateName).toString());
        	
        	return null;
        }
        catch (Exception e) {
            throw new ForumException( e);
        }
    }
	
	
}
