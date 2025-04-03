
/**
 * This file is part of the Phalcon Framework.
 *
 * (c) Phalcon Team <team@phalcon.io>
 *
 * For the full copyright and license information, please view the LICENSE.txt
 * file that was distributed with this source code.
 */

namespace Phalcon\Storage\Adapter;

use APCUIterator;
use DateInterval;
use Exception;
use Phalcon\Storage\SerializerFactory;
use Phalcon\Support\Exception as SupportException;

/**
 * Apcu adapter
 *
 * @property array $options
 */
class Apcu extends AbstractAdapter
{
    /**
     * @var string
     */
    protected prefix = "ph-apcu-";

    /**
     * Apcu constructor.
     *
     * @param SerializerFactory $factory
     * @param array             $options
     *
     * @throws SupportException
     */
    public function __construct(<SerializerFactory> factory, array! options = [])
    {
        parent::__construct(factory, options);

        this->initSerializer();
    }

    /**
     * Flushes/clears the cache
     */
    public function clear() -> bool
    {
        var item, pattern, apc = null;
        bool result;

        let pattern = "/^" . this->prefix . "/",
            apc     = this->phpApcuIterator(pattern),
            result  = true;

        if typeof apc !== "object" {
            return false;
        }

        for item in iterator(apc) {
            if (true !== this->phpApcuDelete(item["key"])) {
                let result = false;
            }
        }

        return result;
    }

    /**
     * Decrements a stored number
     *
     * @param string $key
     * @param int    $value
     *
     * @return bool|int
     */
    public function decrement(string! key, int value = 1) -> int | bool
    {
        var result;

        this->fire(this->eventType . ":beforeDecrement", key);

        let result = this->phpApcuDec(this->getPrefixedKey(key), value);

        this->fire(this->eventType . ":afterDecrement", key);

        return result;
    }

    /**
     * Reads data from the adapter
     *
     * @param string $key
     *
     * @return bool
     */
    public function delete(string! key) -> bool
    {
        var result;

        this->fire(this->eventType . ":beforeDelete", key);

        let result = (bool) this->phpApcuDelete(this->getPrefixedKey(key));

        this->fire(this->eventType . ":afterDelete", key);

        return result;
    }

    /**
     * Stores data in the adapter
     *
     * @param string $prefix
     *
     * @return array
     */
    public function getKeys(string! prefix = "") -> array
    {
        var item, pattern, apc = null;
        array results;

        let pattern = "/^" . this->prefix . prefix . "/",
            apc     = this->phpApcuIterator(pattern),
            results = [];

        if typeof apc !== "object" {
            return results;
        }

        for item in iterator(apc) {
            let results[] = item["key"];
        }

        return results;
    }

    /**
     * Checks if an element exists in the cache
     *
     * @param string $key
     *
     * @return bool
     */
    public function has(string! key) -> bool
    {
        var result;

        this->fire(this->eventType . ":beforeHas", key);

        let result = this->phpApcuExists(this->getPrefixedKey(key));

        this->fire(this->eventType . ":afterHas", key);

        return typeof result === "bool" ? result : false;
    }

    /**
     * Increments a stored number
     *
     * @param string $key
     * @param int    $value
     *
     * @return bool|int
     */
    public function increment(string! key, int value = 1) -> int | bool
    {
        var result;

        this->fire(this->eventType . ":beforeIncrement", key);

        let result = this->phpApcuInc(this->getPrefixedKey(key), value);

        this->fire(this->eventType . ":afterIncrement", key);

        return result;
    }

    /**
     * Stores data in the adapter. If the TTL is `null` (default) or not defined
     * then the default TTL will be used, as set in this adapter. If the TTL
     * is `0` or a negative number, a `delete()` will be issued, since this
     * item has expired. If you need to set this key forever, you should use
     * the `setForever()` method.
     *
     * @param string                $key
     * @param mixed                 $value
     * @param DateInterval|int|null $ttl
     *
     * @return bool
     * @throws Exception
     */
    public function set(string! key, var value, var ttl = null) -> bool
    {
        var result;

        this->fire(this->eventType . ":beforeSet", key);

        if (typeof ttl === "integer" && ttl < 1) {
            let result = this->delete(key);

            this->fire(this->eventType . ":afterSet", key);

            return result;
        }

        let result = this->phpApcuStore(
            this->getPrefixedKey(key),
            this->getSerializedData(value),
            this->getTtl(ttl)
        );

        this->fire(this->eventType . ":afterSet", key);

        return typeof result === "bool" ? result : false;
    }

    /**
     * Stores data in the adapter forever. The key needs to manually deleted
     * from the adapter.
     *
     * @param string $key
     * @param mixed  $value
     *
     * @return bool
     */
    public function setForever(string! key, var value) -> bool
    {
        var result;

        let result = this->phpApcuStore(
            this->getPrefixedKey(key),
            this->getSerializedData(value)
        );

        return is_bool(result) ? result : false;
    }

    /**
     * @param string $key
     *
     * @return mixed
     */
    protected function doGet(string key)
    {
        return this->phpApcuFetch(this->getPrefixedKey(key));
    }

    /**
     * @todo Remove the below once we get traits
     */
    protected function phpApcuDec(var key, int step = 1) -> bool | int
    {
        return apcu_dec(key, step);
    }

    protected function phpApcuDelete(var key) ->  bool | array
    {
        return apcu_delete(key);
    }

    protected function phpApcuExists(var key) -> bool | array
    {
        return apcu_exists(key);
    }

    protected function phpApcuInc(var key, int step = 1) -> bool | int
    {
        return apcu_inc(key, step);
    }

    protected function phpApcuFetch(var key) -> var
    {
        return apcu_fetch(key);
    }

    protected function phpApcuIterator(string pattern) -> <APCUIterator> | bool
    {
        return new APCUIterator(pattern);
    }

    protected function phpApcuStore(var key, var payload, int ttl = 0) -> bool | array
    {
        return apcu_store(key, payload, ttl);
    }
}
