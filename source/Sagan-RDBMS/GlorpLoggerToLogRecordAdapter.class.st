Class {
	#name : 'GlorpLoggerToLogRecordAdapter',
	#superclass : 'Object',
	#category : 'Sagan-RDBMS-Repository',
	#package : 'Sagan-RDBMS',
	#tag : 'Repository'
}

{ #category : 'printing' }
GlorpLoggerToLogRecordAdapter >> cr [
	" "
]

{ #category : 'printing' }
GlorpLoggerToLogRecordAdapter >> flush [
	" "
]

{ #category : 'printing' }
GlorpLoggerToLogRecordAdapter >> nextPutAll: aString [

	LogRecord
		emitStructuredDebuggingInfo: 'Glorp event received'
		with: [ :data | data at: #detail put: aString ]
]
