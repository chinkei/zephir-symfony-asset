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
use Symfony\Component\Asset\Context\NullContext;
use Symfony\Component\Asset\VersionStrategy\VersionStrategyInterface;

/**
 * Basic package that adds a version to asset URLs.
 *
 * @author Kris Wallsmith <kris@symfony.com>
 * @author Fabien Potencier <fabien@symfony.com>
 */
class Package implements PackageInterface
{
    private versionStrategy;
    private context;

    public function __construct(<VersionStrategyInterface> versionStrategy, <ContextInterface> context = null) -> void
    {
        let this->versionStrategy = versionStrategy;
        let this->context = context ?: new NullContext();
    }

    /**
     * {@inheritdoc}
     */
    public function getVersion(string! path) -> string
    {
        return this->versionStrategy->getVersion(path);
    }

    /**
     * {@inheritdoc}
     */
    public function getUrl(string! path) -> string
    {
        if this->isAbsoluteUrl(path) {
            return path;
        }

        return this->versionStrategy->applyVersion(path);
    }

    /**
     * @return ContextInterface
     */
    protected function getContext() -> <ContextInterface>
    {
        return this->context;
    }

    /**
     * @return VersionStrategyInterface
     */
    protected function getVersionStrategy() -> <VersionStrategyInterface>
    {
        return $this->versionStrategy;
    }

    protected function isAbsoluteUrl(string! url) -> boolean
    {
        return false !== strpos(url, "://") || "//" === substr(url, 0, 2);
    }
}