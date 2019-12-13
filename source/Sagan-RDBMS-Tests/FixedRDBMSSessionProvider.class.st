Class {
	#name : #FixedRDBMSSessionProvider,
	#superclass : #RDBMSSessionProvider,
	#instVars : [
		'session'
	],
	#category : #'Sagan-RDBMS-Tests'
}

{ #category : #'instance creation' }
FixedRDBMSSessionProvider class >> using: aGlorpSession [

	^ self new initializeUsing: aGlorpSession
]

{ #category : #accessing }
FixedRDBMSSessionProvider >> clearSessions [

	" do nothing "

	
]

{ #category : #accessing }
FixedRDBMSSessionProvider >> deleteSessions [

	" do nothing "

	
]

{ #category : #initialization }
FixedRDBMSSessionProvider >> initializeUsing: aGlorpSession [ 

	session := aGlorpSession 
]

{ #category : #accessing }
FixedRDBMSSessionProvider >> withConfigurationSessionDo: aBlockClosure [

	^ aBlockClosure value: session
]

{ #category : #accessing }
FixedRDBMSSessionProvider >> withWorkingSessionDo: aBlockClosure [

	^ aBlockClosure value: session
]
