package net.jforum.s2action;

import java.io.BufferedWriter;
import java.io.IOException;
import java.io.OutputStreamWriter;
import java.io.Writer;
import java.text.SimpleDateFormat;
import java.util.GregorianCalendar;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.jforum.Command;
import net.jforum.ControllerUtils;
import net.jforum.ForumStartup;
import net.jforum.JForumExecutionContext;
import net.jforum.JForumInitServlet;
import net.jforum.SessionFacade;
import net.jforum.context.JForumContext;
import net.jforum.context.RequestContext;
import net.jforum.context.ResponseContext;
import net.jforum.context.web.WebRequestContext;
import net.jforum.context.web.WebResponseContext;
import net.jforum.entities.Banlist;
import net.jforum.entities.MostUsersEverOnline;
import net.jforum.entities.UserSession;
import net.jforum.exceptions.ExceptionWriter;
import net.jforum.exceptions.ForumException;
import net.jforum.exceptions.TemplateNotFoundException;
import net.jforum.repository.BanlistRepository;
import net.jforum.repository.ForumRepository;
import net.jforum.repository.ModulesRepository;
import net.jforum.repository.SecurityRepository;
import net.jforum.repository.Tpl;
import net.jforum.util.I18n;
import net.jforum.util.preferences.ConfigKeys;
import net.jforum.util.preferences.SystemGlobals;
import net.jforum.util.preferences.TemplateKeys;
import net.jforum.view.forum.common.ForumCommon;

import org.apache.log4j.Logger;
import org.apache.struts2.ServletActionContext;

import com.opensymphony.xwork2.ActionSupport;

import freemarker.template.SimpleHash;
import freemarker.template.Template;

public class JForumAction extends ActionSupport {
	
	private static Logger logger = Logger.getLogger(JForumAction.class);
	private static boolean isDatabaseUp;
//    private String name;
//    private String message;
//    
//    public String getMessage()  {
//        return message;
//   } 
//    public String getName() {
//        return name;
//    }
//    
//    public void setName(String name) {
//        this.name = name;
//    }
    
    
	private static Class[] NO_ARGS_CLASS = new Class[0];
	private static Object[] NO_ARGS_OBJECT = new Object[0];
	
	private boolean ignoreAction;
	
	protected String templateName;
	protected RequestContext request;
	protected ResponseContext response;
	protected SimpleHash context;
	
	protected void setTemplateName(String templateName)
	{
		this.templateName = Tpl.name(templateName);
		
		logger.info("templateName in cache :"+templateName);
		
		this.templateName = "forum_list.htm";
		
		logger.info("templateName:"+templateName);
	}
	
	protected void ignoreAction()
	{
		this.ignoreAction = true;
	}
    
    
    
    public String list() {
    	logger.info("===========>  list method fired  <===========");
    	HttpServletRequest request = ServletActionContext.getRequest(); 
    	HttpServletResponse response = ServletActionContext.getResponse(); 
    	try {
//    		forumList();
			service(request, response);
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (ServletException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
//    	name = "Hello, " + name + "!"; 
        return SUCCESS;
    }
    


    
	
	
	
	
	
	
	
	public void service(HttpServletRequest req, HttpServletResponse res) throws IOException, ServletException
	{
		Writer out = null;
		JForumContext forumContext = null;
		RequestContext request = null;
		ResponseContext response = null;
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

            JForumExecutionContext.set(ex);

			// Setup stuff
			SimpleHash context = JForumExecutionContext.getTemplateContext();
			
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
				}
				else {
					context.put("language", I18n.getUserLanguage());
					context.put("session", SessionFacade.getUserSession());
					context.put("request", req);
					context.put("response", response);
					
					out = this.processCommand(out, request, response, encoding, context);
				}
			}
//		}
		catch (Exception e) {
			this.handleException(out, response, encoding, e, request);
		}
		finally {
			this.handleFinally(out, forumContext, response);
		}		
	}
	
	private Writer processCommand(Writer out, RequestContext request, ResponseContext response, 
			String encoding, SimpleHash context) throws Exception
	{
		// Here we go, baby
//		Command c = this.retrieveCommand(moduleClass);
		Template template = process(request, response, context);

		if (JForumExecutionContext.getRedirectTo() == null) {
			String contentType = JForumExecutionContext.getContentType();
			
			if (contentType == null) {
				contentType = "text/html; charset=" + encoding;
			}
			
			response.setContentType(contentType);
			
			// Binary content are expected to be fully 
			// handled in the action, including outputstream
			// manipulation
			if (!JForumExecutionContext.isCustomContent()) {
				out = new BufferedWriter(new OutputStreamWriter(response.getOutputStream(), encoding));
				template.process(JForumExecutionContext.getTemplateContext(), out);
				out.flush();
			}
		}
		
		return out;
	}
	
	
	public Template process(RequestContext request, ResponseContext response, SimpleHash context)
	{
		this.request = request;
		this.response = response;
		this.context = context;
		
//		String action = this.request.getAction();

//		if (!this.ignoreAction) {
//			try {
//				this.getClass().getMethod(action, NO_ARGS_CLASS).invoke(this, NO_ARGS_OBJECT);
//			}
//			catch (NoSuchMethodException e) {		
//				this.list();		
//			}
//			catch (Exception e)
//            {
//                throw new ForumException(e);
//			}
//		}
		
		forumList();
		
		if (JForumExecutionContext.getRedirectTo() != null) {
			this.setTemplateName(TemplateKeys.EMPTY);
		}
		else if (request.getAttribute("template") != null) {
			this.setTemplateName((String)request.getAttribute("template"));
		}
		
		if (JForumExecutionContext.isCustomContent()) {
			return null;
		}
		
//		if (this.templateName == null) {
//			throw new TemplateNotFoundException("Template for action " + action + " is not defined");
//		}

        try {
        	
        	logger.info("1:"+new StringBuffer(SystemGlobals.getValue(ConfigKeys.TEMPLATE_DIR)));
        	logger.info("2:"+this.templateName);
        	
            return JForumExecutionContext.templateConfig().getTemplate(
                new StringBuffer(SystemGlobals.getValue(ConfigKeys.TEMPLATE_DIR)).
                append('/').append(this.templateName).toString());
        }
        catch (IOException e) {
            throw new ForumException( e);
        }
    }
	
	
	public void forumList()
	{
		this.setTemplateName(TemplateKeys.FORUMS_LIST);

		this.context.put("allCategories", ForumCommon.getAllCategoriesAndForums(true));
		this.context.put("topicsPerPage", new Integer(SystemGlobals.getIntValue(ConfigKeys.TOPICS_PER_PAGE)));
		this.context.put("rssEnabled", SystemGlobals.getBoolValue(ConfigKeys.RSS_ENABLED));

		this.context.put("totalMessages", new Integer(ForumRepository.getTotalMessages()));
		this.context.put("totalRegisteredUsers", ForumRepository .totalUsers());
		this.context.put("lastUser", ForumRepository.lastRegisteredUser());

		SimpleDateFormat df = new SimpleDateFormat(SystemGlobals.getValue(ConfigKeys.DATE_TIME_FORMAT));
		GregorianCalendar gc = new GregorianCalendar();
		this.context.put("now", df.format(gc.getTime()));

		this.context.put("lastVisit", df.format(SessionFacade.getUserSession().getLastVisit()));
		this.context.put("forumRepository", new ForumRepository());

		// Online Users
		this.context.put("totalOnlineUsers", new Integer(SessionFacade.size()));
		int aid = SystemGlobals.getIntValue(ConfigKeys.ANONYMOUS_USER_ID);

		List onlineUsersList = SessionFacade.getLoggedSessions();

		// Check for an optional language parameter
		UserSession currentUser = SessionFacade.getUserSession();

		if (currentUser.getUserId() == aid) {
			String lang = this.request.getParameter("lang");

			if (lang != null && I18n.languageExists(lang)) {
				currentUser.setLang(lang);
			}
		}

		// If there are only guest users, then just register
		// a single one. In any other situation, we do not
		// show the "guest" username
		if (onlineUsersList.size() == 0) {
			UserSession us = new UserSession();

			us.setUserId(aid);
			us.setUsername(I18n.getMessage("Guest"));

			onlineUsersList.add(us);
		}

		int registeredSize = SessionFacade.registeredSize();
		int anonymousSize = SessionFacade.anonymousSize();
		int totalOnlineUsers = registeredSize + anonymousSize;

		this.context.put("userSessions", onlineUsersList);
		this.context.put("totalOnlineUsers", new Integer(totalOnlineUsers));
		this.context.put("totalRegisteredOnlineUsers", new Integer(registeredSize));
		this.context.put("totalAnonymousUsers", new Integer(anonymousSize));

		// Most users ever online
		MostUsersEverOnline mostUsersEverOnline = ForumRepository.getMostUsersEverOnline();

		if (totalOnlineUsers > mostUsersEverOnline.getTotal()) {
			mostUsersEverOnline.setTotal(totalOnlineUsers);
			mostUsersEverOnline.setTimeInMillis(System.currentTimeMillis());

			ForumRepository.updateMostUsersEverOnline(mostUsersEverOnline);
		}

		this.context.put("mostUsersEverOnline", mostUsersEverOnline);
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
	
	
	private boolean shouldBan(String ip)
	{
		Banlist b = new Banlist();
		
		b.setUserId(SessionFacade.getUserSession().getUserId());
		b.setIp(ip);
		
		return BanlistRepository.shouldBan(b);
	}
	
	private Command retrieveCommand(String moduleClass) throws Exception
	{
		return (Command)Class.forName(moduleClass).newInstance();
	}
    

	private void handleFinally(Writer out, JForumContext forumContext, ResponseContext response) throws IOException
	{
		try {
//			if (out != null) { out.close(); }
		}
		catch (Exception e) {
		    // catch close error 
		}
		
		String redirectTo = JForumExecutionContext.getRedirectTo();
		JForumExecutionContext.finish();
		
		if (redirectTo != null) {
			if (forumContext != null && forumContext.isEncodingDisabled()) {
				response.sendRedirect(redirectTo);
			} 
			else {
				response.sendRedirect(response.encodeRedirectURL(redirectTo));
			}
		}
	}

	private void handleException(Writer out, ResponseContext response, String encoding, 
		Exception e, RequestContext request) throws IOException
	{
		JForumExecutionContext.enableRollback();
		
		if (e.toString().indexOf("ClientAbortException") == -1) {
			response.setContentType("text/html; charset=" + encoding);
			if (out != null) {
				new ExceptionWriter().handleExceptionData(e, out, request);
			}
			else {
//				new ExceptionWriter().handleExceptionData(e, new BufferedWriter(new OutputStreamWriter(response.getOutputStream())), request);
				new ExceptionWriter().handleExceptionData(e, new BufferedWriter(new OutputStreamWriter(response.getOutputStream(),encoding)), request);
			}
		}
	}
	
}