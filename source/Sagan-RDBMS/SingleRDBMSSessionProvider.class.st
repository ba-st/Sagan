Class {
	#name : #SingleRDBMSSessionProvider,
	#superclass : #RDBMSSessionProvider,
	#instVars : [
		'session'
	],
	#category : #'Sagan-RDBMS-Repository'
}

{ #category : #'instance creation' }
SingleRDBMSSessionProvider class >> loginWith: aLogin configuredBy: anActionConfiguration [

	| options |
	options := Dictionary new.
	anActionConfiguration cull: options.
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
	self isLoggingEnabled then: [ 
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
SingleRDBMSSessionProvider >> initializeSession [

	session := GlorpSession new.
	session accessor: self createDatabaseAccessor.
	session system: ConfigurableDescriptorSystem new.
	self ensureSuccessfulLoggingToDatabaseWith: session
]

{ #category : #'private-accessing' }
SingleRDBMSSessionProvider >> session [

	session ifNil: [ self initializeSession ].
	^ session
]

{ #category : #accessing }
SingleRDBMSSessionProvider >> withConfigurationSessionDo: aBlockClosure [
	
	self withSessionDo: aBlockClosure
]

{ #category : #accessing }
SingleRDBMSSessionProvider >> withSessionDo: aBlockClosure [

	| currentSession |

	currentSession := self session.
	currentSession isLoggedIn not then: [ self ensureSuccessfulLoggingToDatabaseWith: currentSession ].
	^ aBlockClosure value: currentSession
]
