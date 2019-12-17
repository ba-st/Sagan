Class {
	#name : #SingleRDBMSSessionProvider,
	#superclass : #RDBMSSessionProvider,
	#instVars : [
		'session',
		'login'
	],
	#category : #'Sagan-RDBMS-Repository'
}

{ #category : #'instance creation' }
SingleRDBMSSessionProvider class >> loginWith: aLogin [

	^ self new initializeLoginWith: aLogin
]

{ #category : #accessing }
SingleRDBMSSessionProvider >> clearSessions [

	session logout
]

{ #category : #accessing }
SingleRDBMSSessionProvider >> deleteSessions [

	self clearSessions.
	session := nil
]

{ #category : #initialization }
SingleRDBMSSessionProvider >> initializeLoginWith: aLogin [
	
	login := aLogin. 
	
]

{ #category : #initialization }
SingleRDBMSSessionProvider >> initializeSession [

	session := GlorpSession new.
	session accessor: ( DatabaseAccessor forLogin: login ).
	session system: ConfigurableDescriptorSystem new.
	session loginIfError: [ :error | DatabaseLoginFailed signal: error description ]
]

{ #category : #'private-accessing' }
SingleRDBMSSessionProvider >> session [

	session ifNil: [ self initializeSession ].
	^ session
]

{ #category : #accessing }
SingleRDBMSSessionProvider >> withConfigurationSessionDo: aBlockClosure [

	aBlockClosure value: self session
]

{ #category : #accessing }
SingleRDBMSSessionProvider >> withSessionDo: aBlockClosure [

	^ aBlockClosure value: self session
]
