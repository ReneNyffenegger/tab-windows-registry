$db = sqliteNewDB "$pwd\windows-registry.db"

sqliteExec $db 'create table CLSID(id, InprocServer32, ProgId)'

$stmt = sqlitePrepareStmt $db 'insert into CLSID values (?, ?, )'