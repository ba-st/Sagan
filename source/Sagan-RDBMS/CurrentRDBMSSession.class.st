Class {
	#name : #CurrentRDBMSSession,
	#superclass : #DynamicVariable,
	#category : #'Sagan-RDBMS-Repository'
}

{ #category : #enumerating }
CurrentRDBMSSession class >> withValueDo: aMonadycBlock ifAbsent: aNyladicBlock [

	^ self soleInstance valueOrNil ifNil: aNyladicBlock ifNotNil: aMonadycBlock
]
