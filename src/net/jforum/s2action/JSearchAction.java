/*
 * Copyright (c) JForum Team
 * All rights reserved.
 * 
 * Redistribution and use in source and binary forms, 
 * with or without modification, are permitted provided 
 * that the following conditions are met:
 * 
 * 1) Redistributions of source code must retain the above 
 * copyright notice, this list of conditions and the 
 * following  disclaimer.
 * 2)  Redistributions in binary form must reproduce the 
 * above copyright notice, this list of conditions and 
 * the following disclaimer in the documentation and/or 
 * other materials provided with the distribution.
 * 3) Neither the name of "Rafael Steil" nor 
 * the names of its contributors may be used to endorse 
 * or promote products derived from this software without 
 * specific prior written permission.
 * 
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT 
 * HOLDERS AND CONTRIBUTORS "AS IS" AND ANY 
 * EXPRESS OR IMPLIED WARRANTIES, INCLUDING, 
 * BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF 
 * MERCHANTABILITY AND FITNESS FOR A PARTICULAR 
 * PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL 
 * THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE 
 * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, 
 * EXEMPLARY, OR CONSEQUENTIAL DAMAGES 
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF 
 * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, 
 * OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER 
 * CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER 
 * IN CONTRACT, STRICT LIABILITY, OR TORT 
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN 
 * ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF 
 * ADVISED OF THE POSSIBILITY OF SUCH DAMAGE
 * 
 * This file creation date: 14/01/2004 / 22:02:56
 * The JForum Project
 * http://www.jforum.net
 */
package net.jforum.s2action;

import java.io.IOException;
import java.util.Date;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.apache.struts2.ServletActionContext;

import net.jforum.Command;
import net.jforum.context.RequestContext;
import net.jforum.context.ResponseContext;
import net.jforum.repository.ForumRepository;
import net.jforum.search.ContentSearchOperation;
import net.jforum.search.NewMessagesSearchOperation;
import net.jforum.search.SearchArgs;
import net.jforum.search.SearchOperation;
import net.jforum.search.SearchResult;
import net.jforum.util.I18n;
import net.jforum.util.preferences.ConfigKeys;
import net.jforum.util.preferences.SystemGlobals;
import net.jforum.util.preferences.TemplateKeys;
import net.jforum.view.forum.common.TopicsCommon;
import net.jforum.view.forum.common.ViewCommon;
import freemarker.template.SimpleHash;

/**
 * @author Rafael Steil
 * @version $Id: SearchAction.java,v 1.57 2007/08/20 19:35:52 rafaelsteil Exp $
 */
public class JSearchAction extends JDefaultAction 
{
	private static Logger logger = Logger.getLogger(JSearchAction.class);
	public JSearchAction() { }
	
	public JSearchAction(RequestContext request, ResponseContext response, SimpleHash context) 
	{
		this.request = request;
		this.response = response;
		this.context = context;
	}
	
	public void filters()
	{
		this.setTemplateName(TemplateKeys.SEARCH_FILTERS);
		this.context.put("categories", ForumRepository.getAllCategories());
		this.context.put("pageTitle", I18n.getMessage("ForumBase.search"));
	}
	
	public void newMessages()
	{
//		this.search(new NewMessagesSearchOperation());
	}

	
	
	public String search(){

	    	logger.info("===========>  JPostAction list method fired  <===========");
	    	HttpServletRequest request = ServletActionContext.getRequest(); 
	    	HttpServletResponse response = ServletActionContext.getResponse();
	    	String s = null;
//	    	Writer out = null;
	    	try {
//	    		forumList();
				s = service(request, response);
				if(s.equalsIgnoreCase(SUCCESS)){
					s= this.search(request, response,new ContentSearchOperation());
				}else if(s.equalsIgnoreCase(ERROR)){
					logger.info("list service return error !");
				}
				
				
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} catch (ServletException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}	finally {
				try {
					handleFinally();
				} catch (IOException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
					logger.error("error fired in finally block");
				}
//				return SUCCESS;
				
			}	
			
//	    	name = "Hello, " + name + "!"; 
	        return s;

	}
	
	
	
	
	private String search(HttpServletRequest request, HttpServletResponse response, SearchOperation operation)
	{
		SearchArgs args = this.buildSearchArgs(request,response);
		
		int start = args.startFrom();
		int recordsPerPage = SystemGlobals.getIntValue(ConfigKeys.TOPICS_PER_PAGE);
		
		SearchResult searchResult = operation.performSearch(args);
		operation.prepareForDisplay();
		
		this.setTemplateName(operation.viewTemplate());
		
		this.context.put("results", operation.filterResults(operation.results()));
		this.context.put("categories", ForumRepository.getAllCategories());
		this.context.put("searchArgs", args);
		this.context.put("fr", new ForumRepository());
		this.context.put("pageTitle", I18n.getMessage("ForumBase.search"));
		this.context.put("openModeration", "1".equals(this.request.getParameter("openModeration")));
		this.context.put("postsPerPage", new Integer(SystemGlobals.getIntValue(ConfigKeys.POSTS_PER_PAGE)));
		
		ViewCommon.contextToPagination(start, searchResult.numberOfHits(), recordsPerPage);
		TopicsCommon.topicListingBase();
		
		return SUCCESS;
	}
	
	private SearchArgs buildSearchArgs(HttpServletRequest request, HttpServletResponse response)
	{
		SearchArgs args = new SearchArgs();
		
		args.setKeywords(request.getParameter("search_keywords"));
		
		if (this.request.getParameter("search_author") != null) {
			args.setAuthor(Integer.valueOf(request.getParameter("search_author")));
		}
		
		args.setOrderBy(request.getParameter("sort_by"));
		args.setOrderDir(request.getParameter("sort_dir"));
		args.startFetchingAtRecord(ViewCommon.getStartPage());
		args.setMatchType(request.getParameter("match_type"));
		
		if (request.getParameter("from_date") != null
			&& request.getParameter("to_date") != null) {
			args.setDateRange((Date)this.request.getObjectParameter("from_date"), 
				(Date)this.request.getObjectParameter("to_date"));		    
		}

		if ("all".equals(args.getMatchType())) {
			args.matchAllKeywords();
		}
		
		if (request.getParameter("forum") != null) {
			args.setForumId(Integer.valueOf(request.getParameter("forum")));
		}
		
		return args;
	}
	
	/** 
	 * @see net.jforum.Command#list()
	 */
	public void list()  
	{
		this.filters();
	}
}
