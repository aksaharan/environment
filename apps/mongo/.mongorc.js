prompt = function() {
	myPrompt = db.getName();

	var now = new ISODate();
	tsPart = ("00" + now.getHours()).slice(-2) 
		+ ("00" + now.getMinutes()).slice(-2) 
		+ ("00" + now.getSeconds()).slice(-2)
		+ "." + ("000" + now.getMilliseconds()).slice(-3);
	myPrompt = myPrompt + ":" + tsPart;
		
	return myPrompt + "> ";
}

/*
DB.prototype.getMyName = function() {
	return "Xyz";
}
*/
