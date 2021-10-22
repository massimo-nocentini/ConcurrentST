"
I am an updatable storage on top of threads and channels.
"
Class {
	#name : #CSTCell,
	#superclass : #CSTObject,
	#category : #'ConcurrentST-Cells'
}

{ #category : #'actions api' }
CSTCell >> get [
	self subclassResponsibility
]

{ #category : #'actions api' }
CSTCell >> put: anObject [
	self subclassResponsibility
]

{ #category : #construction }
CSTCell >> requestChannel: requestChannel replyChannel: replyChannel [

	^ CSTCellRequestsReplyChannels new
		  loop: loop;
		  requestsChannel: requestChannel;
		  replyChannel: replyChannel;
		  yourself
]
