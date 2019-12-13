Class {
	#name : #RDBMSSessionProvider,
	#superclass : #Object,
	#category : #'Sagan-RDBMS-Repository'
}

{ #category : #accessing }
RDBMSSessionProvider >> clearSessions [

	self subclassResponsibility 
]

{ #category : #accessing }
RDBMSSessionProvider >> deleteSessions [

	self subclassResponsibility 
]

{ #category : #enumerating }
RDBMSSessionProvider >> withConfigurationSessionDo: aBlockClosure [

	self subclassResponsibility 
]

{ #category : #enumerating }
RDBMSSessionProvider >> withWorkingSessionDo: aBlockClosure [

	self subclassResponsibility 
]
