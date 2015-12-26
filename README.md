zephir install
===============
http://docs.zephir-lang.com/en/latest/install.html


Asset Component
===============

The Asset component manages asset URLs.

Versioned Asset URLs
--------------------

The basic `Package` adds a version to generated asset URLs:

```php
use Symfony\Component\Asset\Package;
use Symfony\Component\Asset\VersionStrategy\StaticVersionStrategy;

$package = new Package(new StaticVersionStrategy('v1'));

echo $package->getUrl('/me.png');
// /me.png?v1
```

The default format can be configured:

```php
$package = new Package(new StaticVersionStrategy('v1', '%s?version=%s'));

echo $package->getUrl('/me.png');
// /me.png?version=v1

// put the version before the path
$package = new Package(new StaticVersionStrategy('v1', 'version-%2$s/%1$s'));

echo $package->getUrl('/me.png');
// /version-v1/me.png
```

Asset URLs Base Path
--------------------

When all assets are stored in a common path, use the `PathPackage` to avoid
repeating yourself:

```php
use Symfony\Component\Asset\PathPackage;

$package = new PathPackage('/images', new StaticVersionStrategy('v1'));

echo $package->getUrl('/me.png');
// /images/me.png?v1
```

Asset URLs Base URLs
--------------------

If your assets are hosted on different domain name than the main website, use
the `UrlPackage` class:

```php
use Symfony\Component\Asset\UrlPackage;

$package = new UrlPackage('http://assets.example.com/images/', new StaticVersionStrategy('v1'));

echo $package->getUrl('/me.png');
// http://assets.example.com/images/me.png?v1
```

One technique used to speed up page rendering in browsers is to use several
domains for assets; this is possible by passing more than one base URLs:

```php
use Symfony\Component\Asset\UrlPackage;

$urls = array(
    'http://a1.example.com/images/',
    'http://a2.example.com/images/',
);
$package = new UrlPackage($urls, new StaticVersionStrategy('v1'));

echo $package->getUrl('/me.png');
// http://a1.example.com/images/me.png?v1
```

Note that it's also guaranteed that any given path will always use the same
base URL to be nice with HTTP caching mechanisms.

Named Packages
--------------

The `Packages` class allows to easily manages several packages in a single
project by naming packages:

```php
use Symfony\Component\Asset\Package;
use Symfony\Component\Asset\PathPackage;
use Symfony\Component\Asset\UrlPackage;
use Symfony\Component\Asset\Packages;
use Symfony\Component\Asset\VersionStrategy\StaticVersionStrategy;

// by default, just add a version to all assets
$versionStrategy = new StaticVersionStrategy('v1');
$defaultPackage = new Package($versionStrategy);

$namedPackages = array(
    // images are hosted on another web server
    'img' => new UrlPackage('http://img.example.com/', $versionStrategy),

    // documents are stored deeply under the web root directory
    // let's create a shortcut
    'doc' => new PathPackage('/somewhere/deep/for/documents', $versionStrategy),
);

// bundle all packages to make it easy to use them
$packages = new Packages($defaultPackage, $namedPackages);

echo $packages->getUrl('/some.css');
// /some.css?v1

echo $packages->getUrl('/me.png', 'img');
// http://img.example.com/me.png?v1

echo $packages->getUrl('/me.pdf', 'doc');
// /somewhere/deep/for/documents/me.pdf?v1
```

