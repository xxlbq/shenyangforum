<table cellspacing="0" cellpadding="1" border="0" class="genmed">
	<#if poll?exists>
		<#assign pollQuestion = poll.label?default("")?html/>
		<#assign pollLength = poll.length/>
	<#else>
		<#assign pollQuestion = ""/>
		<#assign pollLength = "0"/>
	</#if>
	<tr>
		<td>${Request.forumdata.I18n.getMessage("PostForm.pollQuestion")}</b></td>
		<td><input type="text" name="poll_label" maxlength="255" size="50" value="${pollQuestion}"></input></td>
	</tr>
	<tr id="pollOptionWithDelete" style="display: none;">
		<td>${Request.forumdata.I18n.getMessage("PostForm.pollOption")}</td>
		<td><input type="text" id="pollOption" name="poll_option" maxlength="255" size="50"></input>
			 <input type="button" onclick="javascript:deletePollOption(this)" value="${Request.forumdata.I18n.getMessage("PostForm.pollDeleteOption")}"></input></td>
	</tr>
	<#if poll?exists>
		<#assign optionCount = 0/>
		<#list poll.options as option>
			<#assign optionText = option.text?default("")?html/>
			<tr id="pollOption">
				<td>${Request.forumdata.I18n.getMessage("PostForm.pollOption")}</td>
				<td>
					<input type="text" id="pollOption${option.id}" name="poll_option_${option.id}" maxlength="255" size="50" value="${optionText}"></input>
					<input type="button" onclick="javascript:deletePollOption(this)" value="${Request.forumdata.I18n.getMessage("PostForm.pollDeleteOption")}"></input>
				</td>
			</tr>

			<#if (option.id > optionCount)><#assign optionCount = option.id/></#if>
		</#list>

		<input type="hidden" name="poll_option_count" id="pollOptionCount" value="${optionCount}"/>
	<#else>
		<input type="hidden" name="poll_option_count" id="pollOptionCount" value="1"/>
		<tr id="pollOption">
			<td>${Request.forumdata.I18n.getMessage("PostForm.pollOption")}</td>
			<td>
				 <input type="text" id="pollOption1" name="poll_option_1" maxlength="255" size="50"></input>
				 <input type="button" onclick="javascript:deletePollOption(this)" value="${Request.forumdata.I18n.getMessage("PostForm.pollDeleteOption")}"></input>								 
			</td>
		</tr>
	</#if>
	<tr id="pollOptionWithAdd">
		<td>
			${Request.forumdata.I18n.getMessage("PostForm.pollAddOption")}
		</td>
		<td>
			<input type="button" onclick="javascript:addPollOption()" value="${Request.forumdata.I18n.getMessage("PostForm.pollAddOption")}"></input>
		</td>
	</tr>
	<tr>
		<td>${Request.forumdata.I18n.getMessage("PostForm.pollRunFor")}</td>
		<td><input type="text" name="poll_length" maxlength="5" size="4" value="${pollLength}"></input>${Request.forumdata.I18n.getMessage("PostForm.pollDays")}
			<span class="gensmall">${Request.forumdata.I18n.getMessage("PostForm.pollDaysDescription")}</span></td>
	</tr>
</table>