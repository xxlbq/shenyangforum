function showEmail(beforeAt, afterAt)
{
	return beforeAt + "@" + afterAt;
}

var starOn = new Image();
starOn.src = "${Request.forumdata.contextPath}/templates/${Request.forumdata.templateName}/images/star_on.gif";

var starOff = new Image();
starOff.src = "${Request.forumdata.contextPath}/templates/${Request.forumdata.templateName}/images/star_off.gif";

function writeStars(q, postId)
{
	for (var i = 0; i < 5; i++) {
		var name = "star" + postId + "_" + i;
		document.write("<img name='" + name + "' alt='*' />");
		document.images[name].src = q > i ? starOn.src : starOff.src;
	}
}

function addBookmark(relationType, relationId)
{
	var w = window.open('${Request.forumdata.JForumContext.encodeURL("/bookmarks/insert/' + relationType + '/' + relationId + '")}', 'bookmark_add', 'width=700, height=200, scrollbars=auto, resizable=true');
	w.focus();
}
