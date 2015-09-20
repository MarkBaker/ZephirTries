namespace Tries;

/**
 *
 * TrieCollection class
 *
 * @package Tries
 * @copyright  Copyright (c) 2013 Mark Baker (https://github.com/MarkBaker/Tries)
 * @license    http://www.gnu.org/licenses/lgpl-3.0.txt    LGPL
 */
class TrieCollection implements \Iterator, \Countable
{
    protected position = 0;

    protected entries = [];

    public function count()
    {
        return count(this->entries);
    }

    public function rewind() -> void
    {
        let this->position = 0;
    }

    public function current()
    {
        return this->entries[this->position]->value;
    }

    public function key()
    {
        return this->entries[this->position]->key;
    }

    public function next() -> void
    {
        let this->position++;
    }

    public function valid()
    {
        return isset this->entries[this->position];
    }

    public function add(<TrieEntry> value) -> void
    {
        let this->entries[] = value;
    }

    public function merge(<TrieCollection> collection) -> void
    {
        var key, value;

        for key, value in iterator(collection) {
            this->add(new TrieEntry(value, key));
        }
    }

    public function limit(quantity = 10)
    {
        let this->entries = array_slice(this->entries, 0, quantity);

        return this;
    }

    public function toArray()
    {
        return this->entries;
    }

    public function sortKeys()
    {
        usort(
            this->entries,
            function (a, b) {
                return strnatcasecmp(a->key, b->key);
            }
        );
        return this;
    }

    public function reverseKeys()
    {
        var value;

        for value in this->entries {
            let value->key = strrev(value->key);
        }
        this->sortKeys();

        return this;
    }

    protected function getKeys()
    {
        return array_map(
            function (value) {
                return value->key;
            },
            this->entries
        );
    }

    public function intersect(<TrieCollection> collection)
    {
        var keys, key, value;

        let keys = collection->getKeys();
        for key, value in this->entries {
            if !in_array(value->key, keys) {
                unset(this->entries[key]);
            }
        }
        let this->entries = array_values(this->entries);

        return this->sortKeys();
    }
}
