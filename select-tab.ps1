set-strictMode -version 2

# [IntPtr]$db = sqliteOpen "$($pwd)\windows-registry.db"
[sqliteDB] $db = [sqliteDB]::new("$($pwd)\windows-registry.db")


$stmt = $db.prepareStmt('select * from clsid order by id')
# sqliteBind $stmt 1 50

while( $stmt.step() -ne [sqlite]::DONE ) {
   echo "$($stmt.col(0)) | $($stmt.col(1))"
}

<#
while ( (sqliteStep $stmt) -ne [sqlite]::DONE ) {
   echo "$(sqliteCol $stmt 0) | $(sqliteCol $stmt 1)"
}
#>

$stmt.finalize()# $stmt
$db.close()