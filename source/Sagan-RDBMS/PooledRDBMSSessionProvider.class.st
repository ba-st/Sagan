Class {
	#name : #PooledRDBMSSessionProvider,
	#superclass : #RDBMSSessionProvider,
	#instVars : [
		'login',
		'descriptorSystem',
		'configurationSession',
		'sessionPool',
		'descriptorsBySession',
		'descriptorSystemWasCopied'
	],
	#category : #'Sagan-RDBMS-Repository'
}

{ #category : #'instance creation' }
PooledRDBMSSessionProvider class >> loginWith: aLogin [ 

	^ self new initializeLoginWith: aLogin
]

{ #category : #accessing }
PooledRDBMSSessionProvider >> clearSessions [

	sessionPool clear
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
PooledRDBMSSessionProvider >> createNewSession [

	| session |

	session := GlorpSession new.
	session accessor: ( DatabaseAccessor forLogin: login ).
	session system: descriptorSystem.
	session loginIfError: [ :error | DatabaseLoginFailed signal: error description ].
	^ session
]

{ #category : #accessing }
PooledRDBMSSessionProvider >> deleteSessions [

	sessionPool minIdleObjects: nil.
	self clearSessions
]

{ #category : #initialization }
PooledRDBMSSessionProvider >> initializeConfigurationSession [

	configurationSession := self createNewSession.

]

{ #category : #initialization }
PooledRDBMSSessionProvider >> initializeLoginWith: aLogin [

	#jvanecek asString.
	login := aLogin.
	descriptorSystem := ConfigurableDescriptorSystem new.
	descriptorSystemWasCopied := false.
	self initializeConfigurationSession.
	self initializeWorkingSessionsPool
]

{ #category : #initialization }
PooledRDBMSSessionProvider >> initializeWorkingSessionsPool [

	descriptorsBySession := Dictionary new.
	sessionPool := OPBasicPool new.
	sessionPool
		creator: [ self createNewSession ];
		destroyer: [ :session | session logout ];
		validator: [ :session | session isLoggedIn ];
		passivator: [ :session | session reset ];
		activator: [ :session | self configureDescriptorSystemTo: session ];
		maxIdleObjects: 10;
		minIdleObjects: 5;
		maxActiveObjects: 12
]

{ #category : #accessing }
PooledRDBMSSessionProvider >> withConfigurationSessionDo: aBlockClosure [

	descriptorSystemWasCopied
		ifTrue: [ self error: 'DescriptorSystem has been copied and cannot longer be configured' ].

	aBlockClosure cull: configurationSession
]

{ #category : #accessing }
PooledRDBMSSessionProvider >> withWorkingSessionDo: aBlockClosure [

	^ CurrentRDBMSSession
		withValueDo: aBlockClosure
		ifAbsent: [ sessionPool
				withPooled: [ :session | 
					self configureDescriptorSystemTo: session.
					CurrentRDBMSSession value: session during: [ aBlockClosure value: session ]
					]
			]
]
