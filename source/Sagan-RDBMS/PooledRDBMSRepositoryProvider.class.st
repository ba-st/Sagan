Class {
	#name : #PooledRDBMSRepositoryProvider,
	#superclass : #RepositoryProvider,
	#instVars : [
		'sessionPool',
		'descriptorSystem',
		'login'
	],
	#category : #'Sagan-RDBMS-Repository'
}

{ #category : #'instance creation' }
PooledRDBMSRepositoryProvider class >> using: aLogin [

	^ self new initializeUsing: aLogin
]

{ #category : #building }
PooledRDBMSRepositoryProvider >> createRepositoryStoringObjectsOfType: aBusinessObjectClass
	checkingConflictsAccordingTo: aConflictCheckingStrategy [


	^ RDBMSRepository
		storingObjectsOfType: aBusinessObjectClass
		checkingConflictsAccordingTo: aConflictCheckingStrategy
		workingWith: self currentSessionBlock
]

{ #category : #private }
PooledRDBMSRepositoryProvider >> currentSessionBlock [

	^ [ :actionBlock | 
	CurrentRDBMSSession
		withValueDo: actionBlock
		ifAbsent: [ sessionPool
				withPooled: [ :session | CurrentRDBMSSession value: session during: [ actionBlock value: session ] ]
			]
	]
]

{ #category : #initialization }
PooledRDBMSRepositoryProvider >> initializeUsing: aLogin [

	login := aLogin.
	descriptorSystem := ConfigurableDescriptorSystem new.
	sessionPool := OPBasicPool new.
	sessionPool
		maxIdleObjects: 10;
		minIdleObjects: 5;
		maxActiveObjects: 12;
		creator: [ 
			| session |
			session := descriptorSystem sessionForLogin: login.
			session loginIfError: [ :error | DatabaseLoginFailed signal: error description ].
			session
			];
		destroyer: [ :session | session logout ];
		validator: [ :session | session isLoggedIn ];
		passivator: [ :session | session reset ]
]

{ #category : #controlling }
PooledRDBMSRepositoryProvider >> prepareForInitialPersistence [

	self currentSessionBlock
		value: [ :session | 
			session
				recreateTablesIfError: [ :error | Error signal: error description ];
				logout;
				loginIfError: [ :error | Error signal: error description ]
			]
]

{ #category : #controlling }
PooledRDBMSRepositoryProvider >> reset [

	sessionPool clear
]
