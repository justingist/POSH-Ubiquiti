# Many thanks to this git repo for the key and basic logic! https://github.com/zhangyoufu/unifi-backup-decrypt
# Also AES credit: https://gist.github.com/ctigeek/2a56648b923d198a6e60
#Usage: Decrypt-UBNTBKP -ubntbkp .\pathtomy.unf
#Output will be a tar.gz in same directory as your initial file. Use your favorite archive tool to open, such as 7-zip.

Function Decrypt-UBNTBKP {
Param($ubntbkp)
    $fullpath = (get-item $ubntbkp).FullName
    $encryptedstring = get-content $fullpath -Encoding Byte
    $outfile = $fullpath.Replace('.unf','.tar.gz')
    $key = [system.text.encoding]::UTF8.GetBytes("bcyangkmluohmars")

    $iv = [system.text.encoding]::UTF8.GetBytes("ubntenterpriseap")
    $aesManaged = Create-AesManagedObject -key $key -IV $iv
    $unencryptedData = $decryptor.TransformFinalBlock($encryptedstring, 16, $encryptedstring.Length - 16)
    $aesManaged.Dispose()

    [io.file]::WriteAllBytes($outfile,$unencryptedData)

}
