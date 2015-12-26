/*
 * This file is part of the Symfony package.
 *
 * (c) Fabien Potencier <fabien@symfony.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

namespace Symfony\Component\Asset;

use Symfony\Component\Asset\Context\ContextInterface;
use Symfony\Component\Asset\VersionStrategy\VersionStrategyInterface;

/**
 * Package that adds a base path to asset URLs in addition to a version.
 *
 * In addition to the provided base path, this package also automatically
 * prepends the current request base path if a Context is available to
 * allow a website to be hosted easily under any given path under the Web
 * Server root directory.
 *
 * @author Fabien Potencier <fabien@symfony.com>
 */
class PathPackage extends Package
{
    private basePath;

    /**
     * @param string                   $basePath        The base path to be prepended to relative paths
     * @param VersionStrategyInterface $versionStrategy The version strategy
     */
    public function __construct(string! basePath, <VersionStrategyInterface> $versionStrategy, <ContextInterface> $context = null) -> void
    {
        parent::__construct(versionStrategy, context);

        if !basePath {
            let this->basePath = "/";
        } else {
            if "/" != substr(basePath, 0, 1) {
                let basePath = "/" . basePath;
            }

            let this->basePath = rtrim(basePath, "/") . "/";
        }
    }

    /**
     * {@inheritdoc}
     */
    public function getUrl(string! path) -> string
    {
        if this->isAbsoluteUrl(path) {
            return path;
        }

        return this->getBasePath().ltrim(this->getVersionStrategy()->applyVersion(path), "/");
    }

    /**
     * Returns the base path.
     *
     * @return string The base path
     */
    public function getBasePath() -> string
    {
        return this->getContext()->getBasePath().this->basePath;
    }
}