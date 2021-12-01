
/**
 * This file is part of the Phalcon Framework.
 *
 * (c) Phalcon Team <team@phalcon.io>
 *
 * For the full copyright and license information, please view the LICENSE.txt
 * file that was distributed with this source code.
 */

namespace Phalcon\Storage\Serializer;

/**
 * Class None
 *
 * @package Phalcon\Storage\Serializer
 */
class None extends AbstractSerializer
{
    /**
     * Serializes data
     *
     * @return string
     */
	public function serialize() -> string
	{
		return this->data;
	}

    /**
     * Unserializes data
     *
     * @param string $data
     *
     * @retrun void
     */
	public function unserialize(var data) -> void
	{
		let this->data = data;
	}
}
