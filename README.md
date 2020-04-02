# trusted_ca

This cookbook leverages the Chef-maintained `trusted_certificate` cookbook to manage local CAs from a data bag.

## Requirements

### Platforms
* Debian
* Ubuntu
* Red Hat Enterprise Linux 6+ and derivatives

### Cookbooks
* [`trusted_certificate`](https://supermarket.chef.io/cookbooks/trusted_certificate)

### Data Bags

Trusted CA certificates must be added to a data bag item under the `cert` key.

Acceptable formats are:
* A base64-encoded certificate with newlines represented by `\n`, or
* A URL to a certificate stored on a web server, or
* A reference to a certificate file stored in another cookbook.

###### String Example
```
{
  "id": "Demo_Root_CA",
  "cert": "-----BEGIN CERTIFICATE-----\nMIIBIjCB0KADAgECAgh1ryuW7+WnpDAKBggqhkjOPQQDAjAAMB4XDTIwMDQwMTAy\nMDUwMFoXDTMwMDQwMTAyMDUwMFowADBOMBAGByqGSM49AgEGBSuBBAAhAzoABJ5P\n2Ly9yrn9Sp3bseqhPOZixppwgfBR36WdcV2dDGWpThupZhTDahC4Ex3OrTFo20F2\n6wEgR+Mzoz8wPTAPBgNVHRMBAf8EBTADAQH/MB0GA1UdDgQWBBSzmAQ2oDqtjoCL\nR4/wahKiX2TzpDALBgNVHQ8EBAMCAYYwCgYIKoZIzj0EAwIDQQAwPgIdANDK83M9\nCjT6SYG3AvMnxqZQ75U7wo2T/XmttPgCHQCK9jxw4f8QrnaEvhtUQ7So18+b6E3i\nl/S5Y/3i\n-----END CERTIFICATE-----"
}
```

The CA certificate contained above will be installed to the local CA certificate directory as `Demo_Root_CA.crt`.

###### HTTP Example
```
{
  "id": "Company_Internal_CA",
  "cert": "http://intranet.company.net/my_certificate.crt"
}
```

The CA certificate linked above will be downloaded and installed to the local CA certificate directory as `Company_Internal_CA.crt`.

### Attributes

This cookbook reads three attributes to determine runtime behavior:
* `node['trusted_ca']['data_bag']` - The name of the data bag in which certificates are stored.
* `node['trusted_ca']['add']` - A string array of data bag items containing trusted CA certificates to be installed.
* `node['trusted_ca']['remove']` - A string array of certificate names to remove from the system.

###### Example
```
node['trusted_ca']['data_bag'] = "my_certs"
node['trusted_ca']['add'] = ['Demo_Root_CA']
node['trusted_ca']['remove'] = ['Bad_Root_CA']
```

This example will install the certificate `Demo_Root_CA` from data bag `my_certs` in the operating system's local CA certificate directory.  If present, the certificate named `Bad_Root_CA.crt` will be deleted.

__Note:__ This cookbook only manages local CAs.  Global CAs shipped by your OS vendor cannot be removed by this cookbook.

## Recipes

### default

1. Installs the `ca-certificates` package from the OS package manager
2. Installs or removes CA certificates listed in the `add` and `remove` attributes.
