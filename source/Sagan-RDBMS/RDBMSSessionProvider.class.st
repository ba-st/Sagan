Class {
	#name : 'RDBMSSessionProvider',
	#superclass : 'Object',
	#instVars : [
		'options',
		'login'
	],
	#category : 'Sagan-RDBMS-Repository',
	#package : 'Sagan-RDBMS',
	#tag : 'Repository'
}

{ #category : 'accessing' }
RDBMSSessionProvider >> clearSessions [

	self subclassResponsibility 
]

{ #category : 'accessing' }
RDBMSSessionProvider >> deleteSessions [

	self subclassResponsibility 
]

{ #category : 'retrying' }
RDBMSSessionProvider >> ensureSuccessfulLoginToDatabaseWith: aSession [

	Retry
		value: [ aSession loginIfError: [ :error | DatabaseLoginFailed signal: error description ] ]
		configuredBy: [ :retry | 
			retry
				upTo: self retryAttempts;
				backoffExponentiallyWithTimeSlot: self timeframeBetweenAttempts;
				on: DatabaseLoginFailed evaluating: [ :tryCount :loginFailure | 
					LogRecord emitWarning: ( 'Failed to connect to database after <1p> attempts because <2s>'
								  expandMacrosWith: tryCount
								  with: loginFailure messageText )
					]
			]
]

{ #category : 'initialization' }
RDBMSSessionProvider >> initializeLoginWith: aLogin configuredBy: anOptions [

	login := aLogin.
	options := anOptions
]

{ #category : 'initialization' }
RDBMSSessionProvider >> isLoggingEnabled [

	^ options at: #logDatabaseEvents ifAbsent: [ false ]
]

{ #category : 'accessing' }
RDBMSSessionProvider >> retryAttempts [

	^ options at: #maximumConnectionAttemps ifAbsent: [ 3 ]
]

{ #category : 'accessing' }
RDBMSSessionProvider >> timeframeBetweenAttempts [

	^ options
		  at: #timeSlotBetweenConnectionRetriesInMs
		  ifAbsent: [ Duration milliSeconds: 3000 ]
]

{ #category : 'enumerating' }
RDBMSSessionProvider >> withConfigurationSessionDo: aBlockClosure [

	self subclassResponsibility 
]

{ #category : 'enumerating' }
RDBMSSessionProvider >> withSessionDo: aBlockClosure [

	self subclassResponsibility 
]
