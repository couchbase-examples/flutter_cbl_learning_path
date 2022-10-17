function(doc) {
	if (
		doc.documentType == 'project' || 
		doc.documentType == 'warehouse' || 
		doc.documentType == 'user' || 
		doc.documentType == 'audit' || 
		doc.documentType == 'item') {
		return true;
	}
	return false;
} 