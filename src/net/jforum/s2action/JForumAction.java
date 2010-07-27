package net.jforum.s2action;

import java.io.BufferedWriter;
import java.io.IOException;
import java.io.OutputStream;
import java.io.OutputStreamWriter;
import java.io.Writer;
import java.text.SimpleDateFormat;
import java.util.GregorianCalendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.jforum.Command;
import net.jforum.ControllerUtils;
import net.jforum.ForumStartup;
import net.jforum.JForumExecutionContext;
import net.jforum.SessionFacade;
import net.jforum.context.JForumContext;
import net.jforum.context.RequestContext;
import net.jforum.context.ResponseContext;
import net.jforum.context.web.WebRequestContext;
import net.jforum.context.web.WebResponseContext;
import net.jforum.dao.DataAccessDriver;
import net.jforum.dao.ForumDAO;
import net.jforum.dao.ModerationDAO;
import net.jforum.entities.Banlist;
import net.jforum.entities.Forum;
import net.jforum.entities.MostUsersEverOnline;
import net.jforum.entities.UserSession;
import net.jforum.exceptions.ExceptionWriter;
import net.jforum.exceptions.ForumException;
import net.jforum.repository.BanlistRepository;
import net.jforum.repository.ForumRepository;
import net.jforum.repository.SecurityRepository;
import net.jforum.repository.Tpl;
import net.jforum.security.SecurityConstants;
import net.jforum.util.I18n;
import net.jforum.util.preferences.ConfigKeys;
import net.jforum.util.preferences.SystemGlobals;
import net.jforum.util.preferences.TemplateKeys;
import net.jforum.view.forum.ModerationHelper;
import net.jforum.view.forum.common.ForumCommon;
import net.jforum.view.forum.common.PostCommon;
import net.jforum.view.forum.common.TopicsCommon;
import net.jforum.view.forum.common.ViewCommon;

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
	
	
	private int fid ;
	
//	protected void setTemplateName(String templateName)
//	{
//		this.templateName = Tpl.name(templateName);
//		
//		logger.info("templateName in cache :"+templateName);
//		
//		this.templateName = "forum_list.ftl";
//		
//		logger.info("templateName:"+templateName);
//	}



	protected void ignoreAction()
	{
		this.ignoreAction = true;
	}
    
    
    
    public int getFid() {
		return fid;
	}



	public void setFid(int fid) {
		this.fid = fid;
	}



	public String list() {
    	logger.info("===========>  list method fired  <===========");
    	HttpServletRequest request = ServletActionContext.getRequest(); 
    	HttpServletResponse response = ServletActionContext.getResponse(); 
    	String s = null;
    	try {
//    		forumList();
			s = service(request, response);
			if(s.equalsIgnoreCase(SUCCESS)){
				forumList();
			}else if(s.equalsIgnoreCase(ERROR)){
				
			}
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (ServletException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
//    	name = "Hello, " + name + "!"; 
        return s;
    }
    

    public String show() {
    	logger.info("===========>  show method fired  <===========");
    	HttpServletRequest request = ServletActionContext.getRequest(); 
    	HttpServletResponse response = ServletActionContext.getResponse(); 
    	String s = null;
    	try {
//    		forumList();
			s = service(request, response);
			if(s.equalsIgnoreCase(SUCCESS)){
				forumShow();
			}else if(s.equalsIgnoreCase(ERROR)){
				
			}
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (ServletException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
//    	name = "Hello, " + name + "!"; 
        return s;
    }
    
	
	
	
	
	
	
	
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
		finally {
			this.handleFinally(out, forumContext, response);
//			return SUCCESS;
			
		}		
	}
	
//	private Writer processCommand(Writer out, RequestContext request, ResponseContext response, 
//			String encoding, SimpleHash context) throws Exception
//	{
//		// Here we go, baby
////		Command c = this.retrieveCommand(moduleClass);
////		Template template = process(request, response, context);
//		forumList();
//		if (JForumExecutionContext.getRedirectTo() == null) {
//			String contentType = JForumExecutionContext.getContentType();
//			
//			if (contentType == null) {
//				contentType = "text/html; charset=" + encoding;
//			}
//			
//			response.setContentType(contentType);
//			
//////			OutputStream p =response.getOutputStream();
////			
////			out = response.getWriter();
////			
////			SimpleHash data = JForumExecutionContext.getTemplateContext();
////			
////			// Binary content are expected to be fully 
////			// handled in the action, including outputstream
////			// manipulation
////			if (!JForumExecutionContext.isCustomContent()) {
//////				out = new BufferedWriter(new OutputStreamWriter(p , encoding));
////				template.process(data, out);
////				
//////				utput.flush();
//////				out.flush();
////				
////			}
//			
//			
////			OutputStream output = response.getOutputStream();
////			while ((len = inputStream.read(b, 0, 1024)) != -1) {
////			output.write(b,0,len); 
//			//return null¾ÍÐÐÁË¡£ 
//		}
//		
////		return null;
//		return out;
//	}
	
	
//	public Template process(RequestContext request, ResponseContext response, SimpleHash context)
//	{
//		this.request = request;
//		this.response = response;
//		this.context = context;
//		
////		String action = this.request.getAction();
//
////		if (!this.ignoreAction) {
////			try {
////				this.getClass().getMethod(action, NO_ARGS_CLASS).invoke(this, NO_ARGS_OBJECT);
////			}
////			catch (NoSuchMethodException e) {		
////				this.list();		
////			}
////			catch (Exception e)
////            {
////                throw new ForumException(e);
////			}
////		}
//		
//		forumList();
//		
////		if (JForumExecutionContext.getRedirectTo() != null) {
////			this.setTemplateName(TemplateKeys.EMPTY);
////		}
////		else if (request.getAttribute("template") != null) {
////			this.setTemplateName((String)request.getAttribute("template"));
////		}
//		
//		if (JForumExecutionContext.isCustomContent()) {
//			return null;
//		}
//		
////		if (this.templateName == null) {
////			throw new TemplateNotFoundException("Template for action " + action + " is not defined");
////		}
//
////        try {
////        	
////        	logger.info("1:"+new StringBuffer(SystemGlobals.getValue(ConfigKeys.TEMPLATE_DIR)));
////        	logger.info("2:"+this.templateName);
////        	
////            return JForumExecutionContext.templateConfig().getTemplate(
////                new StringBuffer(SystemGlobals.getValue(ConfigKeys.TEMPLATE_DIR)).
////                append('/').append(this.templateName).toString());
////        }
////        catch (IOException e) {
////            throw new ForumException( e);
////        }
//		
//		return null;
//    }
	
	
	public void forumList()
	{
//		this.setTemplateName(TemplateKeys.FORUMS_LIST);

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
//		this.context.put("forumRepository", new ForumRepository());

		// Online Users
		this.context.put("totalOnlineUsers", new Integer(SessionFacade.size()));
		int aid = SystemGlobals.getIntValue(ConfigKeys.ANONYMOUS_USER_ID);

		List onlineUsersList = SessionFacade.getLoggedSessions();

		// Check for an optional language parameter
		UserSession currentUser = SessionFacade.getUserSession();
		this.context.put("SessionUserId",currentUser.getUserId());
//		if (currentUser.getUserId() == aid) {
//			String lang = this.request.getParameter("lang");
//
//			if (lang != null && I18n.languageExists(lang)) {
//				currentUser.setLang(lang);
//			}
//		}

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
		logger.info("mostUsersEverOnline:"+mostUsersEverOnline);
		if (totalOnlineUsers > mostUsersEverOnline.getTotal()) {
			mostUsersEverOnline.setTotal(totalOnlineUsers);
			mostUsersEverOnline.setTimeInMillis(System.currentTimeMillis());

			ForumRepository.updateMostUsersEverOnline(mostUsersEverOnline);
		}

		this.context.put("mostUsersEverOnline", mostUsersEverOnline);
	}
	
	
	
	public void forumShow()
	
	
	{
		logger.info("fid="+fid);
//		logger.info("request fid:"+this.request.getIntParameter("forum_id"));
//		int forumId = this.request.getIntParameter("forum_id");
		int forumId = fid;
		
		ForumDAO fm = DataAccessDriver.getInstance().newForumDAO();

		// The user can access this forum?
		Forum forum = ForumRepository.getForum(forumId);

		if (forum == null || !ForumRepository.isCategoryAccessible(forum.getCategoryId())) {
			new ModerationHelper().denied(I18n.getMessage("ForumListing.denied"));
			return;
		}

		int start = ViewCommon.getStartPage();

		List tmpTopics = TopicsCommon.topicsByForum(forumId, start);

//		this.setTemplateName(TemplateKeys.FORUMS_SHOW);

		// Moderation
		UserSession userSession = SessionFacade.getUserSession();
		boolean isLogged = SessionFacade.isLogged();
		boolean isModerator = userSession.isModerator(forumId);

		boolean canApproveMessages = (isLogged && isModerator 
			&& SecurityRepository.canAccess(SecurityConstants.PERM_MODERATION_APPROVE_MESSAGES));

		Map topicsToApprove = new HashMap();

		if (canApproveMessages) {
			ModerationDAO mdao = DataAccessDriver.getInstance().newModerationDAO();
			topicsToApprove = mdao.topicsByForum(forumId);
			this.context.put("postFormatter", new PostCommon());
		}

		this.context.put("topicsToApprove", topicsToApprove);

		this.context.put("attachmentsEnabled", SecurityRepository.canAccess(SecurityConstants.PERM_ATTACHMENTS_ENABLED,
		        Integer.toString(forumId))
		        || SecurityRepository.canAccess(SecurityConstants.PERM_ATTACHMENTS_DOWNLOAD));

		this.context.put("topics", TopicsCommon.prepareTopics(tmpTopics));
		this.context.put("allCategories", ForumCommon.getAllCategoriesAndForums(false));
		this.context.put("forum", forum);
		this.context.put("rssEnabled", SystemGlobals.getBoolValue(ConfigKeys.RSS_ENABLED));
		this.context.put("pageTitle", forum.getName());
		this.context.put("canApproveMessages", canApproveMessages);
		this.context.put("replyOnly", !SecurityRepository.canAccess(SecurityConstants.PERM_REPLY_ONLY, Integer
		        .toString(forum.getId())));

		this.context.put("readonly", !SecurityRepository.canAccess(SecurityConstants.PERM_READ_ONLY_FORUMS, Integer
		        .toString(forumId)));

		this.context.put("watching", fm.isUserSubscribed(forumId, userSession.getUserId()));

		// Pagination
		int topicsPerPage = SystemGlobals.getIntValue(ConfigKeys.TOPICS_PER_PAGE);
		int postsPerPage = SystemGlobals.getIntValue(ConfigKeys.POSTS_PER_PAGE);
		int totalTopics = forum.getTotalTopics();

		ViewCommon.contextToPagination(start, totalTopics, topicsPerPage);
		this.context.put("postsPerPage", new Integer(postsPerPage));

		TopicsCommon.topicListingBase();
		this.context.put("moderator", isLogged && isModerator);
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
//		JForumExecutionContext.finish();
		
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