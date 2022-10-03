Class {
	#name : #GlorpLoggerToLaunchpadLogRecordAdapter,
	#superclass : #Object,
	#category : #'Sagan-RDBMS-Repository'
}

{ #category : #printing }
GlorpLoggerToLaunchpadLogRecordAdapter >> cr [
	" "
]

{ #category : #printing }
GlorpLoggerToLaunchpadLogRecordAdapter >> show: aString [

	LaunchpadLogRecord
		emitStructuredDebuggingInfo: 'Glorp event received'
		with: [ :data | data at: #detail put: aString ]
]
