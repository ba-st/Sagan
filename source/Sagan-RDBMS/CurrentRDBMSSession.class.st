Class {
	#name : #CurrentRDBMSSession,
	#superclass : #ProcessLocalVariable,
	#category : #'Sagan-RDBMS-Repository'
}

{ #category : #enumerating }
CurrentRDBMSSession class >> destroy [

	self soleInstance valueOrNil ifNotNil: #finalize.
	self soleInstance value: nil
]

{ #category : #enumerating }
CurrentRDBMSSession class >> withValueDo: aMonadycBlock ifAbsent: aNyladicBlock [

	^ self soleInstance valueOrNil ifNil: aNyladicBlock ifNotNil: aMonadycBlock
]
