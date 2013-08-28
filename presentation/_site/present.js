
function next(event) {
	if (event && event.keyCode === 37) {
		window.location.pathname = $(".previous").attr('href')
	}

	if (event && event.keyCode === 39) {
		window.location.pathname = $(".next").attr('href')
	}
}

$(function() {
	$("body").keypress(next)
})
