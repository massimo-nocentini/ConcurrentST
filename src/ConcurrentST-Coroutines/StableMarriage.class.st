"
A StableMarriage solves the 'stable marriage' problem using coroutines.

"
Class {
	#name : #StableMarriage,
	#superclass : #Object,
	#instVars : [
		'n',
		'guys',
		'gals',
		'guyPrefs',
		'galPrefs',
		'solver',
		'guyCors',
		'galCors',
		'guyEng',
		'galEng',
		'galPrefsOrd',
		'trace',
		'test'
	],
	#category : #'ConcurrentST-Coroutines'
}

{ #category : #action }
StableMarriage class >> solve: aValue [
	"comment stating purpose of message"
]

{ #category : #accessing }
StableMarriage >> galPrefs [
	^ galPrefs
]

{ #category : #accessing }
StableMarriage >> galPrefs: anArray [
	galPrefs := anArray
]

{ #category : #accessing }
StableMarriage >> gals [
	^ gals
]

{ #category : #accessing }
StableMarriage >> gals: anArray [
	gals := anArray
]

{ #category : #accessing }
StableMarriage >> guyPrefs [
	^ guyPrefs
]

{ #category : #accessing }
StableMarriage >> guyPrefs: anArray [
	guyPrefs := anArray
]

{ #category : #accessing }
StableMarriage >> guys [
	^ guys
]

{ #category : #accessing }
StableMarriage >> guys: anArray [
	guys := anArray
]

{ #category : #'helper methods' }
StableMarriage >> prepareCoroutines [

	"prepare coroutines to solve the problem"

	"shut up, pharo prompt!"

	guyCors := galCors := solver := nil.

	"guy's coroutines"
	guyCors := (1 to: n) collect: [ :i | 
		           | guy |
		           guy := i.
		           test coroutineOn: [ :resume :value | 
			           | prefs gal |
			           prefs := guyPrefs at: guy.
			           (1 to: n) do: [ :j | "make guy-girl engagement"
				           gal := prefs at: j.
				           guyEng at: guy put: gal.
				           trace ifTrue: [ 
					           self traceOn: { 
							           (guys at: guy).
							           'proposes'.
							           (gals at: gal) } ].
				           resume value: (galCors at: gal) value: guy ] ] ].

	"gal coroutines"
	galCors := (1 to: n) collect: [ :i | 
		           | gal |
		           gal := i.
		           test coroutineOn: [ :resume :value | 
			           | prefs guy |
			           prefs := galPrefsOrd at: gal.
			           guy := value.
			           galEng at: gal put: guy.
			           trace ifTrue: [ 
				           self traceOn: { 
						           (gals at: gal).
						           'accepts initial'.
						           (guys at: guy) } ].
			           "first guy accepted: back to main"
			           guy := resume value: solver value: nil.
			           [ 
			           (prefs at: (galEng at: gal)) > (prefs at: guy)
				           ifTrue: [ 
					           | jilt |
					           jilt := galEng at: gal.
					           galEng at: gal put: guy.
					           trace ifTrue: [ 
						           self traceOn: { 
								           (gals at: gal).
								           'prefers'.
								           (guys at: guy).
								           'over'.
								           (guys at: jilt) } ].
					           "new guy accepted: back to jilt"
					           guy := resume value: (guyCors at: jilt) value: gal ]
				           ifFalse: [ 
					           trace ifTrue: [ 
						           self traceOn: { 
								           (gals at: gal).
								           'rejects'.
								           (guys at: guy) } ].
					           "guy rejected: back to guy"
					           guy := resume value: (guyCors at: guy) value: gal ] ]
				           repeat ] ].

	"solver coroutine"
	solver := test coroutineOn: [ :resume :value | 
		          (1 to: n) do: [ :guy | 
			          resume value: (guyCors at: guy) value: nil ].
		          trace ifTrue: [ self traceResults ].
		          guyEng ]
]

{ #category : #'helper methods' }
StableMarriage >> prepareParameters [
	"prepare paramters to solve the problem"
	n := guys size.
	
	"engagements for guys and girls"
	guyEng := Array new: n.
	galEng := Array new: n.
	
	"girls preferences by guy index"
	galPrefsOrd := (1 to: n) collect: [ :i |
		| prefs prefsOrd |
		prefs := galPrefs at: i.
		prefsOrd := Array new: n.
		(1 to: n) do: [ :j | 
			prefsOrd at: (prefs at: j) put: j.
		].
		prefsOrd.
	].
	
]

{ #category : #action }
StableMarriage >> solve [
	"solves the problem. It is assumed all parameters are set correctly"
	self prepareParameters.
	self prepareCoroutines.
	^ solver value: nil.
	
]

{ #category : #accessing }
StableMarriage >> test: aTestCase [

	test := aTestCase
]

{ #category : #accessing }
StableMarriage >> trace [
	^ trace
]

{ #category : #accessing }
StableMarriage >> trace: aBool [
	trace := aBool
]

{ #category : #'helper methods' }
StableMarriage >> traceOn: anArray [
	"show all the element s of anArray on a line"
	Transcript show: (anArray joinUsing: ' '); cr.
]

{ #category : #'helper methods' }
StableMarriage >> traceResults [
	"print in Transcript the resulting engagements"
	Transcript cr; show: 'Final engagements:'; cr.
	(1 to: n) do: [ :i |
		self traceOn: { (guys at: i). 'marries'. (gals at: (guyEng at: i)) }.
	].
]
