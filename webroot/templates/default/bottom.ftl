</td>
</tr>
	<tr>
		<td align="center">
			<#if Request.forumdata.session?exists && Request.forumdata.session.isAdmin()><span class="gen"><a id="adminpanel" href='${Request.forumdata.JForumContext.encodeURL("/admBase/login")}'>${Request.forumdata.I18n.getMessage("ForumBase.admin")}</a></span></#if>
		</td>
	</tr>


	<tr>
		<td align="center">
	<div id="site_nav">
    <ul>
      <li><a href="${Request.forumdata.JForumContext.encodeURL("/forums/service")}">广告服务</a></li>
      
      <li><a href="${Request.forumdata.JForumContext.encodeURL("/forums/aboutus")}">关于我们</a></li>
      <li><a href="${Request.forumdata.JForumContext.encodeURL("/forums/contactus")}">联系我们</a></li>
      <li><a href="${Request.forumdata.JForumContext.encodeURL("/forums/friend_links")}">友情链接</a></li>
    </ul>
  </div>
  <div id="copyright" class="gensmall">
    &copy; 2008-2009 xxx.javaeye.com.   All rights reserved. [ 沪ICP备xxxxx号 ] 
  </div>
		</td>
	</tr>

	<tr>
		<td align="center">
			<span class="copyright">Powered by <a class="copyright" href="http://www.jforum.net/" target="_blank">JForum ${Request.forumdata.version}</a> &copy; <a class="copyright" href="http://www.jforum.net/team.jsp" target="_blank">JForum Team</a></span>
		</td>
	</tr>
</table>

<#if hasCodeBlock>
	<#include "highlighter_js.htm"/>
</#if>

<iframe src="${Request.forumdata.contextPath}/ping_session.jsp" height="0" width="0" frameborder="0" scrolling="no"></iframe>

</body>
</html>