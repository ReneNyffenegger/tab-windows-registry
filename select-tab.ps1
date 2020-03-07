set-strictMode -version 2

[IntPtr]$db = sqliteOpen "$($pwd)\windows-registry.db"

$stmt = sqlitePrepareStmt $db 'select * from clsid order by id'
# sqliteBind $stmt 1 50

while ( (sqliteStep $stmt) -ne [sqlite]::DONE ) {
   echo "$(sqliteCol $stmt 0) | $(sqliteCol $stmt 1)"
}

sqliteFinalize $stmt
sqliteClose $db