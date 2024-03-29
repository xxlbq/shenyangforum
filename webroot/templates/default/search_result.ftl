<#include "header.ftl"/>

<#if Request.forumdata.start?exists>
	<#assign start = Request.forumdata.start/>
</#if>
<#if Request.forumdata.contextPath?exists>
	<#assign contextPath = Request.forumdata.contextPath/>
</#if>
<#if Request.forumdata.templateName?exists>
	<#assign templateName = Request.forumdata.templateName/>
</#if>
<#if Request.forumdata.startupTime?exists>
	<#assign startupTime = Request.forumdata.startupTime/>
</#if>
<#if Request.forumdata.I18n?exists>
	<#assign I18n = Request.forumdata.I18n/>
</#if>
<#if Request.forumdata.totalRecords?exists>
	<#assign totalRecords = Request.forumdata.totalRecords/>
</#if>
<#if Request.forumdata.extension?exists>
	<#assign extension = Request.forumdata.extension/>
</#if>
<#if Request.forumdata.paginationLinks?exists>
	<#assign paginationLinks = Request.forumdata.paginationLinks/>
</#if>
<#if Request.forumdata.results?exists>
	<#assign results = Request.forumdata.results/>
</#if>
<#if Request.forumdata.JForumContext?exists>
	<#assign JForumContext = Request.forumdata.JForumContext/>
</#if>
<#if Request.forumdata.encoding?exists>
	<#assign encoding = Request.forumdata.encoding/>
</#if>
<#if Request.forumdata.categories?exists>
	<#assign categories = Request.forumdata.categories/>
</#if>

<script type="text/javascript" src="${contextPath}/templates/${templateName}/js/pagination.js?${startupTime}"></script>

<#import "../macros/pagination.ftl" as topicPagination>
<#import "../macros/search_pagination.ftl" as pagination>
<#import "../macros/presentation.ftl" as presentation/>

<table cellspacing="0" cellpadding="10" width="100%" align="center" border="0">
	<tr>
		<td class="bodyline" valign="top">
			<table cellspacing="2" cellpadding="2" width="100%" align="center" border="0">
				<tr>
					<td valign="bottom" align="left" colspan="2">
						<span class="maintitle">
							${I18n.getMessage("Search.searchResults")}:
							${totalRecords} 
							
							<#if (totalRecords == 1)>
								${I18n.getMessage("Search.recordFound")}
							<#else>
								${I18n.getMessage("Search.recordsFound")}
							</#if>
						</span>
						<br />
					</td>
				</tr>
				<tr>
					<td align="left" valign="middle">		  
						<a class="nav" href="${contextPath}/forums/list${extension}">${I18n.getMessage("ForumListing.forumIndex")}</a>
					</td>
					<td class="nav" valign="bottom" nowrap="nowrap" align="right">
						<#assign paginationLinks>
							<@pagination.searchPagination/>
						</#assign>

						${paginationLinks}
					</td>
				</tr>
			</table>

			<table class="forumline" cellspacing="2" cellpadding="5" width="100%" border="0">
				<#if results.size() == 0>
					<tr>
						<td class="gen">
							${I18n.getMessage("Search.noResults")} <a href="${JForumContext.encodeURL("/search/filters")}">${I18n.getMessage("Search.clickHere")}</a> ${I18n.getMessage("Search.newSearch")}
						</td>
					</tr>
				<#else>
					<#list results as post>
						<tr>
							<td class="postinfo">
								<#assign postUrl = JForumContext.encodeURL("/posts/preList/${post.topicId}/${post.id}")/>

								<span class="gen">
									<img class="icon_folder" src="${contextPath}/images/transp.gif" alt=""/>

									<strong>
										<a href="${postUrl}">${post.subject?html}</a>
									</strong>, 
									${I18n.getMessage("Search.postedOn")} <a href="${JForumContext.encodeURL("/forums/show/${post.forum.id}")}">${post.forum.name}</a>, 
									${I18n.getMessage("Search.postedAt")} ${post.time?datetime}, 
									${I18n.getMessage("Search.postedBy")} <a href="${JForumContext.encodeURL("/user/profile/${post.userId}")}">${post.postUsername}</a>									
								</span>
							</td>
						</tr>

						<tr>
							<td class="row1 gen">
								${post.text}
								<br />
								<div align="right"><a href="${postUrl}">${I18n.getMessage("Search.viewMessage")}</a></div>
							</td>
						</tr>

						<tr>
							<td height="1" colspan="2" class="spacerow"><img width="1" height="1" alt="" src="${contextPath}/templates/${templateName}/images/spacer.gif"/></td>
						</tr>
					</#list>
				</#if>
			</table>

			<table cellspacing="2" cellpadding="2" width="100%" align="center" border="0">
				<tr>
					<td align="left" valign="middle">
						<span class="nav">
		  					<a class="nav" href="${contextPath}/forums/list${extension}">${I18n.getMessage("ForumListing.forumIndex")}</a>
						</span>
					</td>
					<td valign="middle" nowrap="nowrap" align="right">
						${paginationLinks}
					</td>
				</tr>
				<tr>
					<td align="left" colspan="2"></td>
				</tr>
			</table>

			<table cellspacing="0" cellpadding="0" width="100%" border="0">
				<tr>
					<td align="right">
						<table cellspacing="0" cellpadding="0" border="0">
							<tr>
								<td nowrap="nowrap">
									<form action="" accept-charset="${encoding}" name="f">
										<span class="gensmall">${I18n.getMessage("ForumIndex.goTo")}:&nbsp;
											<select onchange="if(this.options[this.selectedIndex].value != -1){ document.location = '${contextPath}/forums/show/'+ this.options[this.selectedIndex].value +'${extension}'; }" name="select">
												<option value="-1" selected="selected">${I18n.getMessage("ForumIndex.goToSelectAForum")}</option>

												<#list categories as category>
													<optgroup label="${category.name}">
														<#list category.getForums() as forum>
														<option value="${forum.id}">${forum.name}</option>
														</#list>
													</optgroup>
												</#list>
											</select>				  
											&nbsp;
											<input class="liteoption" type="button" value="${I18n.getMessage("ForumIndex.goToGo")}" onclick="if(document.f.select.options[document.f.select.selectedIndex].value != -1){ document.location = '${contextPath}/forums/show/'+ document.f.select.options[document.f.select.selectedIndex].value +'${extension}'; }" />
										</span>
									</form>
								</td>
							</tr>
						</table>
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>
<#include "bottom.htm"/>
