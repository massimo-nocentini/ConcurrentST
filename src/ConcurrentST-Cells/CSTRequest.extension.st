Extension { #name : #CSTRequest }

{ #category : #'*ConcurrentST-Cells' }
CSTRequest >> value: anObject forCSTCellRequestsReplyChannels: aCell [
	self subclassResponsibility
]
