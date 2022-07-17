using Azure.Identity;
using Azure.Security.KeyVault.Keys;

var azureClientId = Environment.GetEnvironmentVariable("AZURE_CLIENT_ID");
var azureClientSecret = Environment.GetEnvironmentVariable("AZURE_CLIENT_SECRET");
var azureTenantId = Environment.GetEnvironmentVariable("AZURE_TENANT_ID");
var keyVaultUrl = Environment.GetEnvironmentVariable("keyVaultUrl");

Console.WriteLine($"AZURE_CLIENT_ID={azureClientId}");
Console.WriteLine($"AZURE_CLIENT_SECRET={azureClientSecret}");
Console.WriteLine($"AZURE_TENANT_ID={azureTenantId}");
Console.WriteLine($"keyVaultUrl={keyVaultUrl}");

// Create a new key client using the default credential from Azure.Identity using environment variables previously set,
// including AZURE_CLIENT_ID, AZURE_CLIENT_SECRET, and AZURE_TENANT_ID.
var client = new KeyClient(vaultUri: new Uri(keyVaultUrl), credential: new DefaultAzureCredential());

// Create a new key using the key client.
KeyVaultKey key = client.CreateKey("key-name", KeyType.Rsa);

// Retrieve a key using the key client.
key = client.GetKey("key-name");

Console.WriteLine(key.Name);
Console.WriteLine(key.KeyType);

// Create a software RSA key
var rsaCreateKey = new CreateRsaKeyOptions("rsa-key-name", hardwareProtected: false);
KeyVaultKey rsaKey = client.CreateRsaKey(rsaCreateKey);

Console.WriteLine(rsaKey.Name);
Console.WriteLine(rsaKey.KeyType);