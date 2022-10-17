function sync(doc, oldDoc) {

	/* Data Validation */
	validateNotEmpty("documentType", doc.documentType);  // <1>

	if (doc.documentType == 'warehouse') {
		console.log("********Processing Warehouse Docs - setting it to global/public");
		channel('!');
	} else {
		console.log("********Processing Team Docs");
		validateNotEmpty("team", doc.team); // <2>
		if (!isDelete()) {  // <3>

			/* Routing  -- add channel routing rules here for document */
			var team = getTeam();  // <4>
			var channelId = "channel." + team;
			console.log("********Setting Channel to " + channelId);  
			channel(channelId); // <5>

			/* Authorization  - Access Control */
			requireRole(team);  // <6>
			access("role:team1", "channel.team1"); // <7>
			access("role:team2", "channel.team2"); // <7>
			access("role:team3", "channel.team3"); // <7>
			access("role:team4", "channel.team4"); // <7>
			access("role:team5", "channel.team5"); // <7>
			access("role:team6", "channel.team6"); // <7>
			access("role:team7", "channel.team7"); // <7>	
			access("role:team8", "channel.team8"); // <7>
			access("role:team9", "channel.team9"); // 	<7>
			access("role:team10", "channel.team10"); // <7>
		}
	}
	// get type property
	function getType() {
		return (isDelete() ? oldDoc.documentType : doc.documentType);
	}

	// get email Id property
	function getTeam() {
		return (isDelete() ? oldDoc.team : doc.team);
	}

	// Check if document is being created/added for first time
	function isCreate() {
		// Checking false for the Admin UI to work
		return ((oldDoc == false) || (oldDoc == null || oldDoc._deleted) && !isDelete());
	}

	// Check if this is a document delete
	function isDelete() {
		return (doc._deleted == true);
	}

	// Verify that specified property exists
	function validateNotEmpty(key, value) {
		if (!value) {
			throw ({ forbidden: key + " is not provided." });
		}
	}
}