<#if Request.forumdata.karmaEnabled>
	function karmaVote(s, postId) {
		if (s.selectedIndex == 0) {
			return;
		}

		if (confirm("${Request.forumdata.I18n.getMessage("Karma.confirmVote")}")) {
			document.location = "${Request.forumdata.contextPath}/karma/insert/${Request.forumdata.start?default("")}/" + postId + "/" + s.value + "${Request.forumdata.extension}";
		}
		else {
			s.selectedIndex = 0;
		}
	}

	function karmaPointsCombo(postId)
	{
		document.write('<select name="karma" onchange="karmaVote(this,' + postId + ')">');
		document.write('<option value="">${Request.forumdata.I18n.getMessage("Karma.rateMessage")}</option>');

		for (var i = ${Request.forumdata.karmaMin?default(1)}; i <= ${Request.forumdata.karmaMax?default(2)}; i++) {
			document.write('<option value="' + i + '">' + i + '</option>');
		}

		document.write('</select>');
	}
</#if>