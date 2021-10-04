Class {
	#name : #BaselineOfConcurrentST,
	#superclass : #BaselineOf,
	#category : #BaselineOfConcurrentST
}

{ #category : #baselines }
BaselineOfConcurrentST >> baseline: spec [

	<baseline>
	spec for: #common do: [ 
		spec
			package: 'ConcurrentST-Extensions';
			package: 'ConcurrentST';
			package: 'ConcurrentST-Tests'
			with: [ spec requires: #( 'ConcurrentST' ) ];
			package: 'ConcurrentST-Cells';
			with: [ spec requires: #( 'ConcurrentST-Cells' ) ];
			package: 'ConcurrentST-Channels';
			with: [ spec requires: #( 'ConcurrentST-Channels' ) ] ]
]
