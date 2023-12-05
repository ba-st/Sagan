Class {
	#name : 'CurrentRDBMSSession',
	#superclass : 'DynamicVariable',
	#category : 'Sagan-RDBMS-Repository',
	#package : 'Sagan-RDBMS',
	#tag : 'Repository'
}

{ #category : 'enumerating' }
CurrentRDBMSSession class >> withValueDo: aMonadycBlock ifAbsent: aNyladicBlock [

	^ self soleInstance valueOrNil ifNil: aNyladicBlock ifNotNil: aMonadycBlock
]
