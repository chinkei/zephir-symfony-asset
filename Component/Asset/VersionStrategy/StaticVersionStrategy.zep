/*
 * This file is part of the Symfony package.
 *
 * (c) Fabien Potencier <fabien@symfony.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

namespace Symfony\Component\Asset\VersionStrategy;

/**
 * Returns the same version for all assets.
 *
 * @author Fabien Potencier <fabien@symfony.com>
 */
class StaticVersionStrategy implements VersionStrategyInterface
{
    private version;
    private format;

    /**
     * @param string $version Version number
     * @param string $format  Url format
     */
    public function __construct(string! version, format = null) -> void
    {
        let this->version = version;
        let this->format  = format ?: "%s?%s";
    }

    /**
     * {@inheritdoc}
     */
    public function getVersion(string! path) -> string
    {
        return this->version;
    }

    /**
     * {@inheritdoc}
     */
    public function applyVersion(string! path) -> string
    {
        var versionized;
        var version;
        
        let version = this->getVersion(path);
        let versionized = sprintf(this->format, ltrim(path, "/"), version);

        if path && "/" == substr(path, 0, 1) {
            return "/".versionized;
        }

        return versionized;
    }
}