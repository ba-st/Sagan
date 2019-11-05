Class {
	#name : #SessionReturningToPoolOnFinalize,
	#superclass : #Object,
	#instVars : [
		'pool',
		'realSession'
	],
	#category : #'Sagan-RDBMS-Repository'
}

{ #category : #'instance creation' }
SessionReturningToPoolOnFinalize class >> wrapping: anObject returningOnFinalizeTo: anObjectPool [

	^ self new initializeWrapping: anObject returningOnFinalizeTo: anObjectPool
]

{ #category : #finalization }
SessionReturningToPoolOnFinalize >> finalize [

	realSession ifNotNil: [ pool return: realSession ].
	super finalize
]

{ #category : #initialization }
SessionReturningToPoolOnFinalize >> initializeWrapping: anObject returningOnFinalizeTo: anObjectPool [

	realSession := anObject.
	pool := anObjectPool
]

{ #category : #initialization }
SessionReturningToPoolOnFinalize >> realSession [

	^ realSession
]
