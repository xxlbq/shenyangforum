			<form name="formlogin" accept-charset="${Request.forumdata.encoding}" action="${Request.forumdata.JForumContext.encodeURL("/user/login")}" method="post">
				<!--input type="hidden" name="module" value="xx" /-->
				<!--input type="hidden" name="action" value="xx" /-->
				
				<table class="forumline" cellspacing="1" cellpadding="3" width="100%" border="0">
					<tr>
						<td class="cathead" height="28"><a name="login2" id="login2"></a><span class="cattitle">${Request.forumdata.I18n.getMessage("Login.enter")}</span></td>
					</tr>

					<tr>
						<td class="row1" valign="middle" align="center" height="28">
							<span class="gensmall">
								${Request.forumdata.I18n.getMessage("Login.user")}: <input class="post" size="10" name="username" type="text"/> 
								&nbsp;&nbsp;&nbsp;
								${Request.forumdata.I18n.getMessage("Login.password")}: <input class="post" type="password" size="10" name="password" /> 
								<#if Request.forumdata.autoLoginEnabled>
									&nbsp;&nbsp; &nbsp;&nbsp;
									<label for="autologin">${Request.forumdata.I18n.getMessage("Login.autoLogon")}</label> <input class="text" type="checkbox" name="autologin" id="autologin"/>
								</#if>
								&nbsp;&nbsp;&nbsp; 
								<input class="mainoption" type="submit" value="${Request.forumdata.I18n.getMessage("Login.enter")}" name="login" /> 
							</span>
						</td>
					</tr>
				</table>
			</form>