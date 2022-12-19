Class {
	#name : #PooledRDBMSSessionProvider,
	#superclass : #RDBMSSessionProvider,
	#instVars : [
		'login',
		'descriptorSystem',
		'configurationSession',
		'sessionPool',
		'descriptorsBySession',
		'descriptorSystemWasCopied',
		'loggingEnabled'
	],
	#category : #'Sagan-RDBMS-Repository'
}

{ #category : #'instance creation' }
PooledRDBMSSessionProvider class >> loginWith: aLogin configuredBy: aBlock [

	| options |
	options := Dictionary new.
	aBlock cull: options.
	^ self new initializeLoginWith: aLogin configuredBy: options
]

{ #category : #'private-accessing' }
PooledRDBMSSessionProvider >> assertDescriptorSystemCanBeConfigured [

	descriptorSystemWasCopied
		ifTrue: [ self error: 'DescriptorSystem has been copied and cannot longer be configured' ]
]

{ #category : #accessing }
PooledRDBMSSessionProvider >> clearSessions [

	sessionPool clear.
	configurationSession reset
]

{ #category : #'private-accessing' }
PooledRDBMSSessionProvider >> configureDescriptorSystemTo: aGlorpSession [

	| system |

	" Once copied, the Descriptor System can no longer be configured. - jvanecek "
	descriptorSystemWasCopied := true.

	system := descriptorsBySession at: aGlorpSession ifAbsentPut: [ descriptorSystem copy ].
	aGlorpSession system: system.
	^ aGlorpSession
]

{ #category : #'private-accessing' }
PooledRDBMSSessionProvider >> createDatabaseAccessor [

	| accessor |
	accessor := DatabaseAccessor forLogin: login.
	loggingEnabled then: [ 
		accessor logging: true.
		accessor logger: GlorpLoggerToLaunchpadLogRecordAdapter new ].
	^ accessor
]

{ #category : #'private-accessing' }
PooledRDBMSSessionProvider >> createNewSession [

	| session |
	session := GlorpSession new.
	session accessor: self createDatabaseAccessor.
	session system: descriptorSystem.
	session loginIfError: [ :error | DatabaseLoginFailed signal: error description ].
	^ session
]

{ #category : #accessing }
PooledRDBMSSessionProvider >> deleteSessions [

	sessionPool minIdleObjects: nil.
	self clearSessions.
	configurationSession logout
]

{ #category : #initialization }
PooledRDBMSSessionProvider >> initializeConfigurationSession [

	configurationSession := self createNewSession.

]

{ #category : #initialization }
PooledRDBMSSessionProvider >> initializeLoginWith: aLogin configuredBy: options [

	login := aLogin.
	loggingEnabled := options at: #logDatabaseEvents ifAbsent: [ false ].
	descriptorSystem := ConfigurableDescriptorSystem new.
	descriptorSystemWasCopied := false.
	self initializeConfigurationSession.
	self initializeWorkingSessionsPoolConfiguredBy: options
]

{ #category : #initialization }
PooledRDBMSSessionProvider >> initializeWorkingSessionsPoolConfiguredBy: options [

	descriptorsBySession := Dictionary new.
	sessionPool := OPBasicPool new.
	sessionPool
		creator: [ self createNewSession ];
		destroyer: #logout;
		validator: #isLoggedIn;
		passivator: #reset;
		activator: [ :session | self configureDescriptorSystemTo: session ];
		maxIdleObjects: (options at: #maxIdleSessionsCount ifAbsent: [ 10 ]);
		minIdleObjects: (options at: #minIdleSessionsCount ifAbsent: [ 5 ]);
		maxActiveObjects: (options at: #maxActiveSessionsCount ifAbsent: [ 12 ])
]

{ #category : #accessing }
PooledRDBMSSessionProvider >> withConfigurationSessionDo: aBlockClosure [

	self assertDescriptorSystemCanBeConfigured.
	
	aBlockClosure cull: configurationSession
]

{ #category : #accessing }
PooledRDBMSSessionProvider >> withSessionDo: aBlockClosure [

	^ CurrentRDBMSSession
		withValueDo: aBlockClosure
		ifAbsent: [ sessionPool
				withPooled: [ :session | 
					self configureDescriptorSystemTo: session.
					CurrentRDBMSSession value: session during: [ aBlockClosure value: session ]
					]
			]
]
