Class {
	#name : #CSTChannelNaturals,
	#superclass : #CSTChannel,
	#instVars : [
		'channel'
	],
	#category : #'ConcurrentST-Channels'
}

{ #category : #accessing }
CSTChannelNaturals >> channel: aChannel [
	channel := aChannel
]

{ #category : #accessing }
CSTChannelNaturals >> count: i [
	channel send: i.
	self count: i + 1
]
