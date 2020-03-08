set-strictMode -version 2

#
# ..\sqlite\interop.ps1
#  import-module ..\sqlite\wrapper.ps1
# new-psDrive -name HKCR -psProvider registry -root HKEY_CLASSES_ROOT
#
#  {4DF0A565-9D57-4495-AA5F-060662E6CF30}

[sqliteDB] $db = [sqliteDB]::new("$($pwd)\windows-registry.db", $true)

# $db = sqliteNewDB "$pwd\windows-registry.db"

# sqliteExec $db 'create table CLSID(id, InprocServer32, ProgId, AppId)'
# sqliteExec $db 'create table CLSID(id, name)'
$db.exec('create table CLSID(id, name)')

#$stmt = sqlitePrepareStmt $db 'insert into CLSID values (?, ?)'
[sqliteStmt] $stmt = $db.prepareStmt('insert into CLSID values (?, ?)')

# sqliteExec $db 'begin transaction'
$db.exec('begin transaction')


# $hklm = get-item hklm:
$hkcr_clsid = get-item hkcr:\clsid

foreach ($clsidGuid in $hkcr_clsid.GetSubKeyNames()) {
   $clsidKey       = $hkcr_clsid.OpenSubKey($clsidGuid)
   $clsidName      = $clsidKey.GetValue('')
# "$clsidGuid $($clsidKey.GetValue(''))"

#   echo $clsidGuid


   foreach ($valName in $clsidKey.GetValueNames()) {
      if (-not ('', 'AppId', 'InfoTip', 'LocalizedString', 'System.ApplicationName', 'System.ControlPanel.Category', 'System.ControlPanel.EnableInSafeMode' -contains $valName)) {
      #   echo "$clsidGuid : Unknown value $valName<"
      } 
   }

   foreach ($subKeyName in $clsidKey.GetSubKeyNames()) {
      if ( -not ('InProcServer32', 'InProcHandler32', 'LocalServer32', 'ProgId', 'Elevation', 'VersionIndependentProgID',
                 'TypeLib', 'Implemented Categories', 'Programmable', 'Version', 'DefaultIcon',
                 'ToolBoxBitmap32' -contains $subKeyName ) ) {
      #   echo "$clsidGuid : Unknown subkeyName $subKeyName<"
      }
   }


  # sqliteBindArrayStepReset $stmt ( $clsidGuid , $clsidName )
    $stmt.bindArrayStepReset( ($clsidGuid, $clsidName) )


<#
   $appId = $clsidKey.GetValue('AppID')
   if ($appId -ne $null) {
      "  appId: $appId"
   }   

   $InProcServer32 = $clsidKey.OpenSubKey('InProcServer32')
   if ($InProcServer32 -ne $null) {
     "  InProcServer32: $($InProcServer32.GetValue(''))" 
   }
   else {
      "  InProcServer32: null"
   }

   #  Programmable
   #  TypeLib
   #  Version
   $InProcServer32 = $clsidKey.OpenSubKey('InProcServer32')  
#>

}

# sqliteExec $db 'commit'
$db.exec('commit')

#sqliteFinalize $stmt
#sqliteClose $db
$stmt.finalize()
$db.close()