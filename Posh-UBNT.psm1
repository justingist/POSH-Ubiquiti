# Many thanks to this git repo for the key and basic logic! https://github.com/zhangyoufu/unifi-backup-decrypt
# Also AES credit: https://gist.github.com/ctigeek/2a56648b923d198a6e60
#Usage: Decrypt-UBNTBKP -ubntbkp .\pathtomy.unf
#Output will be a tar.gz in same directory as your initial file. Use your favorite archive tool to open, such as 7-zip.

Function Decrypt-UBNTBKP {
[CmdletBinding()]
Param(
	[Parameter(
		Mandatory=$true,
		ValueFromPipeline=$true,
		HelpMessage="Filepath to Unifi Backup File")]
	[string]$ubntbkp
)
    $fullpath = (get-item $ubntbkp).FullName
    $encryptedstring = get-content $fullpath -Encoding Byte
    $outfile = $fullpath.Replace('.unf','.tar.gz')
    $key = [system.text.encoding]::UTF8.GetBytes("bcyangkmluohmars")
    $iv = [system.text.encoding]::UTF8.GetBytes("ubntenterpriseap")
    $aesManaged = Create-AesManagedObject -key $key -IV $iv
	$decryptor = $aesManaged.CreateDecryptor();
    $unencryptedData = $decryptor.TransformFinalBlock($encryptedstring, 16, $encryptedstring.Length - 16)
    $aesManaged.Dispose()

    [io.file]::WriteAllBytes($outfile,$unencryptedData)
}

function Create-AesManagedObject($key, $IV) {
    $aesManaged = New-Object "System.Security.Cryptography.AesManaged"
    $aesManaged.Mode = [System.Security.Cryptography.CipherMode]::CBC
    $aesManaged.Padding = [System.Security.Cryptography.PaddingMode]::Zeros
    $aesManaged.BlockSize = 128
    $aesManaged.KeySize = 256
    if ($IV) {
        if ($IV.getType().Name -eq "String") {
            $aesManaged.IV = [System.Convert]::FromBase64String($IV)
        }
        else {
            $aesManaged.IV = $IV
        }
    }
    if ($key) {
        if ($key.getType().Name -eq "String") {
            $aesManaged.Key = [System.Convert]::FromBase64String($key)
        }
        else {
            $aesManaged.Key = $key
        }
    }
    $aesManaged
}
