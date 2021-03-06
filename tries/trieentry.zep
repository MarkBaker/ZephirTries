namespace Tries;

/**
 *
 * TrieEntry class
 *
 * @package Tries
 * @copyright  Copyright (c) 2013 Mark Baker (https://github.com/MarkBaker/Tries)
 * @license    http://www.gnu.org/licenses/lgpl-3.0.txt    LGPL
 */
class TrieEntry
{
    /**
     * The key for this Trie entry
     *
     * @var   string
     **/
    public key = null;

    /**
     * The Value for this Trie entry
     *
     * @var   mixed
     **/
    public value = null;

    /**
     * @param mixed $value
     * @param mixed $key
     **/
    public function __construct(value, key = null) -> void
    {
        let this->value = value;
        let this->key = key;
    }
    
    /**
     * Allows the key for this entry to be reset
     *
     * @param mixed $key
     **/
    public function setKey(key = null) -> void
    {
        let this->key = key;
    }
}
