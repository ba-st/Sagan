Class {
	#name : #SingleRDBMSSessionProvider,
	#superclass : #RDBMSSessionProvider,
	#instVars : [
		'session',
		'login',
		'loggingEnabled'
	],
	#category : #'Sagan-RDBMS-Repository'
}

{ #category : #'instance creation' }
SingleRDBMSSessionProvider class >> loginWith: aLogin [

	^ self loginWith: aLogin configuredBy: [  ]
]

{ #category : #'instance creation' }
SingleRDBMSSessionProvider class >> loginWith: aLogin configuredBy: aBlock [

	| options |
	options := Dictionary new.
	aBlock cull: options.
	^ self new initializeLoginWith: aLogin configuredBy: options
]

{ #category : #accessing }
SingleRDBMSSessionProvider >> clearSessions [

	session logout
]

{ #category : #initialization }
SingleRDBMSSessionProvider >> createDatabaseAccessor [

	| accessor |
	accessor := DatabaseAccessor forLogin: login.
	loggingEnabled then: [ 
		accessor logging: true.
		accessor logger: GlorpLoggerToLogRecordAdapter new ].
	^ accessor
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
SingleRDBMSSessionProvider >> initializeLoginWith: aLogin configuredBy: options [

	login := aLogin.
	loggingEnabled := options at: #logDatabaseEvents ifAbsent: [ false ]
]

{ #category : #initialization }
SingleRDBMSSessionProvider >> initializeSession [

	session := GlorpSession new.
	session accessor: self createDatabaseAccessor.
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
