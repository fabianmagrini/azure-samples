﻿using Azure.Identity;
using Azure.Security.KeyVault.Keys;
using Azure.Security.KeyVault.Keys.Cryptography;
using System.Security.Cryptography;
using System.Text;


var azureClientId = Environment.GetEnvironmentVariable("AZURE_CLIENT_ID");
var azureClientSecret = Environment.GetEnvironmentVariable("AZURE_CLIENT_SECRET");
var azureTenantId = Environment.GetEnvironmentVariable("AZURE_TENANT_ID");
var keyVaultUrl = Environment.GetEnvironmentVariable("keyVaultUrl");

Console.WriteLine($"AZURE_CLIENT_ID={azureClientId}");
Console.WriteLine($"AZURE_CLIENT_SECRET={azureClientSecret}");
Console.WriteLine($"AZURE_TENANT_ID={azureTenantId}");
Console.WriteLine($"keyVaultUrl={keyVaultUrl}");

if (keyVaultUrl == null) {
    Console.WriteLine($"keyVaultUrl is null");
    System.Environment.Exit(1);
}


string[] arguments = Environment.GetCommandLineArgs();
//Console.WriteLine("GetCommandLineArgs: {0}", string.Join(", ", arguments));

if (arguments.Length != 3)
{
    Console.WriteLine("You must provide the name of a file to read and the name of a file to write.");
    System.Environment.Exit(1);
}

var sourceFilename = args[0];
var destinationFilename = args[1];

byte[] keyData = Aes.Create().Key;

using (var sourceStream = File.OpenRead(sourceFilename))
using (var destinationStream = File.Create(destinationFilename))
using (var aesAlgorithm = Aes.Create())
using (var cryptoTransform = aesAlgorithm.CreateEncryptor())
using (var cryptoStream = new CryptoStream(destinationStream, cryptoTransform, CryptoStreamMode.Write))
{
    sourceStream.CopyTo(cryptoStream);
    keyData = aesAlgorithm.Key;
}

Console.WriteLine($"Generated Key: {Convert.ToBase64String(keyData)}");

// Create a new key client using the default credential from Azure.Identity using environment variables previously set,
// including AZURE_CLIENT_ID, AZURE_CLIENT_SECRET, and AZURE_TENANT_ID.
var keyVaultClient = new KeyClient(vaultUri: new Uri(keyVaultUrl), credential: new DefaultAzureCredential());

// First create a RSA key which will be used to wrap and unwrap another key
string rsaKeyName = $"CloudRsaKey-{Guid.NewGuid()}";
var rsaKey = new CreateRsaKeyOptions(rsaKeyName, hardwareProtected: false)
{
    KeySize = 2048,
};

KeyVaultKey cloudRsaKey = await keyVaultClient.CreateRsaKeyAsync(rsaKey);
Console.WriteLine($"Key is returned with name {cloudRsaKey.Name} and type {cloudRsaKey.KeyType}");

// Next we'll generate a symmetric key which we will wrap
//byte[] keyData = Aes.Create().Key;
//Console.WriteLine($"Generated Key: {Convert.ToBase64String(keyData)}");
//var aesKey = System.Security.Cryptography.Aes.Create().Key;

var cryptoClient = new CryptographyClient(cloudRsaKey.Id, new DefaultAzureCredential());
var wrapResult = await cryptoClient.WrapKeyAsync(KeyWrapAlgorithm.RsaOaep, keyData);

Console.WriteLine($"Encrypted data using the algorithm {wrapResult.Algorithm}, with key {wrapResult.KeyId}. The resulting encrypted data is {Convert.ToBase64String(wrapResult.EncryptedKey)}");

// Now unwrap the encrypted key. Note that the same algorithm must always be used for both wrap and unwrap
UnwrapResult unwrapResult = await cryptoClient.UnwrapKeyAsync(KeyWrapAlgorithm.RsaOaep, wrapResult.EncryptedKey);
Console.WriteLine($"Decrypted data using the algorithm {unwrapResult.Algorithm}, with key {unwrapResult.KeyId}. The resulting decrypted data is {Encoding.UTF8.GetString(unwrapResult.Key)}");

// The Cloud RSA Key is no longer needed, need to delete it from the Key Vault.
DeleteKeyOperation operation = await keyVaultClient.StartDeleteKeyAsync(rsaKeyName);

// You only need to wait for completion if you want to purge or recover the key.
await operation.WaitForCompletionAsync();

// If the keyvault is soft-delete enabled, then for permanent deletion, deleted key needs to be purged.
await keyVaultClient.PurgeDeletedKeyAsync(rsaKeyName);


